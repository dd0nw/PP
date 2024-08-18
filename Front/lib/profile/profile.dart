import 'package:flutter/material.dart';
import '../setting2.dart';
import 'profile_service.dart';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({super.key});

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  final ProfileService _profileService = ProfileService();

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _selectedDay = DateTime.now().day;

  List<int> _years = List.generate(100, (index) => DateTime.now().year - index);
  List<int> _months = List.generate(12, (index) => index + 1);
  List<int> _days = List.generate(31, (index) => index + 1);

  String? _selectedGender;
  final List<String> _genders = ['남성', '여성', '기타'];

  double _selectedHeight = 165.0;
  List<double> _heights = List.generate(201, (index) => 50.0 + index.toDouble());

  double _selectedWeight = 50.0;
  List<double> _weights = List.generate(191, (index) => 10.0 + index.toDouble());

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6F6),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 34.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '프로필 변경',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFF6F6),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 0),

            // // 이름 필드와 작은 텍스트 필드 포함
            // Container(
            //   width: 317,
            //   height: 57,
            //   child: TextField(
            //     controller: _nameController,
            //     textAlign: TextAlign.center,
            //     obscureText: false,
            //     keyboardType: TextInputType.text,
            //     decoration: InputDecoration(
            //       fillColor: const Color(0xFFFFFFFF),
            //       filled: true,
            //       enabledBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(color: Color(0xFFC1C1C1)),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(color: Color(0xFFC1C1C1)),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       labelText: '이름',
            //       labelStyle: const TextStyle(
            //         color: Color(0xFF000000),
            //         fontWeight: FontWeight.bold,
            //         fontSize: 14.0,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 20),

            // 생년월일 필드
            Text("생년월일", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    width: 317,
                    height: 57,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC1C1C1)),
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedYear,
                      items: _years.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Center(child: Text('$year')),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedYear = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                        labelText: '년도',
                        labelStyle: const TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 57,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC1C1C1)),
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedMonth,
                      items: _months.map((month) {
                        return DropdownMenuItem<int>(
                          value: month,
                          child: Center(child: Text('$month')),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedMonth = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                        labelText: '월',
                        labelStyle: const TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 57,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC1C1C1)),
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedDay,
                      items: _days.map((day) {
                        return DropdownMenuItem<int>(
                          value: day,
                          child: Center(child: Text('$day')),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDay = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        border: InputBorder.none,
                        labelText: '일',
                        labelStyle: const TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            Text("성별", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 성별 선택 필드
                Container(
                  width: 317,
                  height: 57,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFC1C1C1)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: _genders.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Center(child: Text(
                          gender,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        )),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      border: InputBorder.none,
                      labelText: '성별',
                      labelStyle: const TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text("키", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 6,),

                // 키 선택 필드
                Container(
                  width: 317,
                  height: 57,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFC1C1C1)),
                  ),
                  child: DropdownButtonFormField<double>(
                    value: _selectedHeight,
                    items: _heights.map((height) {
                      return DropdownMenuItem<double>(
                        value: height,
                        child: Center(child: Text('${height.toStringAsFixed(1)} cm')),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedHeight = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      border: InputBorder.none,
                      labelText: '키',
                      labelStyle: const TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text("몸무게", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 6,),

                // 몸무게 선택 필드
                Container(
                  width: 317,
                  height: 57,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFC1C1C1)),
                  ),
                  child: DropdownButtonFormField<double>(
                    value: _selectedWeight,
                    items: _weights.map((weight) {
                      return DropdownMenuItem<double>(
                        value: weight,
                        child: Center(child: Text('${weight.toStringAsFixed(1)} kg')),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedWeight = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      border: InputBorder.none,
                      labelText: '몸무게',
                      labelStyle: const TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 120),
            // 저장 버튼
            ElevatedButton(
              onPressed: () async {
                // 저장 버튼이 눌렸을 때 프로필 정보 저장
                final name = _nameController.text;
                final birthdate = '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';
                final gender = _selectedGender ?? '';
                final height = _selectedHeight;
                final weight = _selectedWeight;

                try {
                  await _profileService.saveProfile(
                    name: name,
                    birthdate: birthdate,
                    gender: gender,
                    height: height,
                    weight: weight,
                  );
                } catch (e) {
                  print('Failed to save profile: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 41),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                '저장',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
