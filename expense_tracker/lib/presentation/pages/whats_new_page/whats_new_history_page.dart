import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/style.dart';
import 'package:expense_tracker/presentation/pages/whats_new_page/whats_new_page.dart';

class WhatsNewHistoryPage extends StatefulWidget {
  static const routeName = '/whats-new-history';

  const WhatsNewHistoryPage({super.key});

  @override
  State<WhatsNewHistoryPage> createState() => _WhatsNewHistoryPageState();
}

class _WhatsNewHistoryPageState extends State<WhatsNewHistoryPage> {
  Map<String, dynamic> _allVersions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVersions();
  }

  Future<void> _loadVersions() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/Configuration/whats_new.json');
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

  @override
  Widget build(BuildContext context) {
    // Sort versions - newest first (assuming version+build format or similar)
    final versions = _allVersions.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update History"),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : versions.isEmpty
              ? const Center(child: Text("No updates found."))
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
                              color: CustomColors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: CustomColors.blue,
                            ),
                          ),
                          title: Text(
                            "Version $version",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Click to see what changed",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded,
                              color: CustomColors.clearGrey),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    WhatsNewPage(version: version),
                              ),
                            );
                          },
                        ),
                        if (index < versions.length - 1)
                          const Divider(indent: 72),
                      ],
                    );
                  },
                ),
    );
  }
}
