import 'package:flutter/material.dart';
import 'package:flutter_news_app/api/news_api.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/pages/article_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final NewsApi api = NewsApi();
  String searchQuery = '';
  Future<List<Article>>? searchResults;

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      searchResults = api.searchNews(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        surfaceTintColor: Colors.white10,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
          ),
          onChanged: onSearch,
        ),
      ),
      body: searchResults == null
          ? const Center(child: Text('Search for news articles'))
          : FutureBuilder<List<Article>>(
              future: searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data != null) {
                  final news = snapshot.data!;

                  if (news.isEmpty) {
                    return const Center(child: Text('No articles found'));
                  }

                  return ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticlePage(article: news[index]),
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
            ),
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
