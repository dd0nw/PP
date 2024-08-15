import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("설정", style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              margin: const EdgeInsets.all(8),
              color: Colors.purple,
              child: ListTile(
                onTap: (){}, // edit페이지
                title: Text("김도아"),
                leading: Icon(Icons.account_circle),
                trailing: Icon(Icons.edit, color: Colors.white,),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 4,
              margin: EdgeInsets.fromLTRB(32, 8, 32, 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.lock_clock_outlined, color: Colors.purple,),
                    title: Text("비밀번호 변경"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock_clock_outlined, color: Colors.purple,),
                    title: Text("비밀번호 변경"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock_clock_outlined, color: Colors.purple,),
                    title: Text("비밀번호 변경"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){},
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Text("알림 설정",
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.indigo),),
            SwitchListTile(value: true, onChanged: (val){},
              activeColor: Colors.purple,
              contentPadding: EdgeInsets.all(0),
              title: Text("Received news"),
            ),
            SwitchListTile(value: false, onChanged: (val){},
              activeColor: Colors.purple,
              contentPadding: EdgeInsets.all(0),
              title: Text("Received news22"),
            ),

          ],
        ),
      ),
    );
  }
}
