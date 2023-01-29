import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Screens/add_post/components/post_functions.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';

class toolSelectionForCreatingPost extends StatefulWidget {
  final void Function(FileTypeOption?, File?) changePostWidgetScreen;
  toolSelectionForCreatingPost({required this.changePostWidgetScreen});

  @override
  State<toolSelectionForCreatingPost> createState() =>
      _toolSelectionForCreatingPostState();
}

class _toolSelectionForCreatingPostState
    extends State<toolSelectionForCreatingPost> {
  final imagePicker = ImagePicker();
  File? _file;
  void _OptionForCamera(photoOptions photo_option, FileTypeOption fileOption) {
    switch (photo_option) {
      case photoOptions.Camera:
        switch (fileOption) {
          case FileTypeOption.Image:
            _getPhotoFileFromCamera();
            break;
          case FileTypeOption.Video:
            _getVideoFileFromCamera();
        }
        break;
      case photoOptions.Gallery:
        switch (fileOption) {
          case FileTypeOption.Image:
            _getPhotoFileFromGallery();
            break;
          case FileTypeOption.Video:
            _getVideoFileFromGallery();
        }
    }
  }

  void _getPhotoFileFromCamera() async {
    Navigator.of(context).pop();

    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _file = File(pickedFile.path);

      widget.changePostWidgetScreen(FileTypeOption.Image, _file);
    }
  }

  void _getVideoFileFromCamera() async {
    Navigator.of(context).pop();

    XFile? pickedFile = await imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _file = File(pickedFile.path);

      widget.changePostWidgetScreen(FileTypeOption.Video, _file);
    }
  }

  void _getPhotoFileFromGallery() async {
    Navigator.of(context).pop();

    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _file = File(pickedFile.path);

      widget.changePostWidgetScreen(FileTypeOption.Image, _file);
    }
  }

  void _getVideoFileFromGallery() async {
    Navigator.of(context).pop();

    XFile? pickedFile =
        await imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _file = File(pickedFile.path);
      widget.changePostWidgetScreen(FileTypeOption.Video, _file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          width: getWidth(context: context),
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              'Create Post',
              style:
                  GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_a_photo, size: 150),
              SizedBox(
                height: getHeight(context: context) * 0.08,
              ),
              Consumer<ThemeProvider>(builder: (ctx, provider, _) {
                return Container(
                  width: getWidth(context: context) * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        onTap: () {
                          CreatePostScreenWidgets.showModalBottomSheetFunction(
                              context: context,
                              photo_option: photoOptions.Camera,
                              option: _OptionForCamera,
                              isDark: provider.IsThemeStatusBlack);
                        },
                        trailing: Icon(
                          Icons.camera_alt_outlined,
                          color: provider.IsThemeStatusBlack
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          'Use camera',
                          style: GoogleFonts.nunito(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          CreatePostScreenWidgets.showModalBottomSheetFunction(
                              context: context,
                              photo_option: photoOptions.Gallery,
                              option: _OptionForCamera,
                              isDark: provider.IsThemeStatusBlack);
                        },
                        trailing: Icon(
                          Icons.file_copy_outlined,
                          color: provider.IsThemeStatusBlack
                              ? Colors.white
                              : Colors.black,
                        ),
                        title: Text(
                          'From gallery',
                          style: GoogleFonts.nunito(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
