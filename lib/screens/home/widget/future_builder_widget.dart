import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:let_me_grab/controller/home_controller.dart';
import 'package:let_me_grab/screens/detail/detail_screen.dart';
import 'package:provider/provider.dart';

class FutureWidget extends StatelessWidget {
  final String newsType;
  const FutureWidget({
    super.key,
    required this.newsType,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<HomeController>(context).fetchNews(newsType),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: LinearProgressIndicator(
                color: Colors.blue,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else if (snapshot.hasData) {
          // log("data is snap shot ${snapshot.data}");
          var listData = snapshot.data!['data'];
          // log(listData.length.toString());
          return ListView.separated(
            itemCount: listData.length,
            itemBuilder: (context, index) {
              var subList = listData[index];
              log(subList['title']);

              return ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(subList["imageUrl"]),
                    ),
                  ),
                ),
                title: Text(
                  subList["title"],
                  style: const TextStyle(overflow: TextOverflow.clip),
                  maxLines: 1,
                ),
                subtitle: Text(
                  subList["content"],
                  maxLines: 2,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      imageUrl: subList["imageUrl"],
                      title: subList["title"],
                      author: subList["author"],
                      description: subList["content"],
                    ),
                  ),
                ),
              );

              // return Card(
              //   color: Colors.red,
              //   child: Container(
              //     height: 200,
              //     width: double.infinity,
              //     child: Row(
              //       children: [
              //         Container(
              //           width: 100,
              //           height: 100,
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             image: DecorationImage(
              //               fit: BoxFit.cover,
              //               image: NetworkImage(subList["imageUrl"]),
              //             ),
              //           ),
              //         ),
              //         Text(
              //           subList["title"],
              //           style: TextStyle(overflow: TextOverflow.fade),
              //         )
              //       ],
              //     ),
              //   ),
              // );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        }
        return const Text("data");
      },
    );
  }
}
