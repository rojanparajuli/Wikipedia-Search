
abstract class SplashState  {
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class CheckingInternetState extends SplashState {}

class InternetAvailableState extends SplashState {
  final int progress;

  InternetAvailableState(this.progress);

  @override
  List<Object?> get props => [progress];
}

class InternetNotAvailableState extends SplashState {}

class SplashCompletedState extends SplashState {}