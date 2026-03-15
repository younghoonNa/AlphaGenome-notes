# Introduction overview

1. **Regulatory variants are difficult to interpret**  
   non-coding regulation이 왜 해석하기 어려운지, 그리고 cell-type-specific eQTL의 의미를 설명합니다.

2. **Sequence-to-function AI: context–resolution trade-off**  
   짧은 문맥에서 높은 해상도를 얻는 모델과, 긴 문맥을 보지만 bin resolution을 쓰는 모델 사이의 trade-off를 설명합니다.

3. **Sequence-to-function AI: multi-task trade-off**  
   splicing specialist model과 multi-task generalist model의 차이를 설명합니다.

## 핵심 정리

- complex trait와 질병 연관 변이의 상당수는 **non-protein-coding sequence**에 위치하며,
  이들을 기능적으로 해석하는 일은 여전히 어렵습니다.[1]
- 이 문제를 다루기 위해 sequence-to-function 모델이 발전해 왔지만,
  각 모델은 대체로 특정 강점에 집중해 왔습니다.
  예를 들어 DeepSEA는 **single-nucleotide sensitivity**로 noncoding variant effect prediction을 제시했고,[2]
  Enformer는 더 긴 문맥을 보기 위해 **long-range interaction**을 통합했으며,[3]
  Borzoi는 RNA-seq coverage를 통해 transcription, splicing, polyadenylation을 함께 다루도록 확장했습니다.[4]
- 따라서 Introduction의 핵심 메시지는,
  regulatory variant interpretation에서 필요한 요소들
  즉 **긴 DNA 문맥, 높은 해상도, 다양한 regulatory modality, variant effect scoring**이
  기존에는 여러 모델에 분산되어 있었다는 점입니다.

## Research aim

이 Introduction에서 정리되는 AlphaGenome의 연구 목표는,
DeepSEA가 보여준 nucleotide-level variant scoring,[2]
Enformer가 확장한 long-range sequence context,[3]
그리고 Borzoi가 확장한 transcription 및 RNA processing prediction 범위를[4]
하나의 sequence model 안에서 더 넓게 통합하는 것으로 이해할 수 있습니다.

즉, 이 페이지의 문제 설정은 다음과 같이 정리할 수 있습니다.

1. **긴 DNA 문맥**을 보면서도,[3]  
2. 가능한 한 **높은 해상도**의 예측력을 유지하고,[2]  
3. expression, accessibility, histone marks, TF binding, contact maps, splicing처럼 **여러 regulatory modality를 함께 다루며,[4]**  
4. 최종적으로는 각 allele 간 예측 차이를 이용해 **regulatory variant effect interpretation**으로 연결하는 것입니다.

<div class="takeaway">

<strong>Takeaway.</strong><br>
Introduction의 결론은 단순합니다.<br>
non-coding variant interpretation은 여전히 어렵고, 기존 모델에는 구조적 trade-off가 남아 있습니다.<br>
AlphaGenome은 이 문제를 하나의 foundation-style model로 풀어보려는 시도입니다.

</div>

## Reference

[1] Gaulton KJ, Preissl S, Ren B. *Interpreting non-coding disease-associated human variants using single-cell epigenomics*. **Nature Reviews Genetics**. 2023;24:516-534.

[2] Zhou J, Troyanskaya OG. *Predicting effects of noncoding variants with deep learning-based sequence model*. **Nature Methods**. 2015;12(10):931-934.

[3] Avsec Ž, Agarwal V, Visentin D, et al. *Effective gene expression prediction from sequence by integrating long-range interactions*. **Nature Methods**. 2021;18(10):1196-1203.

[4] Linder J, Srivastava D, Yuan H, Agarwal V, Kelley DR. *Predicting RNA-seq coverage from DNA sequence as a unifying model of gene regulation*. **Nature Genetics**. 2025;57(4):949-961.
