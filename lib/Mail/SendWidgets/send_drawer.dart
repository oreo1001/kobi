import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controller/auth_controller.dart';
import '../../theme.dart';

class SendDrawer extends StatefulWidget {
  SendDrawer(this.filter,{super.key});
  RxString filter;

  @override
  State<SendDrawer> createState() => _MailPageState();
}

class _MailPageState extends State<SendDrawer> {
  AuthController authController = Get.find();
  String name = '';
  String email = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    name = authController.name.value;
    email = authController.email.value;
    photoUrl = authController.photoUrl.value;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
        children: [
          SizedBox(height: 30.h),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30.sp),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(name,
                style: TextStyle(
                    fontSize: 15.sp, color: Colors.grey.shade800)),
            subtitle: Text(email,
                style: TextStyle(
                    fontSize: 12.sp, color: Colors.grey.shade500)),
          ),
          SizedBox(height: 17.h),
          ListTile(
              leading: Icon(Icons.folder_outlined, size: 25.sp),
              title: Text('All',
                  style: textTheme().bodySmall?.copyWith(
                      fontSize: 15.sp, color: Colors.grey.shade800)),
              onTap: () {
                widget.filter.value = 'All';
                Navigator.pop(context);
              }),
          ListTile(
            leading: Icon(Icons.folder_outlined, size: 25.sp),
            title: Text('Notifications',
                style: textTheme().bodySmall?.copyWith(
                    fontSize: 15.sp, color: Colors.grey.shade800)),
            onTap: () {
              widget.filter.value = 'Notifications';
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_outlined, size: 25.sp),
            title: Text('Newsletters',
                style: textTheme().bodySmall?.copyWith(
                    fontSize: 15.sp, color: Colors.grey.shade800)),
            onTap: () {
              widget.filter.value = 'Newsletters';
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Image.asset('/images/business.png',width: 25.w,height: 25.h,),
            title: Text('Business',
                style: textTheme().bodySmall?.copyWith(
                    fontSize: 15.sp, color: Colors.grey.shade800)),
            onTap: () {
              widget.filter.value = 'Business';
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_outlined, size: 25.sp),
            title: Text('Finance',
                style: textTheme().bodySmall?.copyWith(
                    fontSize: 15.sp, color: Colors.grey.shade800)),
            onTap: () {
              widget.filter.value = 'Finance';
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_outlined, size: 25.sp),
            title: Text('Unknown',
                style: textTheme().bodySmall?.copyWith(
                    fontSize: 15.sp, color: Colors.grey.shade800)),
            onTap: () {
              widget.filter.value = 'Unknown';
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}