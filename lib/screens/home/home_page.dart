import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ningal_chat/bloc/users_list/users_list_bloc.dart';
import 'package:ningal_chat/screens/chat_screen.dart/chat_page.dart';
import 'package:ningal_chat/screens/login_sign_up/login_page.dart';
import 'package:ningal_chat/services/authentication/auth_gate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    log("jai");
    BlocProvider.of<UsersListBloc>(context).add(GetAllUsers());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ningal chat"),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthFunctions(FirebaseAuth.instance)
                    .logout(context: context);
                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                }
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: BlocBuilder<UsersListBloc, UsersListState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case UsersLoading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case UsersAllList:
              final fetchUsers = state as UsersAllList;
              return ListView.separated(
                  itemBuilder: (context, index) {
                    if (fetchUsers.allUsersList[index]["Email"] !=
                        FirebaseAuth.instance.currentUser!.email) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          tileColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.all(10),
                          minVerticalPadding: 30,
                          minLeadingWidth: 50,
                          leading: CachedNetworkImage(
                            imageUrl: fetchUsers.allUsersList[index]["image"],
                            imageBuilder: (context, imageProvider) => Container(
                              height: 70,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  allowSnapshotting: false,
                                  builder: (context) => ChatPage(
                                      anEmail: fetchUsers.allUsersList[index]
                                              ["Email"]
                                          .toString()),
                                ));
                          },
                          title: Text(fetchUsers.allUsersList[index]["name"]
                              .toString()),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.transparent,
                        height: 2,
                      ),
                  itemCount: fetchUsers.allUsersList.length);
            default:
              return const Center(
                child: Text("No Other Users "),
              );
          }
        },
      ),
    );
  }
}
