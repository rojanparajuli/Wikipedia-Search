import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wiki/bloc/wiki_bloc.dart';
import 'package:wiki/bloc/wiki_event.dart';
import 'package:wiki/bloc/wiki_state.dart';
import 'package:wiki/view/detail_screen.dart';

class WikipediaSearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  WikipediaSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wikipedia Search',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search Wikipedia...',
                  hintStyle: GoogleFonts.lato(),
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: (query) {
                  context.read<WikipediaBloc>().add(SearchWikipedia(query));
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<WikipediaBloc, WikipediaState>(
                builder: (context, state) {
                  if (state is WikipediaLoading) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is WikipediaLoaded) {
                    return ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        var result = state.results[index];
                        return FutureBuilder<String>(
                          future: fetchWikipediaImageUrl(result['title']),
                          builder: (context, snapshot) {
                            String? imageUrl = snapshot.data;
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                              child: ListTile(
                                leading: imageUrl != null && imageUrl.isNotEmpty
                                    ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                                    : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                title: Text(
                                  result['title'],
                                  style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                subtitle: Text(
                                  result['snippet'].replaceAll(RegExp(r'<[^>]*>'), ''),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(color: Colors.grey.shade700),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WikipediaDetailScreen(
                                        title: result['title'],
                                        snippet: result['snippet'],
                                        imageUrl: imageUrl,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is WikipediaError) {
                    return const Center(
                      child: Text('Error fetching data', style: TextStyle(color: Colors.red, fontSize: 16)),
                    );
                  }
                  return Center(
                    child: Text(
                      'Search for Wikipedia articles',
                      style: GoogleFonts.lato(color: Colors.black, fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchWikipediaImageUrl(String title) async {
    try {
      final response = await Dio().get(
        'https://en.wikipedia.org/w/api.php',
        queryParameters: {
          'action': 'query',
          'format': 'json',
          'prop': 'pageimages',
          'piprop': 'thumbnail',
          'pithumbsize': 100,
          'titles': title,
        },
      );
      var pages = response.data['query']['pages'];
      var page = pages.values.first;
      return page.containsKey('thumbnail') ? page['thumbnail']['source'] : '';
    } catch (e) {
      return '';
    }
  }
}
