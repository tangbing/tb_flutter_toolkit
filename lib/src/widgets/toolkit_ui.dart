import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tb_flutter_toolkit/src/config.dart';
import 'package:tb_flutter_toolkit/src/toolkit_utils.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


class ToolkitUI {
  static Future<T?> showIosDialog<T>(
      BuildContext context, {
      showCancel = true,
      List<ActionSheetModel<T?>>? actionList,
      String? title,
      String? desc,
  }) {

    //List<ActionSheetModel> actionList = [
    //   ActionSheetModel(
    //       selectPicType: MediaFrom.gallery, clickHandler: clickHandler),
    //   ActionSheetModel(
    //       selectPicType: MediaFrom.camera, clickHandler: clickHandler),
    // ];

    // var list = List.generate(
    //     actionList.length,
    // (index) => CupertinoActionSheetAction(
    //     onPressed: () {
    //       Navigator.pop(context);
    //       clickHandler?.call(actionList[index].selectPicType);
    //     },
    //   child: ,
    // )
    List<CupertinoActionSheetAction> list = [];

    actionList?.forEach((element) {
       list.add(CupertinoActionSheetAction(onPressed: () async {
         if (element.onSelect != null) {
          T? result = await element.onSelect!();
          if (context.mounted) {
            Navigator.pop(context, result);
          }
         } else {
           Navigator.pop(context,element.returnValue);
         }
       }, child: Text(element.text ?? ''),
       ));
    });

   return showCupertinoModalPopup<T>(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
              title: title == null ? null : Text(title),
              message: desc == null ? null : Text(desc),
            actions: list,
            cancelButton: showCancel ? CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消')
            ) : null,
          );
        });
  }
}


class ActionSheetModel<T> {
  final String? text;
  final FutureOr<T>? Function()? onSelect;
  final T? returnValue;

  ActionSheetModel({
    this.text,
    this.returnValue,
    this.onSelect,
  });
}
