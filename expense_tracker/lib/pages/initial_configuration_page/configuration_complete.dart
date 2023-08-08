import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigurationComplete extends ConsumerStatefulWidget {
  const ConfigurationComplete({Key? key}) : super(key: key);

  @override
  ConsumerState<ConfigurationComplete> createState() =>
      _ConfigurationCompleteState();
}

class _ConfigurationCompleteState extends ConsumerState<ConfigurationComplete> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congratulations! Moneye is now configured and ready to help you manage your expenses efficiently.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Don't forget to explore other exciting features to optimize your financial journey.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
