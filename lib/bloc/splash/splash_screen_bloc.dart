import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wiki/bloc/splash/splash_screen_event.dart';
import 'package:wiki/bloc/splash/splash_screen_state.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckInternetEvent>(_onCheckInternet);
    on<IncrementProgressEvent>(_onIncrementProgress);
  }

  Future<void> _onCheckInternet(
      CheckInternetEvent event, Emitter<SplashState> emit) async {
    emit(CheckingInternetState());

    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      if (response.statusCode == 200) {
        emit(InternetAvailableState(0));
        for (int i = 1; i <= 100; i++) {
          await Future.delayed(const Duration(milliseconds: 30));
          add(IncrementProgressEvent());
        }
      } else {
        emit(InternetNotAvailableState());
      }
    } catch (e) {
      emit(InternetNotAvailableState());
    }
  }

  void _onIncrementProgress(
      IncrementProgressEvent event, Emitter<SplashState> emit) {
    if (state is InternetAvailableState) {
      final currentState = state as InternetAvailableState;
      final newProgress = currentState.progress + 1;

      if (newProgress < 100) {
        emit(InternetAvailableState(newProgress));
      } else {
        emit(SplashCompletedState());
      }
    }
  }
}