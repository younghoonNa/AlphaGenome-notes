# Figure 1 Panel D & E

![Figure 1 panels D and E](../assets/figures/figure1/panels-de-benchmarks.png){ .figure-wide }

패널 D는 fold-split 모델을 이용해서 전반적인 **genome track prediction 성능**을 평가한 결과입니다. 표의 왼쪽에는 어떤 modality와 task를 평가했는지, metric이 무엇인지, 그리고 어떤 resolution에서 평가했는지가 나와 있습니다. 여기서 **value**는 AlphaGenome 자체의 절대 성능이고, 오른쪽 **comparison**은 기존 최고 모델 대비 얼마나 향상되었는지를 의미합니다.

핵심은 대부분의 genome track prediction task에서 AlphaGenome이 기존 모델보다 더 좋은 성능을 보였다는 점입니다. 논문 요약 기준으로는 **24개 task 중 22개**에서 SOTA를 달성했다고 정리할 수 있습니다.

같은 그림의 패널 E는 **variant effect prediction** 결과를 보여줍니다. 즉, 변이가 생겼을 때 발현량, splicing, accessibility, TF binding 같은 출력이 어떻게 달라지는지를 예측하는 task입니다. 여기서 direction은 증가·감소의 방향을 맞추는 것이고, correlation은 변화의 크기까지 포함한 연속적인 패턴을 얼마나 잘 맞추는지를 보는 지표로 이해하면 됩니다.

이 variant effect prediction에서도 AlphaGenome은 대부분의 benchmark에서 기존 모델보다 더 좋은 성능을 보였고, 논문 요약 기준으로는 **26개 task 중 25개**에서 최고 성능을 기록했습니다.

??? note "Which tasks were not SOTA?"

    Figure 1의 headline 결과는 각각 **Track prediction (Panel D) 22/24**와 **Variant effect prediction (Panel E) 25/26**이므로, AlphaGenome이 거의 모든 benchmark에서 strongest baseline을 넘어서지만, 일부 평가지표에서 성능이 떨어짐을 보여준다.

    Supplementary CSV를 기준으로 보면, Track prediction (Panel D)에서 strongest baseline을 넘지 못한 task는 Display되어있는 CAGE 항목을 포함해 총 2개다. 다른 하나는 splicing task인 **splice_site_prediction_annotated_human (1 bp, auPRC)** 로, strongest baseline인 **DeltaSplice** 가 **0.8504**, AlphaGenome이 **0.8194**를 기록해 relative improvement는 **−3.65%**였다. 나머지 예외인 **CAGE (128 bp, pearsonr)** 에서는 **Enformer (human fine-tuned)** 이 **0.711985**, AlphaGenome이 **0.709744**로 relative improvement는 **−0.315%**였다.

    **Variant effect prediction (Panel E)** 에서는 유일한 예외가 **MFASS** benchmark이다. 이 task의 strongest baseline은 **Pangolin**이며, Figure 1e에서는 relative improvement가 **−5.7**로 표시된다.

<div class="takeaway">

Figure 1의 benchmark 메시지는 명확합니다.  
AlphaGenome은 다양한 modality를 동시에 다루는 **generalist model**이면서도,  
단순한 genome track prediction뿐 아니라 **variant effect prediction에서도 매우 강한 성능**을 보입니다.

</div>
