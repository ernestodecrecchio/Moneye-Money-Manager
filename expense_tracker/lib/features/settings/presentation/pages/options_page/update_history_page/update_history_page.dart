import 'dart:convert';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/update_history_page/update_info_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateHistoryPage extends ConsumerStatefulWidget {
  static const routeName = '/updates-history';

  const UpdateHistoryPage({super.key});

  @override
  ConsumerState<UpdateHistoryPage> createState() => _UpdateHistoryPageState();
}

class _UpdateHistoryPageState extends ConsumerState<UpdateHistoryPage> {
  Map<String, dynamic> _allVersions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVersions();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    // Sort versions - newest first (assuming version+build format or similar)
    final versions = _allVersions.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.updateHistory),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : versions.isEmpty
              ? Center(
                  child: Text(appLocalizations.updateHistoryEmptyList),
                )
              : ListView.builder(
                  itemCount: versions.length,
                  itemBuilder: (context, index) {
                    final version = versions[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.history_rounded,
                              color: colors.primary,
                            ),
                          ),
                          title: Text(
                            "${appLocalizations.version} $version",
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateInfoPage(version: version),
                              ),
                            );
                          },
                        ),
                        if (index < versions.length - 1) const Divider(),
                      ],
                    );
                  },
                ),
    );
  }

  Future<void> _loadVersions() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/configuration/update-history.json');
      final data = jsonDecode(jsonString);
      setState(() {
        _allVersions = data;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
