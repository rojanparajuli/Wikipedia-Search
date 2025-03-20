abstract class WikipediaState {}

class WikipediaInitial extends WikipediaState {}

class WikipediaLoading extends WikipediaState {}

class WikipediaLoaded extends WikipediaState {
  final List<dynamic> results;
  WikipediaLoaded(this.results);
}

class WikipediaError extends WikipediaState {}
