

import 'package:flutter/material.dart';
import 'package:tb_flutter_toolkit/tb_flutter_toolkit.dart';


class SelectPhotoWidget extends StatelessWidget {
  const SelectPhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选中图片'),
      ),
      body: Center(
        child: Column(
          children: [

            InkWell(
                onTap: () async {
                  var result = await ToolkitUtils.pickMedias(context, maxImages: 9);
                 print('选择图片上传 result: ${result.length}');

                },
                child: Text('选择图片上传')),
          ],
        ),
      ),
    );
  }
}
