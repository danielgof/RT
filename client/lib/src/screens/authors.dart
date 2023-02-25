import 'package:client/src/screens/pages/offer_page.dart';
import 'package:client/src/screens/pages/registration_page.dart';
import 'package:flutter/material.dart';

import '../models/library.dart';
import '../routing.dart';
import '../widgets/author_list.dart';

class AuthorsScreen extends StatelessWidget {
  final String title = 'Profile';

  const AuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: Container(
      constraints: BoxConstraints.loose(const Size(600, 600)),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OfferRegistrationPage()
                  ),
                );
              },
              child: const Text('New user? Click to register.'),
            ),
          ),
        ],
      ),
    ),

    // AuthorList(
    //   authors: libraryInstance.allAuthors,
    //   onTap: (author) {
    //     RouteStateScope.of(context).go('/author/${author.id}');
    //   },
    // ),
  );
}
