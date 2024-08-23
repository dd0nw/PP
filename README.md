# 📎 딥러닝 기반 생체신호 분석 및 부정맥 검출 서비스(팀명: 모찌나가요)
![README.img](https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/b9f3c4edee791900a420c2b909226309f238164d/image/%EB%A1%9C%EA%B3%A0.png)
<br>

## 👀 서비스 소개 
* 심혈관계 의심 환자가 병원 밖의 가정이나 직장에서 웨어러블을 통해 심전도 신호를 실시간으로 수집하면서, 동시에 심장 관련 지표를 기반으로 심혈관계 질환을 모니터링 함으로써 편리하고 정확한 심장질환 중 부정맥을 검출하기 위한 서비스 
<br>

## 📅 프로젝트 기간 
2022.06.24 ~ 2024.08.22 (9주)
<br>

## ⚙ 개발 환경
- Arduino
- Python?
- Flutter
- Node.js v20.12.0

## 🧱 IoT Device 스펙
<table>
  <tr>
    <td align="center">
      <b>EXP32 C3</b>
    </td>
    <td align="center">
      <b>ADS1292R</b>
    </td>
    <td align="center">
      <b>MAX30102</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/1b12203d4472a467474b219e9bd2be8a53cb113e/image/esp32%20c3.png"/>
    </td>
    <td align="center">
      <img src="https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/1b12203d4472a467474b219e9bd2be8a53cb113e/image/ads1292r.png"/>
    </td>
    <td align="center">
      <img src="https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/1b12203d4472a467474b219e9bd2be8a53cb113e/image/max30102.png"/>
    </td>
  </tr>
  <tr>
    <td>
      Wifi 및 BLE 기능을 갖춘 초저전력 마이크로컨트롤러 모듈<br>
      전압 : 3.3V<br>
      전류 : 500mA (최대)<Br>
      32비트 RISC-V 단일 코어 프로세서<br>
      메모리 : 400KB SRAM
    </td>
    <td>
      고정밀 ECG 센서<br>
      전압 : 3.0V-3.6V<br>
      전류 :<br>
      - 1mA(대기 모드)<br>
      - 250µA(측정 중)<br>
      데이터 전송 속도 : 최대 32kSPS
    </td>
    <td>
       심박수 및 산소포화도 측정 PPG 센서<br>
       전압 : 1.8V 및 3.3V<br>
       전류 :<br>
      - 600µA(측정중)<br>
      - 0.7µA(대기 모드)<br>
       측정 범위 :<br>
      - 심박수 30-240 BPM<br>
      - 산소포화도 70-100% 
    </td>
  </tr>
</table>

## 🛠 회로구성도

- ecg 회로도<br>
![ecg회로](https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/0461ff84291e84aa56c14bd528b935497b8edde9/image/simpe_ecg_cirkit-removebg-preview.png)

- ppg 회로도<br>
![ppg회로](https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/0461ff84291e84aa56c14bd528b935497b8edde9/image/simple_ppg_cirkit-removebg-preview.png)

##  ⭐ 주요 기능 
* ECG, PPG 센서 데이터 수집
* 실시간 부정맥 검출 서비스
* 부정맥 검출 시 사용자에게 알림 기능
* 사용자 맞춤형 건강 분석 및 통계 제공
* 데이터 시각화 및 보고서 생성
* 주변 병원 위치 안내 기능
* 부정맥 측정 시 메모 기능 
<br>

## ⛏ 기술스택
<table>
  <tr>
      <th>구분</th>
      <th>내용</th>
  </tr>
  <tr>
      <td>사용언어</td>
      <td>
          <img src="https://img.shields.io/badge/C-A8B9CC?style=for-the-badge&logo=C&logoColor=white"/> 
          <img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white"/> 
          <img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/> 
          <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=white"/> 
      </td>
   </tr>
   <tr>
        <td>개발도구</td>
        <td>
            <img src="https://img.shields.io/badge/Arduino-00979D?style=for-the-badge&logo=Arduino&logoColor=white"/> 
            <img src="https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=Jupyter&logoColor=white"/>
            <img src="https://img.shields.io/badge/androidstudio-3DDC84?style=for-the-badge&logo=androidstudio&logoColor=white"/>
            <img src="https://img.shields.io/badge/VSCode-007ACC?style=for-the-badge&logo=VisualStudioCode&logoColor=white"/>
            <img src="https://img.shields.io/badge/SQL Developer-F80000?style=for-the-badge&logo=SQL Developer&logoColor=white"/>
        </td>
   </tr>
  <tr>
      <td>서버 환경</td>
      <td>
          <img src="https://img.shields.io/badge/Node.js-5FA04E?style=for-the-badge&logo=Node.js&logoColor=white"/> 
          <img src="https://img.shields.io/badge/Amazon S3-569A31?style=for-the-badge&logo=Amazon S3&logoColor=white"/> 
      </td>
   </tr>
    <tr>
        <td>데이터베이스</td>
        <td>
            <img src="https://img.shields.io/badge/Oracle 11g-F80000?style=for-the-badge&logo=Oracle&logoColor=white"/> 
        </td>
    </tr>
   <tr>
      <td>프레임워크</td>
      <td>
          <img src="https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=Flask&logoColor=white"/> 
          <img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/> 
          <img src="https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=Express&logoColor=white"/> 
      </td>
   </tr>
    <tr>
        <td>라이브러리</td>
        <td>
            <img src="https://img.shields.io/badge/keras-D00000?style=for-the-badge&logo=keras&logoColor=white"/>
            <img src="https://img.shields.io/badge/tensorflow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white"/>
        </td>
    </tr>
    <tr>
        <td>협업도구</Td>
        <td>
            <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=Git&logoColor=white"/> 
            <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white"/>
            <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=Notion&logoColor=white"/>
            <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=Figma&logoColor=white"/>
        </td>
    </tr>
</table>

<br>

## ⚙ 시스템 아키텍처(구조)
![시스템 아키텍처](https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/49ab5555f385f33b8fe30aeb77ab75f88caa6205/image/%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98.PNG)
<br>

## 📌 SW유스케이스 
![image](https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/49ab5555f385f33b8fe30aeb77ab75f88caa6205/image/%EC%9C%A0%EC%8A%A4%EC%BC%80%EC%9D%B4%EC%8A%A4.PNG)


## 📌 서비스 흐름도 
![imgae](https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/49ab5555f385f33b8fe30aeb77ab75f88caa6205/image/%EC%84%9C%EB%B9%84%EC%8A%A4%20%ED%9D%90%EB%A6%84%EB%8F%84.png)

<br>

##  📌 ER다이어그램
![image](https://github.com/2024-SMHRD-IS-IOT-3/PP/blob/49ab5555f385f33b8fe30aeb77ab75f88caa6205/image/er%EB%8B%A4%EC%9D%B4%EC%96%B4%EA%B7%B8%EB%9E%A8.PNG)
<br>

## 🖥 화면 구성

### 회원가입/로그인/센서부착 설명/추가입력정보
![image](https://github.com/user-attachments/assets/064416f7-3207-458b-99ae-e940c97f6564)
<br>

### 앱 밖 알림

<br>

### 실시간 모니터링

<br>

### 기록

<br>

### 부정맥 분석결과/메모/분석결과 다운로드/ 가까운 병원 찾아보기


<br>

### 부정맥 종류 정보
![image]()
<br>

### 설정
![image]()
<br>

## 👨‍👩‍👦‍👦 팀원 역할
<table>
  <tr>
    <td align="center"><img src="https://item.kakaocdn.net/do/fd49574de6581aa2a91d82ff6adb6c0115b3f4e3c2033bfd702a321ec6eda72c" width="100" height="100"/></td>
    <td align="center"><img src="https://mb.ntdtv.kr/assets/uploads/2019/01/Screen-Shot-2019-01-08-at-4.31.55-PM-e1546932545978.png" width="100" height="100"/></td>
    <td align="center"><img src="https://mblogthumb-phinf.pstatic.net/20160127_177/krazymouse_1453865104404DjQIi_PNG/%C4%AB%C4%AB%BF%C0%C7%C1%B7%BB%C1%EE_%B6%F3%C0%CC%BE%F0.png?type=w2" width="100" height="100"/></td>
    <td align="center"><img src="https://i.pinimg.com/236x/ed/bb/53/edbb53d4f6dd710431c1140551404af9.jpg" width="100" height="100"/></td>
    <td align="center"><img src="https://pbs.twimg.com/media/B-n6uPYUUAAZSUx.png" width="100" height="100"/></td>
  </tr>
  <tr>
    <td align="center"><strong>김가연</strong></td>
    <td align="center"><strong>김성훈</strong></td>
    <td align="center"><strong>김도아</strong></td>
    <td align="center"><strong>임동원</strong></td>
    <td align="center"><strong>박태은</strong></td>
  </tr>
  <tr>
    <td align="center"><b>PM, Backend, Hardware</b></td>
    <td align="center"><b>Backend, Hardware</b></td>
    <td align="center"><b>Frontend</b></td>
    <td align="center"><b>AI</b></td>
    <td align="center"><b>Frontend</b></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/yeon820" target='_blank'>github</a></td>
    <td align="center"><a href="https://github.com/seongffm" target='_blank'>github</a></td>
    <td align="center"><a href="https://github.com/DOAAAAAAAAAA" target='_blank'>github</a></td>
    <td align="center"><a href="https://github.com/dd0nw" target='_blank'>github</a></td>
    <td align="center"><a href="https://github.com/taeeun-park" target='_blank'>github</a></td>
  </tr>
</table>

## 🤾‍♂️ 트러블슈팅
 
* 문제1<br>
 I2C 통신 오류
 내부 풀업 저항이 충분하지 않아 I2C 통신 오류 발생
 -> SDA와 SCL핀에 4.9KΩ저항을 VCC에 연결하여 외부 풀업 저항을 구성 


* 문제2<br>
  메모리 오버플로우
  심전도 신호와 같은 큰 데이터 특징 추출시 메모리 용량 초과로 인한 세션 종료
   -> 사용하지 않는 변수에 할당된 메모리를 gc.collect()함수를 사용해 문제 해결

