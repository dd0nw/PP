import 'package:flutter/material.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("설정", style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            SizedBox(height: 15,),
            Container(
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black12, // 테두리 색상
                  width: 1, // 테두리 두께
                ),
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(3),
                color: Colors.white,
                child: ListTile(
                  onTap: () {}, // edit페이지
                  title: Text("김도아", style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("doa1029@naver.com"),
                  leading: Icon(Icons.account_circle),
                ),
              ),
            ),
            SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('프로필 변경'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 비밀번호 변경 클릭 시 동작
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('비밀번호 변경'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 콘텐츠 설정 클릭 시 동작
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_outlined),
              title: Text('알림설정'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 소셜 클릭 시 동작
              },
            ),
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('센서 연결정보'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 언어 클릭 시 동작
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('사용방법'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 개인정보 및 보안 클릭 시 동작
              },
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 로그아웃 버튼 클릭 시 동작
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 아이콘과 텍스트 가운데 정렬
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.black,),
                    SizedBox(width: 3), // 아이콘과 텍스트 사이 간격 추가
                    Text(
                      '로그아웃',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(150, 40), // 버튼의 고정 크기 설정
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.notifications),
            //   title: Text('알림'),
            // ),
            // Divider(),
            // SwitchListTile(
            //   title: Text('다크 모드'),
            //   value: isDarkTheme,
            //   onChanged: (value) {
            //     setState(() {
            //       isDarkTheme = value;
            //     });
            //   },
            // ),
            // SwitchListTile(
            //   title: Text('계정 활성화'),
            //   value: isAccountActive,
            //   onChanged: (value) {
            //     setState(() {
            //       isAccountActive = value;
            //     });
            //   },
            // ),
            // SwitchListTile(
            //   title: Text('기회 알림'),
            //   value: isOpportunityEnabled,
            //   onChanged: (value) {
            //     setState(() {
            //       isOpportunityEnabled = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}