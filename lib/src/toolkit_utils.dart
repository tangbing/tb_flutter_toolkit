import 'package:flutter/cupertino.dart';
import 'package:tb_flutter_toolkit/src/config.dart';
import 'package:tb_flutter_toolkit/src/widgets/toolkit_ui.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

enum MediaFrom { gallery, camera }

class ToolkitUtils {
  static Future<List<AssetEntity>> pickMedias(BuildContext context,
      {required int maxImages,
      bool allowVideo = false,
      SpecialPickerType? specialPickerType
      }) async {

    if (maxImages <=0) return [];

    List<AssetEntity> images = [];

    MediaFrom? source;
   var result = await ToolkitUI.showIosDialog<MediaFrom>(context,
       actionList: [
         ActionSheetModel<MediaFrom>(text: Config.selectFromGallery, onSelect: () => source = MediaFrom.gallery),
         ActionSheetModel<MediaFrom>(text: Config.selectFromTakePhoto, onSelect: () => source = MediaFrom.camera),
    ]);

   if (source == null || !context.mounted) return [];

    if (result == MediaFrom.gallery) {
      final List<AssetEntity>? entities = await AssetPicker.pickAssets(context, pickerConfig: AssetPickerConfig(
          specialPickerType: specialPickerType,
          requestType: allowVideo ? RequestType.common : RequestType.image,
          maxAssets: maxImages
      ));

      if (entities != null) images.addAll(entities);
      print('select entities: ${images.length}');

    } else {
      final AssetEntity? entity = await CameraPicker.pickFromCamera(context, pickerConfig: CameraPickerConfig(
          enableRecording: allowVideo
      ));

      if (entity != null) images.add(entity);
      print('select camera entities: ${images.length}');

    }

    return images;
  }
}
