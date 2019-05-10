# CAU 알림 (중앙대학교 키워드 알리미)

## 0. 아이콘(Icon)
<img width="150" alt="white-ver" src="https://user-images.githubusercontent.com/38272356/57304214-e44ec780-7119-11e9-9b42-4e1180e12845.png">

---

## 1. 목적(Purpose)
 * 중앙대학교에는 CAU NOTICE부터 도서관, 기숙사, 학과별 홈페이지까지 다양한 종류의 사이트가 존재한다.
 * 이렇게 흩어져 있는 공지사항을 하나로 모을 방법이 없을까?
 * 선택한 웹사이트의 공지사항에 사용자가 등록한 **키워드**가 등장하면 애플리케이션에 푸시 알림을 보내주자.
 * 언제까지 입소문에만 의지할 것인가!! 직접 찾아내자. ~~핑프 탈출!~~

---

## 2. 멤버(Members)
 * [18changsung](https://github.com/18changsung)
 
---

## 3. 사용자 인터페이스(User Interface)
 * Main View &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; TimeLine View &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Preference View 
 
 <img width="200" alt="hashview" src="https://user-images.githubusercontent.com/38272356/57475936-6a147380-72d0-11e9-9b84-4fcd51e44b52.PNG">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="200" alt="hashview" src="https://user-images.githubusercontent.com/38272356/57475880-481af100-72d0-11e9-8edc-4587aa2f1a9c.PNG">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img width="200" alt="hashview" src="https://user-images.githubusercontent.com/38272356/57475878-46512d80-72d0-11e9-8318-69c4d31e5228.PNG">
 
---

## 4. 개발계획(Dev Plan)
 * iOS기반 애플리케이션으로 개발 예정 - Swift4 (추후 안드로이드 개발)
 * 크롤링 - Python 3.6 (Anaconda)
 * ~~cron/scheduler 사용~~ => Amazon Web Service(AWS) EC2 사용
 * ~~Django 사용, SqliteDB 구축, API 서버~~ => Firebase 사용 

---

## 5. 개발일지(Progress)
 * 2018/01/09 
    - 프로젝트 진행 계획 토의 및 발표
    - Adobe XD로 Application Prototype 제작 완료.             
    - 중앙대학교 CAUNOTICE, 학술정보원, 생활관(기숙사), 창의ICT공과대학, 소프트웨어학부 공지사항 크롤링 완료.
 * 2018/01/15 ~ 01/16
    - Python Program에서 Firebase Data set, update method 구현 완료
 * 2019/02/01
    - Firebase iOS SDK를 이용하여 App에 데이터 불러오기 성공.
 * 2019/02/06
    - DataCenter.swift 파일을 추가하여 App 내 데이터 저장 및 관리.
 * 2019/02/06 ~ 02/20
    - 앱 아이콘 추가, 앱 디자인 수정 등
 * 2019/02/20 ~ 03/01
    - 앱 UI 대부분 완성, 키워드 등록 및 DB와 비교 알고리즘 작성.
    - iOS 앱 상에서 구현해야하는 Frontend/Backend 사실상 완료.
 * 2019/05/07 ~
    - Firebase를 이용한 Authentication 구현 (사용자 관리).
---

##### 고독한 개발자
