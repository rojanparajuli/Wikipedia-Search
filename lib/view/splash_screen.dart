import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki/bloc/splash/splash_screen_bloc.dart';
import 'package:wiki/bloc/splash/splash_screen_event.dart';
import 'package:wiki/bloc/splash/splash_screen_state.dart';
import 'package:wiki/view/wiki_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashCompletedState) {
               Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WikipediaSearchScreen()),
            );
          }
        },
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            final ValueNotifier<double> progressNotifier =
                ValueNotifier<double>(
              state is InternetAvailableState ? state.progress / 100 : 0.0,
            );

            if (state is InternetAvailableState) {
              progressNotifier.value = state.progress / 100;
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Wikipedia-logo-v2.svg.png',
                    height: 400,
                    width: 400,
                  ),
                  const SizedBox(height: 40),
                  if (state is CheckingInternetState) ...[
                    const Text(
                      'Checking Internet Connection...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ] else if (state is InternetNotAvailableState) ...[
                    const Icon(
                      Icons.wifi_off,
                      size: 80,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        context.read<SplashBloc>().add(CheckInternetEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ] else if (state is InternetAvailableState) ...[
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: progressNotifier,
                      builder: (context, _) {
                        return Container(
                          height: 20,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Colors.greenAccent, Colors.lightGreen],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.greenAccent.withValues(alpha: 0.4),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                LinearProgressIndicator(
                                  value: progressNotifier.value,
                                  backgroundColor: Colors.transparent,
                                  minHeight: 20,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        '${(progressNotifier.value * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
