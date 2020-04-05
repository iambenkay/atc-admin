import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/Processing.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class CreateChannel extends StatefulWidget {
  final String channelId;
  CreateChannel(this.channelId);
  @override
  _CreateChannelState createState() => _CreateChannelState();
}

class _CreateChannelState extends State<CreateChannel> {
  String _videoTitle = "";
  VideoPlayerController _videoPlayerController;
  File _video;
  bool _showOverlay = true, _uploading = false;
  double _progress = 0.0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void loadFile() async {
    _videoPlayerController?.pause();
    File video = await FilePicker.getFile(type: FileType.video);
    if (video != null) {
      _videoPlayerController = VideoPlayerController.file(video)
        ..setLooping(true)
        ..initialize().then((_) {
          setState(() {
            _video = video;
          });
        });
    }
  }

  void uploadFile(Auth auth) async {
    String resourceId = Uuid().v4();
    StorageUploadTask uploadTask =
        auth.bucket.ref().child("video").child(resourceId).putFile(_video);
    uploadTask.events.listen((event) {
      setState(() {
        _progress =
            event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      });
    });
    String videoDownloadUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Processing(auth, () async {
              Uint8List thumbnailData = await VideoThumbnail.thumbnailData(
                  video: _video.path,
                  imageFormat: ImageFormat.JPEG,
                  quality: 200);
              String thumbnailDownloadUrl = await (await auth.bucket
                      .ref()
                      .child("thumbnails")
                      .child(resourceId)
                      .putData(thumbnailData)
                      .onComplete)
                  .ref
                  .getDownloadURL();
              return await auth.store
                  .collection("charmainetv/${widget.channelId}/videos")
                  .add({
                "title": _videoTitle,
                "createdAt": DateTime.now(),
                "videoUrl": videoDownloadUrl,
                "resourceId": resourceId,
                "thumbnailUrl": thumbnailDownloadUrl
              }).then((_) => null);
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: withFirebase(Consumer(
                    builder: (context, Auth auth, _) => FlatButton(
                          onPressed: _video == null ||
                                  _videoTitle.isEmpty ||
                                  _uploading
                              ? null
                              : () {
                                  setState(() {
                                    _uploading = true;
                                    uploadFile(auth);
                                  });
                                },
                          textColor: Color(0xffe29464),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "CREATE",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ))))
          ],
          leading: InkWell(
            child: Icon(Icons.close),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: _uploading
            ? Container(
                child: Center(
                  child: new CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 4.0,
                    percent: _progress,
                    footer: Text("Uploading file"),
                    center: new Text("${(_progress * 100).truncate()}%"),
                    progressColor: Colors.green,
                  ),
                ),
              )
            : Container(
                child: Form(
                    child:
                        ListView(physics: BouncingScrollPhysics(), children: <
                            Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 10, 20),
                  child: Text(
                    "Add new Video",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: TextFormField(
                    maxLines: null,
                    autocorrect: true,
                    onChanged: (_) {
                      setState(() {
                        _videoTitle = _;
                      });
                    },
                    validator: (value) =>
                        (value.isEmpty) ? "Please input title" : null,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Video Title',
                        labelStyle: TextStyle(fontSize: 30)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _videoPlayerController != null &&
                          _videoPlayerController.value.initialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: <Widget>[
                              AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController.value.aspectRatio,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _showOverlay = !_showOverlay;
                                        });
                                      },
                                      child:
                                          VideoPlayer(_videoPlayerController))),
                              _showOverlay
                                  ? AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child: _showOverlay
                                          ? Container(
                                              color: Color(0xaa000000),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0x55ffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(33)),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _showOverlay =
                                                              !_showOverlay;
                                                          _videoPlayerController
                                                                  .value
                                                                  .isPlaying
                                                              ? _videoPlayerController
                                                                  .pause()
                                                              : _videoPlayerController
                                                                  .play();
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                            _videoPlayerController
                                                                    .value
                                                                    .isPlaying
                                                                ? Icons.pause
                                                                : Icons
                                                                    .play_arrow,
                                                            color: Colors.white,
                                                            size: 50),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0x55ffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(33)),
                                                    child: InkWell(
                                                      onTap: loadFile,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(13.0),
                                                        child: Icon(
                                                            Icons.cloud_upload,
                                                            color: Colors.white,
                                                            size: 40),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : null,
                                    )
                                  : null
                            ].where((Object o) => o != null).toList(),
                          ),
                        )
                      : DottedBorder(
                          color: Color(0xff888888),
                          strokeWidth: 2,
                          radius: Radius.circular(10),
                          borderType: BorderType.RRect,
                          child: InkWell(
                            onTap: loadFile,
                            child: Container(
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.cloud_upload,
                                      color: Color(0xff888888),
                                      size: 40,
                                    ),
                                    Text(
                                      "Click to select file",
                                      style:
                                          TextStyle(color: Color(0xff888888)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                )
              ]))));
  }
}

class Api {
  static const String token = "AIzaSyDMal7QCioz74RYe8RMLlCbuD6WE0Yc8pU";

  static Future<Map<String, dynamic>> fetch(String id) {
    return http
        .get(
            "https://www.googleapis.com/youtube/v3/videos?id=$id&key=$token&part=snippet&fields=items(snippet(title,description))")
        .then((response) => json.decode(response.body));
  }
}
