import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:let_me_grab/controller/firebase_controller.dart';
import 'package:let_me_grab/controller/home_controller.dart';
import 'package:let_me_grab/screens/detail/detail_screen.dart';
import 'package:let_me_grab/screens/home/widget/future_builder_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    String searchQuery = '';
    return DefaultTabController(
      length: 4, // The number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Inshorts',
            style: GoogleFonts.montserratAlternates(
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          CupertinoSearchTextField(
                            suffixIcon: const Icon(Icons.close),
                            prefixIcon: const Icon(Icons.search),
                            onSubmitted: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          searchQuery.isEmpty
                              ? Container()
                              : Expanded(
                                  child: FutureBuilder(
                                    future: Provider.of<HomeController>(context,
                                            listen: false)
                                        .search(searchQuery),
                                    builder: (context,
                                        AsyncSnapshot<Map<String, dynamic>>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: LinearProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            snapshot.error.toString(),
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        // log("search data ${snapshot.data}");
                                        log(snapshot.data!["data"]["articles"]
                                            .toString());
                                        var articleList =
                                            snapshot.data!["data"]["articles"];
                                        return ListView.separated(
                                          itemCount: articleList.length,
                                          itemBuilder: (context, index) {
                                            var subList = articleList[index];
                                            log(subList['title']);

                                            return ListTile(
                                              leading: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        subList["imageUrl"]),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                subList["title"],
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.clip),
                                                maxLines: 1,
                                              ),
                                              subtitle: Text(
                                                subList["content"],
                                                maxLines: 2,
                                              ),
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen(
                                                    imageUrl:
                                                        subList["imageUrl"],
                                                    title: subList["title"],
                                                    author:
                                                        subList["authorName"],
                                                    description:
                                                        subList["content"],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const Divider(),
                                        );
                                      }
                                      return const Text("data");
                                    },
                                  ),
                                )
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: Provider.of<FirebaseController>(context).logout,
              // onPressed: () {
              //   showDialog(
              //     context: context,
              //     builder: ((context) {
              //       return AlertDialog(
              //         title: const Text(
              //           '!',
              //           style: TextStyle(color: Colors.red),
              //         ),
              //         content: const Text(
              //           'Logout?',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //         actionsAlignment: MainAxisAlignment.spaceAround,
              //         actions: [
              //           IconButton(
              //             onPressed: (() {
              //               Navigator.pop(context);
              //             }),
              //             icon: const Icon(
              //               Icons.close,
              //               color: Colors.white,
              //             ),
              //           ),
              //           IconButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //               Provider.of<FirebaseController>(context).logout;
              //             },
              //             icon: const Icon(
              //               Icons.done,
              //               color: Colors.white,
              //             ),
              //           )
              //         ],
              //         backgroundColor: Colors.lightBlue,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(
              //             20,
              //           ),
              //         ),
              //       );
              //     }),
              //   );
              // },
              icon: const Icon(Icons.logout),
            )
          ],
          bottom: const TabBar(
            // Tabs for the TabBar
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Science'),
              Tab(text: 'Business'),
              Tab(text: 'Sports'),
            ],
          ),
        ),
        body: const TabBarView(
          // Views for the TabBar
          children: [
            FutureWidget(newsType: "all"),
            FutureWidget(newsType: "science"),
            FutureWidget(newsType: "business"),
            FutureWidget(newsType: "sports"),
          ],
        ),
      ),
    );
  }
}
