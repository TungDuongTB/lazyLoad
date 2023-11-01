import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoApp());

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  State<VideoApp> createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoList(),
    );
  }
}

class VideoList extends StatefulWidget {

  @override
  _VideoListState createState() => _VideoListState();

}

class _VideoListState extends State<VideoList> {
  PageController pageController = PageController();
  List<String> videoList = [
    "https://cdn.pixabay.com/vimeo/874643413/sach-185096.mp4?width=640&hash=3f467f48db2c395eee65259dd54baa16a2198184",
    "https://cdn.pixabay.com/vimeo/864121573/nga-tu-180386.mp4?width=1280&hash=ceca13ea6ed9c3fb179720025509a949c20f33ab",
    "https://cdn.pixabay.com/vimeo/869947284/bien-182970.mp4?width=640&hash=38a83d8efba9c71c1b9bcea3b9de7697b33f93d4",
    "https://cdn.pixabay.com/vimeo/870457542/xe-lua-183271.mp4?width=1280&hash=b11062a06f8a4312aa52239dcf2e718db4b1cce6",
    "https://cdn.pixabay.com/vimeo/864121573/nga-tu-180386.mp4?width=1280&hash=ceca13ea6ed9c3fb179720025509a949c20f33ab",
    // "https://cdn.pixabay.com/vimeo/869947284/bien-182970.mp4?width=640&hash=38a83d8efba9c71c1b9bcea3b9de7697b33f93d4",
    // "https://cdn.pixabay.com/vimeo/870457542/xe-lua-183271.mp4?width=1280&hash=b11062a06f8a4312aa52239dcf2e718db4b1cce6",
    // "https://cdn.pixabay.com/vimeo/864121573/nga-tu-180386.mp4?width=1280&hash=ceca13ea6ed9c3fb179720025509a949c20f33ab",
    // "https://cdn.pixabay.com/vimeo/869947284/bien-182970.mp4?width=640&hash=38a83d8efba9c71c1b9bcea3b9de7697b33f93d4",
    // "https://cdn.pixabay.com/vimeo/870457542/xe-lua-183271.mp4?width=1280&hash=b11062a06f8a4312aa52239dcf2e718db4b1cce6",
    // "https://cdn.pixabay.com/vimeo/864121573/nga-tu-180386.mp4?width=1280&hash=ceca13ea6ed9c3fb179720025509a949c20f33ab",
    // "https://cdn.pixabay.com/vimeo/869947284/bien-182970.mp4?width=640&hash=38a83d8efba9c71c1b9bcea3b9de7697b33f93d4",
    // "https://cdn.pixabay.com/vimeo/870457542/xe-lua-183271.mp4?width=1280&hash=b11062a06f8a4312aa52239dcf2e718db4b1cce6",
    // "https://cdn.pixabay.com/vimeo/864121573/nga-tu-180386.mp4?width=1280&hash=ceca13ea6ed9c3fb179720025509a949c20f33ab",
    // "https://cdn.pixabay.com/vimeo/869947284/bien-182970.mp4?width=640&hash=38a83d8efba9c71c1b9bcea3b9de7697b33f93d4",
    // "https://cdn.pixabay.com/vimeo/870457542/xe-lua-183271.mp4?width=1280&hash=b11062a06f8a4312aa52239dcf2e718db4b1cce6",
  ];
  List<String> videoTemp = [
    "https://cdn.pixabay.com/vimeo/860734645/hoa-178826.mp4?width=640&hash=2f0f3ea369661eb6713110c04335915382600ab3",
    "https://cdn.pixabay.com/vimeo/860527368/thac-nuoc-178732.mp4?width=1280&hash=9aba23e4d9d68fe44979d116993ead8cd28e8525",
    "https://cdn.pixabay.com/vimeo/839864519/nui-non-168787.mp4?width=1280&hash=1fbb199b1f58be746674550bf68b2bea26a498a6",

  ];

  late List<VideoPlayerController> videoControllers;

  int currentPage = 0;
  int count = 0;
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoControllers = List.generate(
        2,
            (index) => VideoPlayerController.networkUrl(Uri.parse(videoList[index]))
    );
    for(var controller in videoControllers){
      controller.initialize().then((_) {
        setState(() {});
        controller.play();
        print("chạy");
      });
    }
    pageController.addListener(() {
      int? newPage = pageController.page?.round();
      if (newPage != currentPage) {
        currentPage = newPage!;
        for (var controller in videoControllers) {
          controller.pause();  // Dừng tất cả các video
        }
        videoControllers[currentPage].initialize().then((_) {
          setState(() {});
          videoControllers[currentPage].play();  // Chạy video ở trang hiện tại
        });
      }
      if (pageController.position.pixels == pageController.position.maxScrollExtent) {
        _themVideo();
      }
    });

  }
  // @override
  // void dispose() {
  //   super.dispose();
  //   for (var controller in videoControllers) {
  //     controller.dispose();
  //   }
  // }

  _themVideo(){
    print('object');
    videoList.addAll(videoTemp);
    for (var i = videoList.length - videoTemp.length; i < videoList.length; i++) {
      final newController = VideoPlayerController.networkUrl(Uri.parse(videoList[i]));
      newController.initialize().then((_) {
        newController.play();
        setState(() {});
      });
      videoControllers.add(newController);
    }
    setState(() {
      print(videoList.length);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: videoControllers.length,
        scrollDirection: Axis.vertical,
        controller: pageController,
        onPageChanged: (value) {
          print(value);
        },
        itemBuilder: (context, index) {
          final videoIndex = index % videoList.length;
          return AspectRatio(
            aspectRatio: videoControllers[index].value.aspectRatio,
            child: VideoPlayer(videoControllers[index]),
          );
        },
      ),
    );
  }
}

