# Sequence-to-function AI: the multi-task trade-off

<div class="kicker">Introduction · Slide 3</div>

<div class="metric-row">
  <div class="metric"><span class="metric-label">Specialist</span><span class="metric-value">Pangolin · splice-specific · high precision</span></div>
  <div class="metric"><span class="metric-label">Generalist</span><span class="metric-value">Borzoi · multi-modal · broader scope</span></div>
  <div class="metric"><span class="metric-label">Trade-off</span><span class="metric-value">Wider coverage can reduce task-specific peak performance</span></div>
</div>

![Introduction slide 3](../assets/introduction/03-multitask-tradeoff.png){ .slide-image }
<p class="small-caption">Intro slide 3. Generalist models cover more modalities, but may underperform specialist models on a specific task such as splicing.</p>

## 핵심 메시지

<div class="callout-strong">
  기존 sequence-to-function AI는 특정 task에 최적화된 specialist model과 여러 modality를 함께 다루는 generalist model로 나뉘어 왔습니다. 적용 범위가 넓어질수록 특정 task에서 최고 성능을 내기는 더 어려워집니다.
</div>

## 설명 구조

<div class="two-col">
<div class="slide-card" markdown>

### 왼쪽 패널: Pangolin은 specialist

- Pangolin은 splicing에 특화된 task-specific model입니다.
- splice donor / splice acceptor 관련 prediction에 집중하기 때문에
  **single-base resolution**과 높은 task fit을 노릴 수 있습니다.
- 즉, 모델의 범용성보다는 **특정 task의 깊이**를 선택한 사례입니다.

</div>
<div class="slide-card" markdown>

### 오른쪽 패널: Borzoi는 generalist

- Borzoi는 더 긴 입력을 보고, 여러 functional output을 함께 예측하는 multi-task model입니다.
- coverage는 넓지만 output resolution이 32bp bin 수준이라,
  splicing site처럼 base-level localization이 중요한 task에서는 불리할 수 있습니다.
- 실제로 이런 generalist 모델은 특정 benchmark에서 specialist보다 낮은 성능을 보일 수 있습니다.

</div>
</div>

## 발표 대본

??? note "Speaker notes (KR)"

    그 다음으로는 멀티모달리티 trade-off입니다.

    짧게 말씀드리면, 기존 sequence-to-function AI 모델들은 대체로 특정 task에 특화된 task-specific model이거나,
    여러 modality를 함께 다루는 multi-task model로 나눌 수 있습니다.

    왼쪽의 Pangolin은 대표적인 task-specific model입니다.
    이 모델은 약 10,000개 정도의 입력 서열을 바탕으로,
    각 염기 위치가 splice donor site인지 splice acceptor site인지를 single-base 수준에서 예측합니다.
    즉, splicing이라는 특정 task에 매우 특화되어 있고, 그만큼 높은 해상도와 높은 정확도를 목표로 한 모델입니다.

    반면 오른쪽의 Borzoi는 더 긴 입력 문맥을 보고,
    더 다양한 functional output을 함께 예측하는 멀티-태스크 모델입니다.
    입력 길이는 약 524kb로 훨씬 길지만, 출력은 32bp bin 단위로 주어지기 때문에 해상도는 상대적으로 낮습니다.

    그리고 중요한 점은, 이렇게 여러 modality를 함께 다루는 generalist model은 적용 범위는 넓지만,
    특정 task에서는 specialist model보다 성능이 떨어질 수 있다는 점입니다.

    본문 Figure 3에서 다시 보겠지만, 출력 해상도가 32bp로 낮기 때문에
    splicing site, splicing variant 예측에서는 다른 specific model보다 낮은 성능을 기록합니다.

    즉, 이 슬라이드의 핵심은 여러 modality를 폭넓게 다룰수록 범용성은 높아지지만,
    특정 task의 정밀도나 정확도는 오히려 떨어질 수 있다는 것입니다.

## Slide takeaway

- **Specialist**는 좁고 깊습니다.
- **Generalist**는 넓고 강건하지만, 특정 task의 SOTA를 항상 보장하지는 않습니다.
- AlphaGenome은 long context, high resolution, multi-modal output을 동시에 다루려는 foundation-model 방향의 시도입니다.

<div class="slide-nav">
  <a href="../02-context-resolution-tradeoff/">← Previous: context–resolution trade-off</a>
  <a href="../04-summary/">Next: introduction summary →</a>
</div>
