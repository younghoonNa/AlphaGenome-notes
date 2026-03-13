# Paper Overview

이 섹션은 **발표 자료를 문서형으로 다시 풀어쓴 요약**입니다.

## 추천 흐름

- 먼저 [Introduction overview](../introduction/index.md)에서 문제 설정을 정리합니다.
- 그다음 [Figure 1](../figures/figure1.md)부터 [Figure 4](../figures/figure4.md)까지 읽으면,
  모델 구조 → 정성적 예측 → splicing variant effect → expression variant effect 흐름이 이어집니다.

## 이 논문의 큰 메시지

AlphaGenome은 긴 DNA 문맥을 입력으로 받아 여러 functional genomics modality를 동시에 예측하면서,  
그 예측값의 REF–ALT 차이를 이용해 variant effect까지 해석하려는 **generalist foundation model**입니다.
