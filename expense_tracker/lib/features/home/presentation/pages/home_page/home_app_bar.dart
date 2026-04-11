import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      'Dashboard',
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }
}
