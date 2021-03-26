# 포토앨범 앱
iOS 짝프로그래밍 연습 - 9팀(쏭, Hong)

## Step1. CollectionView 설정

* 프로그램 동작: 랜덤한 색상의 cell 40개가 화면에 나타난다.
* cell 개수와 크기 지정: `UICollectionViewDataSource` & `UICollectionViewDelegateFlowLayout` protocol 채택
* 랜덤 색상 구현: `UIColor` extension으로 rgb 값을 0에서 1사이 랜덤한 CGFloat 값으로 지정하는 기능 추가

<img src="https://user-images.githubusercontent.com/56751259/112561245-2a999680-8e18-11eb-8121-c5b9108f3b63.png" width=390>