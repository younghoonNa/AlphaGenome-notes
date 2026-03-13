# 4. Introduction summary

![Introduction summary](../assets/introduction/slide4-summary.png){ .figure-wide }

<div class="caption">앞의 세 장을 한 문단으로 요약하고, AlphaGenome의 research aim으로 넘어가는 슬라이드입니다.</div>

## 핵심 정리

- 대부분의 인간 유전변이는 **non-coding region**에 존재합니다.
- 이 영역의 기능 해석은 **context-dependent**하고 **cell-type-specific**하기 때문에 어렵습니다.
- sequence-to-function 모델은 DNA로부터 기능적 출력을 예측하지만,
  기존 모델들은 크게 두 가지 trade-off를 가집니다.  
  **(1) long context vs single-base resolution**, **(2) specialist vs multi-task generalist**

## Research aim

AlphaGenome의 목표는 이 두 trade-off를 동시에 완화하는 것입니다.

1. **긴 DNA 문맥**을 본다.  
2. 가능한 한 **높은 해상도**로 예측한다.  
3. RNA, accessibility, TF binding, contact map 등 **여러 modality**를 하나의 framework 안에서 다룬다.  
4. 그리고 이 예측값의 REF–ALT 차이를 이용해 **variant effect**까지 해석한다.

<div class="takeaway">

**Takeaway.**  
Introduction의 결론은 단순합니다.  
non-coding variant interpretation은 여전히 어렵고, 기존 모델에는 구조적 trade-off가 남아 있습니다.  
AlphaGenome은 이 문제를 하나의 foundation-style model로 풀어보려는 시도입니다.

</div>
