# 포토앨범 앱
iOS 짝프로그래밍 연습 - 9팀(쏭, Hong)

## Step1. CollectionView 설정

* 프로그램 동작: 랜덤한 색상의 cell 40개가 화면에 나타난다.
* cell 개수와 크기 지정: `UICollectionViewDataSource` & `UICollectionViewDelegateFlowLayout` protocol 채택
* 랜덤 색상 구현: `UIColor` extension으로 rgb 값을 0에서 1사이 랜덤한 CGFloat 값으로 지정하는 기능 추가

<img src="https://user-images.githubusercontent.com/56751259/112561245-2a999680-8e18-11eb-8121-c5b9108f3b63.png" width=390>

#### 완료날짜 : 2021년 03월 22일 (월) 18:00

# Photos 라이브러리


## Step2. 사진보관함 사진 가져오기

* 네비게이션 컨트롤러 임베드
* PHAsset 프레임워크 사용해서 사진 보관함에 있는 사진을 셀에 표시
* PHCachingImageManager를 사용해서 이미지 크기 조정
* PHPhotoLibrary 클래스를 이용해서 사진 보관함 변경 여부 확인

![스크린샷 2021-03-26 오후 4 52 14](https://user-images.githubusercontent.com/73683735/112599789-b8df3e00-8e53-11eb-9090-d3f6e8b844d2.png)

#### 완료날짜 : 2021년 03월 23일 (화) 18:00

## Step3. GCD로 효율적인 이미지 다운로드 및 화면 표시

* 프로그램 동작: 네비게이션바에 좌측 +버튼을 누르면 Google의 doodle 이미지가 cell에 나타난다.
* JSON파일을 다운로드 받아서 프로젝트에 추가, 파싱한 데이터를 이미지로 변환해 셀에 표시
* UIMenuItem을 이용해 이미지를 사진보관함에 저장

#### 완료날짜 : 2021년 03월 23일 (화) 18:00

