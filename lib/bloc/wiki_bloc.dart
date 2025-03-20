import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki/bloc/wiki_event.dart';
import 'package:wiki/bloc/wiki_state.dart';

class WikipediaBloc extends Bloc<WikipediaEvent, WikipediaState> {
  WikipediaBloc() : super(WikipediaInitial()) {
    on<SearchWikipedia>(_onSearchWikipedia);
  }

  Future<void> _onSearchWikipedia(
      SearchWikipedia event, Emitter<WikipediaState> emit) async {
    emit(WikipediaLoading());
    try {
      final response = await Dio().get(
        'https://en.wikipedia.org/w/api.php',
        queryParameters: {
          'action': 'query',
          'format': 'json',
          'list': 'search',
          'srsearch': event.query,
        },
      );
      emit(WikipediaLoaded(response.data['query']['search']));
    } catch (_) {
      emit(WikipediaError());
    }
  }
}