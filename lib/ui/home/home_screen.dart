import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  var _time = 0;
  var _isRunning = false;

  List<String> _lapTimes = [];

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop watch'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _clickButton();
        }),
        child: _isRunning ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // 내용 부분
  Widget _buildBody() {
    var sec = _time ~/100;   //  _time 을  100 으로 나눈 몫
    var hundredth = '${_time % 100}'.padLeft(2, '0');   // 100으로 나눈 나머지를 구하고 왼쪽 2 자리를 0으로 채운

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$sec',
                      style: const TextStyle(fontSize: 50.0),
                    ),
                    Text(
                      hundredth,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  height: 200,
                  child: ListView(
                    children: _lapTimes.map((time) => Text(time)).toList(),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 30,
              bottom: 30,
              child: FloatingActionButton(
                onPressed: _reset,
                backgroundColor: Colors.red,
                child: const Icon(Icons.rotate_left),
              ),
            ),
            Positioned(
              right: 30,
              bottom: 30,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: const Text('랩타임'),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 시작 또는 일시정지 버튼
  void _clickButton() {
    _isRunning = !_isRunning;

    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  // 1/100 초에 한 번씩 time 변수를 1 증가
  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  // 타이머 취소
  void _pause() {
    _timer?.cancel();
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _lapTimes.clear();
      _time = 0;
    });
  }

  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1}등 $time');
  }
}
