# CAU 알림 (중앙대학교 키워드 알리미)

## 0. 아이콘(Icon)
<img width="150" alt="white-ver" src="https://user-images.githubusercontent.com/38272356/53298781-eec92700-3875-11e9-8698-7661cdfa355f.png">

---

## 1. 목적(Purpose)
 * 중앙대학교 공지사항에 사용자가 설정한 **키워드**가 등장하면 애플리케이션에 알림을 보내주자.
 * 언제까지 학교에서 주는 정보만 기다릴 것인가!! 직접 찾아내자.
 ~~* 핑프 탈출~~

---

## 2. 멤버(Members)
 * [18changsung](https://github.com/18changsung), [AllyHyeseongKim](https://github.com/AllyHyeseongKim)
 
---

## 3. 사용자 인터페이스(User Interface)
 * Main View
 <img width="200" alt="hashview" src="https://user-images.githubusercontent.com/38272356/53298796-2c2db480-3876-11e9-8b10-800f56d3c5ad.jpeg">
 
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
 * 2019/02/20 ~
    - 앱 UI 대부분 완성, 키워드 등록 및 DB와 비교 알고리즘 작성.
---

~~###### 이 프로젝트는 2019 CLUG Winter OpenSource Hackathon에서 진행되었습니다.~~
이제 혼자하고 있습니다.. 아직도 갈 길이 멀어어
