import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'LoadingRender.dart';
import 'LoginPage.dart';
import '../widgets/Posts.dart';

class BrowsePostsActivity extends StatelessWidget {
  const BrowsePostsActivity({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, appSnapshot) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                final user = FirebaseAuth.instance.currentUser;
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingRender();
                }
                if (!userSnapshot.hasData || user == null) {
                  // check for login status before render the home page
                  return const LoginPage();
                }
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('My Image, My Life'),
                    actions: [
                      DropdownButton(
                        underline: Container(),
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.exit_to_app),
                                SizedBox(width: 8),
                                Text('Logout'),
                              ],
                            ),
                            value: 'logout',
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.add),
                                SizedBox(width: 8),
                                Text('Add a new post'),
                              ],
                            ),
                            value: 'add',
                          ),
                        ],
                        onChanged: (itemIdentifier) {
                          if (itemIdentifier == 'logout') {
                            FirebaseAuth.instance.signOut();
                          }
                          if (itemIdentifier == 'add') {
                            Navigator.pushNamed(context, '/newPost');
                          }
                        },
                      ),
                    ],
                  ),
                  body: ListView(
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const <Widget>[
                      Divider(
                        height: 8,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 1200,
                        child: Posts(),
                      ),

                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/newPost');
                    },
                    tooltip: 'Add Item to post',
                    child: const Icon(Icons.add),
                  ),
                );
              });
        });
  }
}
