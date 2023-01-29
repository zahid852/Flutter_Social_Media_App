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

class videoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final String url;
  videoPlayer({required this.videoController, required this.url});
  @override
  State<videoPlayer> createState() => _videoPlayerState();
}

class _videoPlayerState extends State<videoPlayer> {
  late ChewieController _chewieController;
  void getAspectRatio() async {
    await widget.videoController.initialize();
    setState(() {});
    if (widget.videoController.value.isInitialized) {
      _chewieController = ChewieController(
          videoPlayerController: widget.videoController,
          fullScreenByDefault: false,
          allowFullScreen: false,
          showControlsOnInitialize: true,
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ],
          deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ],
          showOptions: false,
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
    log('hello from init ${widget.url}');
    // TODO: implement initState
    super.initState();
    getAspectRatio();
  }

  @override
  void didUpdateWidget(covariant videoPlayer oldWidget) {
    log('hello from did update ${widget.url}');
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
        ? Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            color: Colors.black,
            child: GestureDetector(
                onTap: () {
                  _chewieController.hideControlsTimer;
                },
                child: Chewie(controller: _chewieController)));
  }
}
