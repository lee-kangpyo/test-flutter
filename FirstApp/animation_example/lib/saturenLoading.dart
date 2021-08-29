import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SaturenLoading extends StatefulWidget {
  _SaturenLoading _saturenLoading = _SaturenLoading();
  @override
  State<SaturenLoading> createState() => _saturenLoading;
}


class _SaturenLoading extends State<SaturenLoading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 3)); // 3초 동안 동작하는 애니메이션 컨트롤러를 정의
    _animation = Tween<double>(begin: 0, end: pi * 2).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child){
          return SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                Image.asset('repo/images/circle.png', width: 100, height: 100,),
                Center(
                  child: Image.asset('repo/images/sunny.png', width: 30, height: 30,),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child:  Transform.rotate(
                    angle: _animation.value,
                    origin: Offset(35, 35),
                    child: Image.asset('repo/images/saturn.png', width: 20, height: 20,),
                  )
                )

              ],
            ),
          );
        },
    );
  }
}