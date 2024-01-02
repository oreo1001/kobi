import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Assistant/Class/extension_class.dart';

import 'active_extension.dart';

class ActiveExtensionList extends StatelessWidget {
  ActiveExtensionList({super.key, required this.extensionDescriptionList});

  List<ExtensionDescription> extensionDescriptionList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.white70
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // 그림자 색상
            spreadRadius: 2, // 그림자 확장 범위
            blurRadius: 1, // 그림자 흐림 정도
            offset: const Offset(0, 1), // 그림자 위치
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
          children: extensionDescriptionList.map((extensionDescription) =>
              ActiveExtension(extensionDescription: extensionDescription,)).toList()
      ),
    );
  }
}
