import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bank_client/presentation/screens/register_screen.dart';
import 'package:bank_client/presentation/theme/app_theme.dart';
import 'package:bank_client/data/services/bank_api_service.dart';
import 'package:bank_client/blocs/bank/bank_bloc.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Оборачиваем в BlocProvider, чтобы Bloc был доступен на всех экранах
    return BlocProvider(
      create: (context) => BankBloc(BankApiService()),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, currentMode, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: currentMode,
            home: const RegisterScreen(),
          );
        },
      ),
    );
  }
}
