abstract class WikipediaEvent {}

class SearchWikipedia extends WikipediaEvent {
  final String query;
  SearchWikipedia(this.query);
}
