

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sora/main.dart';
import 'package:video_player/video_player.dart';

class Start extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _Start();
  }

}

class _Start extends State<Start>{
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.asset("assets/workout.mp4")
    ..initialize().then((_){
      setState(() {
        
      });
      videoPlayerController.play();
      
    })..setLooping(false);

    videoPlayerController.addListener((){
      if(videoPlayerController.value.position == videoPlayerController.value.duration){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Sora",)));
      }
    });
    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    videoPlayerController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body:Center(
        
        child:videoPlayerController != null? SizedBox(
          height: 230,
          child: VideoPlayer(videoPlayerController),
        ):null
      ) 
    );
    
  }

}