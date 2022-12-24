import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List<Photos> photoList = [];

  Future<List<Photos>> getPhoto() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        Photos photos = Photos(id: i['id'], title: i['title'], url: i['url']);
        photoList.add(photos);
      }
      return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photo Api")),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getPhoto(),
            builder: ((context, AsyncSnapshot<List<Photos>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: photoList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text('Id: ${snapshot.data![index].id}'),
                          subtitle:
                              Text(snapshot.data![index].title.toString()),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data![index].url.toString()),
                          ));
                    });
              }
            }),
          ))
        ],
      ),
    );
  }
}

class Photos {
  String title, url;
  int id;
  Photos({required this.id, required this.title, required this.url});
}
