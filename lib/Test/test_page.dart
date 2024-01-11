import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kobi/Class/class_my_event.dart';
import 'package:kobi/Dialog/delete_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  Widget build(BuildContext context) {
    // Widget list(Orientation orientation) => ScrollablePositionedList.builder(
    //   itemCount: numberOfItems,
    //   itemBuilder: (context, index) => item(index, orientation),
    //   itemScrollController: itemScrollController,
    //   itemPositionsListener: itemPositionsListener,
    //   scrollOffsetController: scrollOffsetController,
    //   reverse: reversed,
    //   scrollDirection: orientation == Orientation.portrait
    //       ? Axis.vertical
    //       : Axis.horizontal,
    // );


    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height:700.h,
            child: Column(
                      children: [
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: 500,
                itemBuilder: (context, index) => Text('Item $index'),
                itemScrollController: itemScrollController,
                scrollOffsetController: scrollOffsetController,
                itemPositionsListener: itemPositionsListener,
                scrollOffsetListener: scrollOffsetListener,
              ),
            ),
            TextButton(
              onPressed: () {
                itemScrollController.jumpTo(index: 150,alignment: 0.5);
              },
              child: Text('test'),
            ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
