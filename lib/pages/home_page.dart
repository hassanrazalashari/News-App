import 'package:flutter/material.dart';
import 'package:flutter_news_app/api/news_api.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/pages/article_page.dart';
import 'package:flutter_news_app/pages/search_page.dart';

import '../api/news_repository.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final api = NewsApi();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'News App',
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 24,
                  fontWeight: FontWeight.w400),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About This App'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('News App'),
                          SizedBox(height: 10),
                          Text(
                              'This app provides the latest news across various categories including General, Health, Technology, Science, and Top Headlines.'),
                          SizedBox(height: 10),
                          Text(
                              'Built using Flutter, it fetches news data from an API and displays it in a user-friendly format.'),
                          SizedBox(height: 10),
                          Text('Developed by Hassan Raza'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.info, color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicator: BoxDecoration(
              color: Colors.green, // Set the color of the selected tab
              borderRadius:
                  BorderRadius.circular(20), // Optional: adjust border radius
            ),
            tabs: [
              tabDetail(context, 'General'),
              tabDetail(context, 'Health'),
              tabDetail(context, 'Technology'),
              tabDetail(context, 'Science'),
              tabDetail(context, 'Top headlines'),
            ],
            labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
            labelColor: Colors.white,
            unselectedLabelColor:
                Colors.white, // Set the color of unselected tabs' text
          ),
        ),
        body: TabBarView(
          children: [
            FetchNews(future: api.fetchCategory(Category.general)),
            FetchNews(future: api.fetchCategory(Category.health)),
            FetchNews(future: api.fetchCategory(Category.technology)),
            FetchNews(future: api.fetchCategory(Category.science)),
            FetchNews(future: api.fetchAllNews()),
          ],
        ),
      ),
    );
  }

  Tab tabDetail(BuildContext context, String text) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.transparent),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class FetchNews extends StatelessWidget {
  const FetchNews({super.key, required this.future});
  final Future<List<Article>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          final news = snapshot.data!;

          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticlePage(article: news[index]),
                    ),
                  );
                },
                child: Row(
                  children: [
                    ImageContainer(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.all(10.0),
                      borderRadius: 5,
                      imageUrl: news[index].urlToImage,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            news[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.source, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                news[index].source.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 20),
                              const Icon(Icons.person, size: 18),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  news[index].author,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('Error fetching articles'));
        }
      },
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    this.height = 128,
    this.borderRadius = 24,
    required this.width,
    required this.imageUrl,
    this.margin,
    this.child,
  }) : super(key: key);

  final double width;
  final double height;
  final String imageUrl;
  final EdgeInsets? margin;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
