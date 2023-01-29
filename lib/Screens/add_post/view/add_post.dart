import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/add_post/view/share_post.dart';
import 'package:social_media_app/Screens/add_post/components/tool_selection.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';

class addPost extends StatefulWidget {
  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  File? file;
  FileTypeOption? fileType;

  void changePostWidgetScreen(FileTypeOption? typeOfFile, File? selectedfile) {
    fileType = typeOfFile;
    file = selectedfile;
    Navigator.of(context)
        .pushNamed(routes.sharePostRoute, arguments: [file, fileType]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          height: double.infinity,
          width: double.infinity,
          child: toolSelectionForCreatingPost(
              changePostWidgetScreen: changePostWidgetScreen)),
    );
  }
}
