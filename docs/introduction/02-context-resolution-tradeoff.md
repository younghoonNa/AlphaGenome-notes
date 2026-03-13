# Sequence-to-function AI: the context–resolution trade-off

<div class="kicker">Introduction · Slide 2</div>

<div class="metric-row">
  <div class="metric"><span class="metric-label">Short-context example</span><span class="metric-value">DeepSEA · ~1 kb input · 1 bp output</span></div>
  <div class="metric"><span class="metric-label">Long-context example</span><span class="metric-value">Enformer · ~100 kb input · 128 bp output</span></div>
  <div class="metric"><span class="metric-label">Trade-off</span><span class="metric-value">More context, lower base-level resolution</span></div>
</div>

![Introduction slide 2](../assets/introduction/02-context-resolution-tradeoff.png){ .slide-image }
<p class="small-caption">Intro slide 2. Extending the receptive field helps capture long-range regulation, but often lowers output resolution.</p>

## 핵심 메시지

<div class="callout-strong">
  sequence-to-function AI는 DNA 서열에서 functional genomic signal을 예측해 variant effect를 추정할 수 있지만, 긴 genomic context를 보기 시작하면 single-base 수준의 정밀도는 떨어지는 경우가 많습니다.
</div>

## 설명 구조

<div class="two-col">
<div class="slide-card" markdown>

### 왼쪽 패널: short-context model의 장점

- DeepSEA류 모델은 짧은 DNA window를 입력으로 사용합니다.
- 이런 구조는:
  - local motif 변화
  - nearby sequence context
  - allele-specific chromatin effect
  를 **정밀하게 비교**하는 데 강점이 있습니다.
- 특히 output이 1bp 수준이면 특정 염기 치환이 만드는 미세한 차이를 잘 추적할 수 있습니다.

</div>
<div class="slide-card" markdown>

### 오른쪽 패널: long-context model의 장점과 한계

- Enformer류 모델은 더 긴 receptive field를 사용해
  enhancer–promoter interaction 같은 **장거리 조절 문맥**을 반영합니다.
- 하지만 output이 128bp bin이면,
  특정 nucleotide 하나의 영향보다 **주변 bin의 평균적 signal**을 더 많이 보게 됩니다.
- 따라서 context는 늘어나지만 single-base precision은 낮아집니다.

</div>
</div>

## 발표 대본

??? note "Speaker notes (KR)"

    이러한 어려움을 해결하기 위해 등장한 것이 sequence-to-function AI 모델입니다.
    이 계열의 모델은 DNA 서열을 입력으로 받아 chromatin 접근성, transcription factor binding,
    histone mark와 같은 기능적 출력을 예측하고, reference 알렐과 alternative 알렐 사이의 예측 차이를 비교함으로써 variant effect를 추정합니다.

    예를 들어 이 슬라이드에 제시된 DeepSEA는 약 1000bp 정도의 비교적 짧은 DNA 서열을 입력으로 사용합니다.
    이런 구조는 국소적인 motif 변화나 주변 짧은 문맥에서 발생하는 효과를 비교적 정밀하게 포착하는 데에는 강점이 있습니다.

    하지만 한계도 있습니다.
    1000bp라는 입력 길이는 single-base 수준의 정밀한 예측에는 적합하지만,
    더 멀리 떨어진 enhancer–promoter interaction이나 장거리 context를 충분히 반영하기에는 짧습니다.

    그래서 이후 모델들은 더 긴 genomic context를 보기 위해 입력 길이를 100kb 수준까지 확장했습니다.
    하지만 이런 모델들은 출력이 128bp bin 단위로 주어지는 경우가 많아서,
    특정 염기서열 위치에서의 세밀한 변화보다는 주변 구간의 평균적인 정보를 보게 됩니다.

    즉, 긴 문맥을 볼 수 있게 되면서 context는 늘어났지만,
    반대로 single-base 수준의 resolution은 떨어지게 됩니다.
    이것이 sequence-to-function AI에서 중요한 context–resolution trade-off라고 볼 수 있습니다.

## Slide takeaway

- **Short-context / high-resolution** 모델은 local effect를 정밀하게 잡습니다.
- **Long-context / lower-resolution** 모델은 distal regulation을 더 잘 반영합니다.
- 기존 모델은 이 둘을 동시에 만족시키기 어려웠고, AlphaGenome은 이 균형을 다시 잡으려는 시도입니다.

<div class="slide-nav">
  <a href="../01-regulatory-variants/">← Previous: regulatory variants</a>
  <a href="../03-multitask-tradeoff/">Next: multi-task trade-off →</a>
</div>
