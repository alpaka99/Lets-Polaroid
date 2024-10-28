# MySplashed


`문득 생각나는 폴라로이드 사진처럼`

> 사진 검색 및 마음에 드는 사진을 저장 할 수 있는 앱


<img src="https://github.com/user-attachments/assets/11856c10-25e1-45c6-bce5-c1e4cb09c0f5" width=200 />
<img src="https://github.com/user-attachments/assets/af2d3154-1c7c-446e-889e-fa681e6fa471" width=200 />
<img src="https://github.com/user-attachments/assets/e41c756b-8643-43de-b83f-fb428d52c4c5" width=200 />
<img src="https://github.com/user-attachments/assets/10c78cef-6ac6-4116-a705-e50c6bea9f5c" width=200 />





## 프로젝트 주요 기능


- Unsplash 서버에서 사진 검색 및 이미지 가져오기 기능
- 현재 인기있는 토픽에 대한 사진을 사용자에게 보여주는 기능
- 좋아요를 누른 사진을 핸드폰에 저장하고, 네트워크에 연결되어있지 않아도 볼 수 있게 해주는 기능
- 프로필 작성을 통해 사용자 정보를 앱에 저장 및 수정하는 기능

## 프로젝트 개발 환경


- **개발 인원**
    - iOS 개발자 1명
- **개발 기간**
    - 8일(24.07.22~24.07.29)

## 프로젝트 기술 스택


- **활용 기술 및 키워드**
    - **iOS:** iOS 15.0+, swift 5.10, xcode 15.3
    - **Architecture:** MVVM
    - **Network:** Alamofire
    - **UI:** CodeBaseUI, Snapkit, Kingfisher
    - **Database:** Realm
- **라이브러리**

| **라이브러리** | **사용 목적** | **Version** |
| --- | --- | --- |
| Alamofier | 네트워크 서버와의 통신 | 5.9.1 |
| SnapKit | CodeBaseUI 구현 | 6.8.0 |
| KingFisher | 이미지 데이터 비동기 다운로드 | 8.0.3 |

## 폴더 구조


```
MySplashed
 ┣ App
 ┃ ┣ LaunchScreen.storyboard
 ┃ ┣ AppDelegate.swift
 ┃ ┣ Config.xcconfig
 ┃ ┣ Info.plist
 ┃ ┗ SceneDelegate.swift
 ┣ Bases
 ┃ ┣ BaseCollectionViewCell.swift
 ┃ ┣ BaseView.swift
 ┃ ┗ BaseViewController.swift
 ┣ Domain
 ┃ ┣ DetailPhoto
 ┃ ┃ ┣ Models
 ┃ ┃ ┗ Repository
 ┃ ┣ Like
 ┃ ┃ ┗ Repository
 ┃ ┣ ProfileSetting
 ┃ ┣ Search
 ┃ ┃ ┣ Models
 ┃ ┃ ┗ Repository
 ┃ ┣ SplashView
 ┃ ┗ Topic
 ┃ ┃ ┗ Repository
 ┣ Presenter
 ┃ ┣ Main
 ┃ ┃ ┣ DetailPhoto
 ┃ ┃ ┃ ┣ View
 ┃ ┃ ┃ ┣ ViewController
 ┃ ┃ ┃ ┗ ViewModel
 ┃ ┃ ┣ Like
 ┃ ┃ ┃ ┣ View
 ┃ ┃ ┃ ┣ ViewController
 ┃ ┃ ┃ ┗ ViewModel
 ┃ ┃ ┣ Search
 ┃ ┃ ┃ ┣ View
 ┃ ┃ ┃ ┣ ViewController
 ┃ ┃ ┃ ┗ ViewModel
 ┃ ┃ ┗ Topic
 ┃ ┃ ┃ ┣ View
 ┃ ┃ ┃ ┣ ViewController
 ┃ ┃ ┃ ┗ ViewModel
 ┃ ┣ OnBoarding
 ┃ ┃ ┣ ProfileSelect
 ┃ ┃ ┃ ┣ View
 ┃ ┃ ┃ ┣ ViewController
 ┃ ┃ ┃ ┗ ViewModel
 ┃ ┃ ┣ ProfileSetting
 ┃ ┃ ┃ ┣ View
 ┃ ┃ ┃ ┣ ViewController
 ┃ ┃ ┃ ┗ ViewModel
 ┃ ┃ ┗ Splash
 ┃ ┃ ┃ ┣ View
 ┃ ┃ ┃ ┣ ViewContoller
 ┃ ┃ ┃ ┗ ViewModel
 ┃ ┣ Reusable
 ┃ ┗ TabBar
 ┣ Utils
 ┃ ┣ Constants
 ┃ ┣ Extensions
 ┃ ┣ Managers
 ┃ ┣ Models
 ┃ ┣ Observable
 ┃ ┣ Protocols
 ┃ ┗ Routers
 ┗ Resoureces
   ┗ Assets.xcassets
     ┣ Profile
     ┗ TabBar
 
```
