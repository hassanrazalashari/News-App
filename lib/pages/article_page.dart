import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/article.dart';
import 'package:flutter_news_app/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      width: double.infinity,
      imageUrl: article.urlToImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  CustomTag(
                    backgroundColor: Colors.grey.withAlpha(150),
                    children: [
                      Text(
                        article.source.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.25),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomTag(
                        backgroundColor: Colors.black,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(article.urlToImage),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            article.author,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    article.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    article.content,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse(article.url),
                        mode: LaunchMode.inAppWebView,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      fixedSize: const Size(280, 60),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Read The News'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomTag extends StatelessWidget {
  const CustomTag({
    Key? key,
    required this.backgroundColor,
    required this.children,
  }) : super(key: key);

  final Color backgroundColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
