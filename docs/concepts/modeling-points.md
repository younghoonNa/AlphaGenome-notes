# ML 관점에서 바라보는 AlphaGenome Modeling Points 

이 페이지는 Figure별 biological story와는 조금 다른 각도에서, **ML 관점에서 AlphaGenome의 강점이 무엇인지**를 따로 정리한 노트입니다. 특히 **Figure 1**, **Figure 7**, **Extended Data Fig. 1**, 그리고 본문에서 연결해 주는 **Supplementary Information**의 메시지를 묶어서, 아키텍처·학습 관점의 포인트만 뽑아 봅니다.

!!! abstract "한 줄 요약"

    AlphaGenome의 핵심은 단순히 “큰 DNA 모델”, “단순 1 Mb DNA 서열 입력” 모델이 아닙니다. <br>
    이 모델은 **1 Mb 문맥**, **1 bp 수준의 localization**, **11개 modality**, **1D/2D/pairwise output**, **variant-serving latency**처럼 서로 충돌하기 쉬운 요구사항을 한 모델 안에서 동시에 만족시키려는 시도입니다. <br>
    그래서 읽는 포인트도 “다양한 Modality에서 성능이 높다”보다 **어떤 engineering compromise를 어떤 구조로 풀었는가**에 있습니다.

## 먼저 문제를 ML 문제로 다시 쓰면

AlphaGenome이 풀려는 문제를 생물학 용어를 잠깐 접어두고 ML 관점에서 보면 다음과 같습니다.

- 입력은 **1 Mb DNA sequence + organism identity** 입니다.
- 출력은 **human 5,930개 / mouse 1,128개 genome track**, 총 **11개 modality이며, 각 modality는 1bp, 128bp, 2,048bp의 다양한 해상도를** 가집니다.
- Contact map과 같이 **2차원 pairwise 구조**예측도 존재하며 그 외의 출력은 **1차원 track**입니다.
- splicing의 경우에는 개별 site 예측 (donor, acceptor 구분, 사용 빈도)만 하는 것이 아니라 **donor–acceptor pair**의 사용 빈도 즉 **junction**도 다뤄야 합니다.
- 게다가 이 모든 것을 variant scoring까지 고려한 **실제 serving 가능한 형태**로 만들어야 합니다.

즉, 이 논문은 단순한 “one more sequence-to-function model”이라기보다, **context length**, **resolution**, **output topology**, **multimodal training**, **deployment cost**를 동시에 맞추는 설계 문제로 읽는 편이 더 정확합니다.

## 한눈에 보는 설계 포인트

| 설계 포인트 | 논문에서 실제로 한 선택 | 공대 관점에서 왜 재미있는가 |
|---|---|---|
| Hybrid backbone | **U-Net-style encoder–transformer–decoder** | local motif와 long-range dependency를 분리 |
| Multi-resolution | **1 bp / 128 bp / 2,048 bp** 해상도별 head | 모든 task를 같은 resolution에 억지로 맞추지 않음 |
| Output topology 분리 | **1D embedding**과 **2D pairwise embedding**을 따로 운용 | contact map을 단순한 1D 채널로 취급하지 않음 |
| Splicing 전용 구조 | splice junction은 **exon-exon interaction**으로 예측 | general backbone 위에 track-specific head결합 |
| Sequence parallelism | **1 Mb를 131-kb chunk**로 나눠 **8개 TPU v3**에서 처리 | 1 Mb 입력과 base-level 예측 가능 |
| Two-stage training | 1. **fold-specific pretraining** <br> 2. **all-fold teachers + distilled student** | “공정한 평가용 모델”과 “배포용 모델”을 분리 |
| Distillation with mutations | teacher 출력을 모방 <br> **augmented + random mutation** 활용 | 변이 효과 예측을 실제 변이 데이터 없이 학습 |
| Multimodal learning | full multimodal vs single-modality ablation | shared representation 이점을 실험적으로 확인 |
| Long-context rule | **1 Mb로 train하고 1 Mb로 infer**할 때 가장 좋음 | inference에서 잘라서 짧게/유연하게 사용가능 |

## Model Architecture

??? note "Extended Figure 1: AlphaGenome model architecture"

    ![Extended Figure 1](../assets/figures/concept/Extended%20Figure%201.png){ .figure-wide }

## 1. Pure transformer가 아니라 U-Net + transformer인 이유

AlphaGenome의 backbone은 **U-Net-inspired architecture** 입니다. 구체적으로는 **Encoder → Transformer Tower → Decoder** 구조이고, encoder는 sequence를 downsample하고, transformer는 더 거친 해상도에서 긴 거리 상호작용을 다루고, decoder는 다시 resolution을 복원해 task-specific head로 넘깁니다.

### 왜 그냥 transformer 하나로 끝내지 않았을까?

DNA regulatory modeling에서는 두 종류의 정보가 동시에 필요합니다.

1. **매우 국소적인 정보**  
   예를 들면 splice donor/acceptor motif, TF motif, exon boundary처럼 염기 하나 또는 아주 짧은 motif 단위의 local signal입니다.

2. **상대적으로 멀리 떨어진 정보**  
   enhancer–promoter interaction처럼 수 kb~수백 kb 떨어진 위치끼리의 관계입니다.

convolution은 1번에 강하고, transformer는 2번에 강합니다. AlphaGenome은 이 둘을 억지로 하나의 inductive bias로 통일하지 않고, **local pattern은 convolution**, **distal dependency는 transformer**로 역할 분담을 시킵니다.

### 왜 U-Net 형태가 중요한가?

Extended Data Fig. 1 설명을 보면 encoder는 **1 bp에서 128 bp까지 progressively downsample**하고, decoder는 **skip connection**을 이용해 다시 **1 bp**까지 올립니다. 이 구조의 장점은 분명합니다.

- 아래로 갈수록 receptive field를 넓혀 **global context**를 보기 쉽고
- 위로 올라오면서 skip connection을 써서 **fine localization**을 회복할 수 있습니다.

즉, 이 구조는 **“멀리 떨어진 조절 정보는 봐야 하는데, exon boundary처럼 날카로운 위치 정보도 놓치면 안 된다”** 라는 문제에 꽤 자연스러운 해법입니다.

??? note "Extended Figure 1 ab: AlphaGenome model architecture (Overall)"

    ![Extended Figure 1](../assets/figures/concept/Extended%20Figure%201ab.png){ .figure-wide }

<div class="note-box">
AlphaGenome의 핵심적인 새로움은 U-Net이나 Transformer라는 개별 구성 요소 자체에 있는 것이 아니다. 오히려 중요한 점은, <span class="key-term">긴 문맥(long-range context), 염기 수준의 정밀한 해상도(base-level resolution), 멀티모달 예측(multimodality), 그리고 실제 학습이 가능한 계산 효율성(computational feasibility)</span>이라는 네 가지 요구를 동시에 만족시키는 형태로 이 구조를 정교하게 결합했다는 데 있다. 또한 AlphaGenome의 차별성은 단순한 backbone 수준에만 머무르지 않고, <span class="key-term">splice junction 예측을 위한 전용 head와 2D contact map 예측을 위한 transformer 기반 설계</span>까지 포함한다는 점에서도 드러난다. 이러한 부분은 뒤에서 각 결과 figure를 설명하면서 더 구체적으로 다루겠다.
</div>

## 2. Representation topology를 output topology에 맞췄다

AlphaGenome의 또 하나의 특징으로

1. 1D 표현과 2D Contact map 표현을 분리하였으며
2. 1번을 바탕으로 1D/2D 예측 결과를 다시 학습에 활용한다는 정보입니다.

### 1D와 2D 표현을 분리하되, 반복적으로 상호작용시키는 구조

우선 본문에서는 이 모델이 두 종류의 representation을 만든다고 설명합니다.

- **1D embeddings**: 1 bp / 128 bp 해상도의 linear genome 표현
- **2D embeddings**: 2,048 bp 해상도의 pairwise interaction 표현

RNA-seq, ATAC, DNase, CAGE, histone mark 같은 출력은 기본적으로 genome을 따라 흘러가는 1차원 signal입니다. 이런 출력은 1D embedding에서 linear head로 예측하는 것이 자연스럽습니다.

반면 contact map은 “게놈의 i 위치와 j 위치가 얼마나 자주 접촉하는가”를 묻는 pairwise matrix입니다. AlphaGenome은 중앙 transformer 단계에서 pairwise (2D) representation을 만들고, 이 2D representation을 contact map 예측에 사용할 뿐 아니라, 이를 attention bias 형태로 다시 sequence update에 반영함으로써 1D track 예측에도 간접적으로 활용하는 구조를 보여줍니다.

실제로 패널 B의 transformer tower를 보면 pair update block이 반복적으로 삽입되어 있으며, 공개된 구현 기준으로는 sequence block 사이에서 교대로(alternating하게) 2D 정보를 갱신하고 이를 다시 1D sequence representation update에 반영하는 구조임을 확인할 수 있습니다. 또한 패널 A와 패널 B의 transformer tower output를 보면, 이러한 2D representation으로부터 만들어지는 contact map 예측은 최종적으로 독립적인 head를 통해 출력된다는 것을 알 수 있습니다.

즉, 이건 단순한 implementation이 아니라 output의 topology에 맞게 latent space를 분리하면서도, 1D와 2D representation이 trunk 내부에서는 반복적으로 상호작용하도록 설계한 구조라고 볼 수 있습니다. 다시 말해, AlphaGenome은 2D contact map에 대한 background knowledge를 별도 latent space로 반영하면서도, 그 정보를 다시 1D sequence modeling에 연결하는 방향으로 설계되었다고 해석할 수 있습니다.

### Splice junction 예측을 위한 별도의 Splice junction head를 설계

본 논문의 피겨 3a에서는 Splice junction 예측을 다른 모델과 다르게 사용하는 것을 모델링 포인트로 활용한다. 더 나아가 저자들은 이 Splice junction 예측을 위해 추가적인 모델링 기법을 활용했는데, 바로 아래 그림에 존재하는 Splice junction head이다. 

??? note "Extended Figure 1 b: Splice junction head"

    ![Extended Figure 1](../assets/figures/concept/Extended%20Figure%201b_splice_junction.png){ .figure-small }

논문은 splice junction count prediction이 다른 genomic track처럼 embedding에 linear transformation만 거는 방식이 아니라, **donor–acceptor pair의 상호작용을 포착하는 별도 메커니즘**을 쓴다고 명시합니다.

즉, 저자들은 splicing을 “RNA-seq coverage의 부산물”로 보지 않았습니다. 오히려

- splice site 존재 여부
- splice site usage
- splice junction count

처럼 서로 다른 수준의 structure를 나눠서 다루고,  
junction은 특히 **pair relation**이라는 사실을 아키텍처 수준에서 반영했습니다.

이 점이 AlphaGenome의 splicing 성능이 강한 이유를 설명하는 중요한 실마리이기도 합니다.

## Sequence parallelism은 1 Mb + 1 bp 학습을 가능하게 만든 mechanism이다

논문에서는 이 부분을 길게 설명하지 않지만, 공대 관점에서 보면 sequence parallelism은 AlphaGenome의 성능에 덧붙여진 implementation detail이 아니라 모델 자체를 성립시키는 전제에 가깝다. Figure 1 legend는 1 Mb 입력을 131-kb chunk로 나누어 여러 device에 분산한다고 설명하고, 본문 역시 full 1-Mb sequence에 대한 base-pair-resolution training 이 eight interconnected TPU v3 devices 위의 sequence parallelism으로 가능해졌다고 명시한다. 즉, AlphaGenome의 1 Mb 문맥과 1 bp supervision은 backbone 아이디어만으로 얻어진 것이 아니라, 이를 실제로 학습 가능한 계산 그래프로 바꾸는 분산 학습 전략과 함께 제안된 것이다

### 1 Mb context와 1 bp output은 동시에 비싼 요구사항이다

AlphaGenome이 풀려는 문제는 단순히 “긴 서열을 본다” 수준이 아니다. 이 모델은 1 Mb 입력으로 distal regulatory interaction을 포착해야 하고, 동시에 RNA-seq, splice site, splice junction, accessibility처럼 일부 task에서는 1 bp 수준의 localization 도 유지해야 한다. Extended Data Fig. 1을 보면 encoder는 1 bp 해상도를 128 bp까지 downsample 하고, transformer tower는 그 해상도에서 long-range dependency를 처리한 뒤, decoder가 다시 1 bp까지 복원 해서 task-specific head로 보낸다. 표현 측면에서는 매우 자연스러운 설계이지만, 시스템 측면에서는 긴 sequence activation, inter-device communication, 그리고 high-resolution reconstruction을 함께 감당해야 하는 구조이다. 따라서 여기서 sequence parallelism은 속도를 조금 높이는 최적화라기보다, 이 전체 계산을 실제로 학습 가능한 범위 안으로 끌고 오는 핵심 장치라고 보는 편이 맞다.

### 핵심은 “1 Mb를 넣었다”가 아니라 “1 Mb로 학습했다”는 점이다

이 해석은 Figure 7b의 ablation과도 잘 맞는다. 저자들은 training sequence length와 inference context length를 바꾸어 비교했고, 1-Mb input으로 학습하고 inference에서도 full 1-Mb context를 사용할 때 전반적으로 가장 좋은 결과를 얻었다고 보고한다. 또한 1 Mb로 학습한 모델은 더 짧은 inference context에서도 어느 정도 성능을 유지하지만, 최적점 자체는 full 1 Mb에 놓여 있다. 즉, long context는 사후적으로 덧붙인 inference-time setting이 아니라 실제 성능을 만드는 학습 regime의 일부이며, sequence parallelism은 바로 그 regime를 가능하게 만든 system-level choice라고 해석하는 것이 자연스럽다.

### 따라서 AlphaGenome은 architecture paper이면서 동시에 systems paper의 성격도 가진다

그래서 AlphaGenome을 단순히 “U-Net + transformer backbone 위에 여러 output head를 붙인 multimodal model” 로만 읽으면 핵심의 절반만 보게 된다. 이 논문의 진짜 포인트는 long-range context, base-level resolution, multimodal output, 1D/2D topology 처럼 서로 계산적으로 충돌하기 쉬운 요구를 하나의 모델 안에 담았을 뿐 아니라, 그것이 실제 학습과 추론에서 돌아가도록 만들었다는 데 있다. 그 의미에서 sequence parallelism은 부가 기술이 아니라, AlphaGenome의 modeling claim을 현실적인 training system으로 번역해 준 핵심 enabling trick이라고 보는 편이 더 정확하다.

## 4. Multi-resolution output은 단순한 타협이 아니라 task alignment다

- RNA-seq, CAGE, PRO-cap, splicing, ATAC, DNase 등은 더 세밀한 **1 bp**
- TF ChIP-seq, histone ChIP-seq은 **128 bp**
- contact map은 **2,048 bp**

이런 식으로 **assay 성격에 맞춰 output resolution을 다르게 둡니다**. 겉으로 보면 그냥 계산 절약처럼 보일 수 있지만, 실제로는 더 본질적입니다.

### 모든 task가 같은 resolution 이득을 받는 것은 아니다

histone mark처럼 assay 자체가 더 broad한 경우에는, target resolution을 더 세밀하게 가져갔을 때의 추가 이득이 상대적으로 크지 않을 수 있습니다. 실제로 본문과 Figure 7a에서 저자들은 1-bp target resolution이 overall best라고 설명하면서도, histone ChIP-seq correlation이나 contact map correlation은 target resolution 변화에 비교적 둔감하다고 보고합니다. 또한 variant effect prediction metric 역시 gene body나 exon처럼 더 넓은 영역에 걸쳐 효과를 집계하는 경우가 많아 resolution 변화에 상대적으로 robust했습니다. 따라서 이 결과의 핵심은 “모든 task를 반드시 동일한 해상도로 예측해야 한다”가 아니라, 1 bp supervision의 필요성과 이득이 task별로 다르다는 점에 있습니다.

즉, AlphaGenome은 모든 modality를 하나의 공통 resolution에 억지로 맞추기보다, 각 assay의 label granularity와 예측 대상의 성격에 맞춰 output resolution을 다르게 두는 방향을 택합니다. Figure 1 기준으로도 RNA-seq, CAGE, PRO-cap, DNase, ATAC, splice site, splice junction, splice site usage는 1 bp, histone modification과 TF binding은 128 bp, contact map은 2,048 bp로 예측됩니다. 이 점에서 multi-resolution output은 단순한 계산 절약이 아니라, 각 task가 실제로 요구하는 supervision scale에 맞춘 설계라고 보는 편이 더 정확합니다.

## 5. Distillation은 단순한 compression이 아니라, variant robustness를 student에 이식하는 과정

AlphaGenome의 distillation은 teacher ensemble을 student 하나로 압축하는 과정이지만, 논문이 실제로 하는 일은 그보다 조금 더 적극적입니다. pretraining 이후 all-fold model들은 distillation 단계의 teacher로 사용되고, student는 frozen teacher의 출력을 재현하도록 학습됩니다. 이때 입력은 단순한 원본 sequence만이 아니라 random shift, reverse complement 같은 augmentation, 그리고 mutation perturbation까지 포함합니다. Figure 1c는 이 점을 직접 보여주고, 본문 역시 distilled student가 improved robustness와 variant effect prediction accuracy를 갖는 single model instance라고 설명합니다.

### 입력 mutation을 넣고 distill한다는 것의 의미

이 설정이 중요한 이유는, variant effect prediction이 본질적으로 서열이 조금 바뀌었을 때 model output이 어떻게 달라지는가를 묻는 문제이기 때문입니다. 그런 점에서 이 distillation은 teacher의 평균 prediction을 단순히 베끼는 과정이라기보다, sequence neighborhood에서 teacher가 보이는 반응 패턴까지 student에 옮기는 과정으로 읽을 수 있습니다. 실제로 저자들은 input sequence를 랜덤하게 mutation하지 않고 distillation했을 때 eQTL sign, eQTL causality, sQTL causality, splicing outlier에서 student 성능이 각각 −0.06, −0.01, −0.01, −0.015 떨어졌다고 보고합니다. 즉, 여기서 input perturbation은 부수적인 augmentation이 아니라, variant prediction 성능을 떠받치는 핵심 recipe 중 하나입니다.

### 공학적으로 요약하자면 

일반적인 distillation이 teacher의 pointwise response, 즉 f_teacher(x)를 student가 따라가게 만드는 설정에 가깝다면, AlphaGenome의 distillation은 perturbation된 입력을 함께 사용함으로써 x 주변 neighborhood에서의 local response까지 일부 전이시키는 방향으로 해석할 수 있습니다. student는 단지 더 작은 ensemble surrogate가 아니라, sequence perturbation에 대한 teacher의 반응을 더 잘 모사하도록 학습된 inference-efficient variant model에 가깝기 때문입니다.

## 6. Multimodal learning은 “편해서”가 아니라 실제로 도움이 된다

AlphaGenome은 11 modality를 동시에 학습하는 Multi-task (general) model입니다. 하지만 논문 이 논문의 피겨 7에서는,  **정말 multimodal learning이 도움이 되는가?**를 ablation으로 확인했다는 것입니다. Figure 7d와 Supplementary Fig. 12의 메시지는 꽤 분명합니다.

### 핵심 결과

- **fully multimodal model**이 일반적으로 single-modality model보다 더 좋았습니다.
- 다만 이 이점은 **task-dependent**였습니다.
- 예를 들어 **accessibility variant prediction**은 accessibility-only 학습으로도 꽤 잘 되지만,
- **eQTL** 같은 task는 full multimodal setting에서 더 큰 이득을 봅니다.
- single modality group을 빼도 성능 감소가 아주 크지 않은 경우가 있어, modality 사이의 **redundancy**도 어느 정도 보입니다.
- cumulative addition 실험에서는 variant effect task가 특히 **expression + accessibility**의 초기 추가에서 가장 큰 이득을 보는 경향이 있었습니다.

## 7. Long context는 train-time에 확보하는 것이 더 중요하다

Figure 7b는 AlphaGenome에서 가장 실용적인 ablation 중 하나입니다. 결론은 생각보다 명확합니다.

- **1 Mb로 train하고 1 Mb로 infer**할 때 가장 좋다.
- 짧은 sequence로 train한 모델은, 나중에 inference 때 더 긴 context를 줘도 완전히 따라오지 못한다.
- 반대로 **1 Mb로 train한 모델**은 inference 때 더 짧은 context를 써도 비교적 잘 버틴다.

이 결과는 두 가지 의미를 가집니다.

### 1) 긴 문맥은 학습 단계에서 실제로 internalized되어야 한다

단순히 inference 시점에 더 긴 sequence를 넣는다고 해서  
모델이 긴 regulatory dependency를 “갑자기” 이해하게 되지는 않습니다.  
즉, long context의 이점은 **architecture가 허용한다**는 것만으로는 부족하고,  
**training distribution 자체가 그 context를 포함해야** 합니다.

### 2) 한번 길게 학습해 두면 serving에서는 유연해진다

흥미로운 점은, 1-Mb-trained model이 shorter-context inference에서도 꽤 잘 작동한다는 것입니다.  
이 말은 곧

- train-time에는 최대한 긴 context로 representation을 익혀 두고
- serve-time에는 latency가 급하면 더 짧은 context로 타협

하는 식의 practical trade-off가 가능하다는 뜻입니다. 즉, Figure 7b는 **“학습은 길게, 추론은 필요시 유연하게”** 라는 운영 전략을 뒷받침해 줍니다.

## 8. 이 논문이 남기는 설계 법칙

Figure와 Supplementary Information을 묶어서 보면, AlphaGenome이 주는 engineering lesson은 꽤 선명합니다.

### (1) 모든 task를 같은 출력 공간에 넣지 말 것
1D track, 2D contact map, donor–acceptor pair는 문제의 topology가 다릅니다. shared representation & backbone은 공유하되, **output structure는 존중**해야 합니다.

### (2) local과 global을 같은 모듈 하나에 억지로 맡기지 말 것
motif-scale localization과 enhancer-scale context는 서로 다른 계산 성질을 갖습니다. AlphaGenome은 convolution과 transformer를 섞어 이 문제를 해결합니다.

### (3) honest evaluation model과 deployable model을 분리할 것
fold-specific model은 generalization을 보기 좋고, distilled student는 serving하기 좋습니다. 두 목적을 하나의 artifact에 모두 강요하지 않는 설계가 중요합니다.

### (4) distillation은 latency 절감 이상의 역할을 할 수 있다
특히 variant effect처럼 input perturbation이 본질인 문제에서는 mutation-aware distillation이 **robustness recipe**가 될 수 있습니다.

### (5) multimodal learning은 integrative task에서 특히 강하다
expression, accessibility, splicing처럼 서로 다른 분자 readout이 함께 묶일 때 shared representation의 가치가 커집니다.

### (6) 가능하면 train은 길게 하라
긴 context의 이점은 inference 때 우연히 생기지 않습니다. 학습 단계에서부터 긴 dependency를 보게 해야 합니다.

## 마무리

생물학적으로 보면 AlphaGenome은 regulatory code를 더 잘 푸는 모델이지만, ML 관점으로 보면 더 흥미로운 점은 따로 있습니다.

이 모델은

- **긴 문맥**을 보면서
- **아주 정밀한 위치 정보**를 잃지 않고
- **서로 다른 형태의 출력**을 함께 다루고
- **ensemble 수준의 지식**을 student 하나로 옮겨
- **실제 variant serving**까지 감당하는

상당히 균형 잡힌 시스템 설계, Foundation model의 정석입니다.

그래서 AlphaGenome에서 배울 포인트는 단순히 “genomics에서도 foundation model이 된다”가 아니라, **long-context multimodal sequence model을 실제로 굴리려면 어떤 타협과 구조가 필요한가**에 더 가깝습니다.

## Source anchors

- Main paper: [Advancing regulatory variant effect prediction with AlphaGenome](https://www.nature.com/articles/s41586-025-10014-0)
- 특히 보면 좋은 부분:
  - **Figure 1a–c**: 전체 architecture, pretraining, distillation
  - **Figure 7**: resolution / context / distillation / multimodal ablation
  - **Extended Data Fig. 1**: encoder–transformer–decoder 내부 구조
  - **Supplementary Information / Supplementary Fig. 12**: modality 조합별 추가 실험
