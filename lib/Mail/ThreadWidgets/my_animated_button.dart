import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kobi/Mail/page_send.dart';

import '../../theme.dart';

class MyAnimatedButton extends StatefulWidget {
  @override
  _MyAnimatedButtonState createState() => _MyAnimatedButtonState();
}

class _MyAnimatedButtonState extends State<MyAnimatedButton> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<double> _animateIcon;
  late Animation<double> _animateFade;

  @override
  initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(milliseconds: 500), value: 1.0)
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateFade =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget buttonAssistant() {
    return FadeTransition(
      opacity: _animateFade,
      child: Container(
        width:150.w,
        child: FloatingActionButton(
          onPressed: (){
            //recorderController.setTranscription('${widget.thread.emailAddress} 메일 주소로 메일 작성해서 보내줄래?');
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          tooltip: 'Add',
          heroTag: 'add',
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w,0,5.w,0),
                child: Icon(Icons.assistant_outlined,color: Colors.black),
              ),
              Text('커리비에게 맡겨보기',style: textTheme().bodySmall?.copyWith(color:Colors.black),)
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonDirect() {
    return FadeTransition(
      opacity: _animateFade,
      child: Container(
        width:130.w,
        child: FloatingActionButton(
          onPressed: (){
            Get.to(() => SendPage());
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          tooltip: 'Edit',
          heroTag: 'edit',
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.w,0,5.w,0),
                child: Icon(Icons.edit,color: Colors.black),
              ),
              Text('직접 작성하기',style: textTheme().bodySmall?.copyWith(color:Colors.black),)
            ],
          ),
        ),
      ),
    );
  }

  Widget toggle() {
    return Container(
      width:100.w,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        onPressed: animate,
        heroTag: 'toggle',
        tooltip: 'Toggle',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                return Transform.rotate(
                  angle: _animateFade.value * pi,
                  child: Opacity(
                    opacity: _animateFade.value < 0.5
                        ? 1.0-(_animateFade.value)
                        : 1.0 - (_animateFade.value - 0.5),
                    child: Icon(_animateFade.value < 0.5 ? Icons.mail : Icons.close , color: Colors.black,)),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w,0,10.w,2.h),
              child: Text('메일쓰기',style: textTheme().bodySmall?.copyWith(color:Colors.black),),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _animateIcon.value * 130.0,
            0.0,
          ),
          child: buttonAssistant(),
        ),
        SizedBox(height:10.h),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _animateIcon.value * 65.0,
            0.0,
          ),
          child: buttonDirect(),
        ),
        SizedBox(height:10.h),
        toggle(),
      ],
    );
  }
}