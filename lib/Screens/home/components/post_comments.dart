import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/home/view_models/comments_data.dart';
import 'package:social_media_app/Screens/home/view_models/comments_data.dart';
import 'package:social_media_app/Screens/home/view_models/home_view_model.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';

class postComments extends StatefulWidget {
  final List<postCommentViewState> comments;
  final homeViewModel viewModel;
  final String postId;
  final String idOfPostUser;
  final String nameOfPostUser;
  postComments(
      {required this.comments,
      required this.viewModel,
      required this.postId,
      required this.idOfPostUser,
      required this.nameOfPostUser});

  @override
  State<postComments> createState() => _postCommentsState();
}

class _postCommentsState extends State<postComments> {
  late commentsData Data;
  @override
  void initState() {
    Data = Provider.of<commentsData>(context, listen: false);

    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(covariant postComments oldWidget) {
    Data.setComments(data: widget.comments, post_Id: widget.postId);

    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
      child: Row(
        children: [
          widget.comments.isEmpty
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    widget.comments.length.toString(),
                    style: GoogleFonts.nunito(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
          IconButton(
              onPressed: () {
                Data.setInitialComments(
                    data: widget.comments, post_Id: widget.postId);

                Navigator.of(context).pushNamed(routes.PostCommentsRoute,
                    arguments: [
                      widget.viewModel,
                      widget.postId,
                      widget.idOfPostUser,
                      widget.nameOfPostUser
                    ]);
              },
              icon: const Icon(
                Icons.comment,
                size: 30,
              )),
        ],
      ),
    );
  }
}
