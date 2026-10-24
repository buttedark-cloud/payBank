import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/bank/bank_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Банковское приложение'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: BlocConsumer<BankBloc, BankState>(
        listener: (context, state) {
          // Здесь мы будем показывать всплывающие окна (успех / ошибка)
          if (state is BankError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          // Если идет загрузка — крутим лоадер
          if (state is BankLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Основной интерфейс приложения
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Добро пожаловать в клиент банка!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Здесь скоро появятся наши кнопки и текстовые поля для регистрации и переводов
                ElevatedButton(
                  onPressed: () {
                    // Пример вызова события регистрации
                    // BlocProvider.of<BankBloc>(context).add(RegisterUserEvent(name: 'Иван', passportNumber: '12345'));
                  },
                  child: const Text('Тестовая кнопка'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
