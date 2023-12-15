import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/widgets/drawer.dart';

class ArticleVideoImageDetails extends StatefulWidget {
  const ArticleVideoImageDetails({super.key});

  @override
  State<ArticleVideoImageDetails> createState() =>
      _ArticleVideoImageDetailsState();
}

class _ArticleVideoImageDetailsState extends State<ArticleVideoImageDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      key: _key,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 8),
          child: GestureDetector(
              onTap: () {
                _key.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: AppColor.white,
                size: 30,
              )),
        ),
        title: Container(
          margin: EdgeInsets.only(right: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/logo-img.png",
              scale: 2.9,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    "assets/profile.png",
                    scale: 2.9,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    "assets/notification.png",
                    scale: 2.9,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    "assets/message.png",
                    scale: 2.9,
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: AppColor.appbar,
        //   shadowColor: AppColor.loginappbar,
        centerTitle: true,
        bottomOpacity: 1.0,
        elevation: 4,
      ),
      drawer: DrawerWidget(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.grey,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              'assets/homeimage.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              color: AppColor.black,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(top: 3),
                                        child: Icon(
                                          Icons.circle,
                                          size: 6,
                                          color: AppColor.white,
                                        )),
                                    Text(
                                      '  Authore name:- Olive Yew  ',
                                      style: TextStyle(
                                          color:
                                              AppColor.white,
                                          fontSize: 9),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 3),
                                        child: Icon(
                                          Icons.circle,
                                          size: 6,
                                          color: AppColor.white,
                                        )),
                                    Text(
                                      '  Date:- 29/9/2022',
                                      style: TextStyle(
                                          color:
                                              AppColor.white,
                                          fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Stack(
                      children: [
                        Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              'assets/homeimage.png',
                              fit: BoxFit.fitWidth,
                            )),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 65),
                            child: Image.asset(
                              "assets/youtube.png",
                              scale: 2.9,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: 160, left: 10, right: 10),
                          child: Image.asset(
                            "assets/videodisplay.png",
                            scale: 2.9,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250,
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Image.asset(
                            'assets/heart.png',
                            scale: 2.9,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.circle,
                              size: 6,
                              color: AppColor.white,
                            )),
                        Text(
                          '  Authore name:- Olive Yew  ',
                          style: TextStyle(
                              color: AppColor.white,
                              fontSize: 9),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.circle,
                              size: 6,
                              color: AppColor.white,
                            )),
                        Text(
                          '  Date:- 29/9/2022',
                          style: TextStyle(
                              color: AppColor.white,
                              fontSize: 9),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ante justo, lacinia eget sollicitudin a, porta ut nibh. Suspendisse volutpat leo vitae consectetur placerat. Praesent blandit eleifend dolor a faucibus. Mauris commodo ullamcorper erat et scelerisque. Pellentesque urna sapien, euismod a mi id, facilisis consectetur nulla. Nam sit amet ullamcorper lectus, sed dignissim sapien. Pellentesque iaculis tristique sapien tempor varius.',
                      style: TextStyle(
                          color: AppColor.white, fontSize: 9),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ante justo, lacinia eget sollicitudin a, porta ut nibh. Suspendisse volutpat leo vitae consectetur placerat. Praesent blandit eleifend dolor a faucibus.',
                      style: TextStyle(
                          color: AppColor.white, fontSize: 9),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 120,
                            width: 150,
                            child: Image.asset(
                              'assets/atlanta.png',
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 120,
                            width: 150,
                            child: Image.asset('assets/atlanta.png')),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 250,
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ante justo, lacinia eget sollicitudin a, porta ut nibh. Suspendisse volutpat leo vitae consectetur placerat. Praesent blandit eleifend dolor a faucibus. Mauris commodo ullamcorper erat et scelerisque. Pellentesque urna sapien, euismod a mi id, facilisis consectetur nulla. Nam sit amet ullamcorper lectus, sed dignissim sapien. Pellentesque iaculis tristique sapien tempor varius.',
                      style: TextStyle(
                          color: AppColor.white, fontSize: 9),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ante justo, lacinia eget sollicitudin a, porta ut nibh. Suspendisse volutpat leo vitae consectetur placerat. Praesent blandit eleifend dolor a faucibus.',
                      style: TextStyle(
                          color: AppColor.white, fontSize: 9),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          'assets/homeimage2.png',
                          fit: BoxFit.fitWidth,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ante justo, lacinia eget sollicitudin a, porta ut nibh. Suspendisse volutpat leo vitae consectetur placerat. Praesent blandit eleifend dolor a faucibus.',
                      style: TextStyle(
                          color: AppColor.white, fontSize: 9),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ante justo, lacinia eget sollicitudin a, porta ut nibh. Suspendisse volutpat leo vitae consectetur placerat. Praesent blandit eleifend dolor a faucibus. Mauris commodo ullamcorper erat et scelerisque. Pellentesque urna sapien, euismod a mi id, facilisis consectetur nulla. Nam sit amet ullamcorper lectus, sed dignissim sapien. Pellentesque iaculis tristique sapien tempor varius.',
                      style: TextStyle(
                          color: AppColor.white, fontSize: 9),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ante justo, lacinia eget sollicitudin a, porta ut nibh. Suspendisse volutpat leo vitae consectetur placerat. Praesent blandit eleifend dolor a faucibus.',
                      style: TextStyle(
                          color: AppColor.white, fontSize: 9),
                    ),
                  ],
                ));
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 8,
            );
          },
        ),
      ),
    );
  }
}
