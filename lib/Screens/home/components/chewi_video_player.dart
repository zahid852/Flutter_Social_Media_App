import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:video_player/video_player.dart';

class chewiVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final String url;
  chewiVideoPlayer({required this.videoController, required this.url});
  @override
  State<chewiVideoPlayer> createState() => _chewiVideoPlayerState();
}

class _chewiVideoPlayerState extends State<chewiVideoPlayer> {
  late ChewieController _chewieController;
  void getAspectRatio() async {
    await widget.videoController.initialize();
    setState(() {});
    if (widget.videoController.value.isInitialized) {
      _chewieController = ChewieController(
          videoPlayerController: widget.videoController,
          deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ],
          allowFullScreen: false,
          errorBuilder: ((context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            );
          }));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAspectRatio();
  }

  @override
  void didUpdateWidget(covariant chewiVideoPlayer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getAspectRatio();
  }

  @override
  void dispose() {
    widget.videoController.dispose();
    if (widget.videoController.value.isInitialized) {
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.videoController.value.isInitialized == false
        ? AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ))
        : AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
                color: Colors.black,
                child: AspectRatio(
                    aspectRatio: widget.videoController.value.aspectRatio,
                    child: Chewie(controller: _chewieController))));
  }
}
