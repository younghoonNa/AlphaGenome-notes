# Regulatory variants are difficult to interpret

<div class="kicker">Introduction · Slide 1</div>

<div class="metric-row">
  <div class="metric"><span class="metric-label">Core problem</span><span class="metric-value">Non-coding variant interpretation</span></div>
  <div class="metric"><span class="metric-label">Biology</span><span class="metric-value">TF binding, chromatin, histone, 3D genome</span></div>
  <div class="metric"><span class="metric-label">Important nuance</span><span class="metric-value">Cell-type specificity</span></div>
</div>

![Introduction slide 1](../assets/introduction/01-regulatory-variants.png){ .slide-image }
<p class="small-caption">Intro slide 1. Regulatory variant interpretation is difficult because many non-coding effects are context-dependent and cell-type-specific.</p>

## 핵심 메시지

<div class="callout-strong">
  regulatory variant는 다양한 non-coding regulatory mechanism을 통해 작동하고, 그 효과는 세포 유형에 따라 달라질 수 있습니다. 그래서 non-coding region의 variant interpretation은 여전히 큰 병목입니다.
</div>

## 설명 구조

<div class="two-col">
<div class="slide-card" markdown>

### 왼쪽 패널: 왜 non-coding이 어려운가

- regulatory variant는 **유전자 발현 조절에 영향을 주는 변이**를 뜻합니다.
- 이런 변이의 상당수는 **non-coding 영역**에 존재합니다.
- 이 영역에서는 아래와 같은 다양한 조절 기전이 동시에 작동합니다.
  - TF binding
  - chromatin openness / accessibility
  - histone modification
  - 3D genome structure
  - ncRNA 관련 조절
- 따라서 non-coding에 변이가 생기면 단순히 한 개의 output만 바뀌는 것이 아니라,
  여러 조절 축을 통해 간접적으로 기능 변화가 나타날 수 있습니다.

</div>
<div class="slide-card" markdown>

### 오른쪽 패널: 왜 cell type이 중요한가

- eQTL은 **유전변이에 따라 유전자 발현량이 달라지는 현상**입니다.
- 같은 위치의 variant라도 세포 유형이 달라지면,
  발현에 미치는 효과의 방향이나 크기가 바뀔 수 있습니다.
- 슬라이드에서는:
  - **Cell type 1**: a allele copy가 늘수록 expression이 증가
  - **Cell type 2**: genotype이 바뀌어도 expression 변화가 거의 없음
- 즉, variant effect는 **context-dependent** 하고 **cell-type-specific** 입니다.

</div>
</div>

## 발표 대본

??? note "Speaker notes (KR)"

    먼저 regulatory variant는 유전자 발현 조절에 영향을 주는 변이를 의미합니다. 이런 변이의 상당수는 non-coding 영역에 존재합니다.

    왼쪽 그림을 보시면, non-coding 영역에서는 transcription factor binding, chromatin 접근성, histone modification, 3차원 게놈 구조처럼 다양한 조절 기전이 작동하고 있습니다.
    따라서 이 영역에 변이가 생기면, 이러한 조절 기전에 영향을 주어 기능적 변화를 일으킬 수 있습니다.

    뿐만 아니라 이런 효과는 세포 유형에 따라서도 다르게 나타날 수 있습니다.
    오른쪽 그림의 eQTL은 유전변이에 따라 유전자 발현량이 달라지는 현상을 의미합니다.
    여기서 대문자 A와 소문자 a는 같은 위치의 두 대립유전자를 뜻하고, 아래의 그림은 AA, Aa, aa가 각각 그 유전자형을 나타냅니다.

    왼쪽 cell type 1에서는 소문자 a 대립유전자의 개수가 많아질수록 발현량이 증가하는 반면,
    오른쪽 cell type 2에서는 유전자형이 달라져도 발현량 차이가 거의 없습니다.
    즉, 같은 variant라도 세포 유형에 따라 효과가 다르게 나타날 수 있다는 뜻입니다.

    정리하면, regulatory variant는 다양한 조절 기전을 통해 작용하고 그 효과도 세포 유형 특이적으로 나타날 수 있기 때문에,
    non-coding 영역에서의 variant interpretation은 여전히 중요한 해석상의 어려움으로 남아 있습니다.

## Slide takeaway

- **non-coding region**은 해석해야 할 조절 기전이 많습니다.
- **variant effect**는 단일한 값이 아니라 **context-dependent phenomenon**입니다.
- AlphaGenome의 필요성은 바로 이 복잡한 regulatory landscape에서 출발합니다.

<div class="slide-nav">
  <a href="../">← Introduction overview</a>
  <a href="../02-context-resolution-tradeoff/">Next: context–resolution trade-off →</a>
</div>
