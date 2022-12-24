import 'dart:convert';

import 'package:all_api_integrations/Model/UsersModel.dart';
import 'package:all_api_integrations/View/Photo_Screen.dart';
import 'package:all_api_integrations/View/Posts_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<UserModel> userList = [];

  Future<List<UserModel>> GetUser() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        userList.add(UserModel.fromJson(i));
      }
    } else {
      return userList;
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user APi get"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => PhotoPage()));
                },
                child: Text("Photo Api"),
              ),
              MaterialButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => PostsPage()));
                },
                child: Text('Post APi'),
              ),
            ],
          ),
          Expanded(
              child: FutureBuilder(
            future: GetUser(),
            builder: (BuildContext context,
                AsyncSnapshot<List<UserModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ReusebleRow(
                                  title: 'Name',
                                  value: snapshot.data![index].name.toString()),
                              ReusebleRow(
                                  title: 'email',
                                  value:
                                      snapshot.data![index].email.toString()),
                              ReusebleRow(
                                  title: 'user name',
                                  value: snapshot.data![index].username
                                      .toString()),
                              ReusebleRow(
                                  title: 'Address',
                                  value: snapshot.data![index].address!.city
                                      .toString()),
                              ReusebleRow(
                                  title: 'lat',
                                  value: snapshot.data![index].address!.geo!.lat
                                      .toString()),
                              ReusebleRow(
                                  title: 'long',
                                  value: snapshot.data![index].address!.geo!.lng
                                      .toString()),
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ))
        ],
      ),
    );
  }
}

class ReusebleRow extends StatelessWidget {
  String title, value;
  ReusebleRow({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value.toString())],
      ),
    );
  }
}
