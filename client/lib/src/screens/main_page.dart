import 'dart:convert';
import 'dart:io';

import 'package:RT/src/models/offer.dart';
import 'package:RT/src/models/offers.dart';
import 'package:RT/src/screens/private_pages/alloffers_private_page.dart';
import 'package:RT/src/screens/public_pages/alloffers_public_page.dart';
import 'package:RT/src/screens/private_pages/map_page.dart';
import 'package:RT/src/widgets/offers_list.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../data.dart';
import '../routing.dart';
import '../widgets/book_list.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({
    super.key,
  });

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(_handleTabIndexChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newPath = _routeState.route.pathTemplate;
    if (newPath.startsWith('/books/popular')) {
      _tabController.index = 0;
    } else if (newPath.startsWith('/books/new')) {
      _tabController.index = 1;
    } else if (newPath == '/books/all') {
      _tabController.index = 2;
    } else if (newPath == '/books/map') {
      _tabController.index = 3;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Rent a Tool'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'All',
                icon: Icon(Icons.list),
              ),
              Tab(
                text: 'Messages',
                icon: Icon(Icons.people),
              ),
              Tab(
                text: 'New',
                icon: Icon(Icons.new_releases),
              ),
              Tab(
                text: 'Map',
                icon: Icon(Icons.map),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            AllOffersPrivatePage(),
            BookList(
              books: libraryInstance.popularBooks,
              onTap: _handleBookTapped,
            ),
            OffersList(
              // offers: getOffersRequest(),
              offers: [Offer(id: 1, toolName: "test", toolDescription: "test", price: "test")],
              // offers: offers.getOffersRequest(),
              onTap: _handleOfferTapped,
            ),
            MapPage()
            // AllOffersPage(),
            // BookList(
            //   books: libraryInstance.newBooks,
            //   onTap: _handleBookTapped,
            // ),

            // BookList(
            //   books: libraryInstance.allBooks,
            //   onTap: _handleBookTapped,
            // ),
          ],
        ),
      );

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleBookTapped(Book book) {
    _routeState.go('/book/${book.id}');
  }

  void _handleOfferTapped(Offer offer) {
    _routeState.go('/book/${offer.id}');
  }

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 1:
        _routeState.go('/books/new');
        break;
      case 2:
        _routeState.go('/books/all');
        break;
      case 0:
      default:
        _routeState.go('/books/popular');
        break;
    }
  }
}