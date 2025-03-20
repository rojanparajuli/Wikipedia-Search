import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki/bloc/wiki_bloc.dart';
import 'package:wiki/bloc/wiki_event.dart';
import 'package:wiki/bloc/wiki_state.dart';

class WikipediaSearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  WikipediaSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wikipedia Search', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search Wikipedia...',
                  prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
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
                    return Center(child: CircularProgressIndicator(color: Colors.white));
                  } else if (state is WikipediaLoaded) {
                    return ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        var result = state.results[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          child: ListTile(
                            title: Text(result['title'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              result['snippet'].replaceAll(RegExp(r'<[^>]*>'), ''),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                            onTap: () {},
                          ),
                        );
                      },
                    );
                  } else if (state is WikipediaError) {
                    return Center(
                      child: Text('Error fetching data',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    );
                  }
                  return Center(
                    child: Text(
                      'Search for Wikipedia articles',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
}
