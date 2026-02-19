import 'dart:convert';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/presentation/pages/common/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/style.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateInfoPage extends ConsumerStatefulWidget {
  static const routeName = '/update-info-page';
  final String? version;

  const UpdateInfoPage({super.key, this.version});

  @override
  ConsumerState<UpdateInfoPage> createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends ConsumerState<UpdateInfoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<dynamic> _versionFeatures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
    ));

    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/configuration/update-history.json');
      final data = jsonDecode(jsonString);

      String versionToShow;
      if (widget.version != null) {
        versionToShow = widget.version!;
      } else {
        final packageInfo = await PackageInfo.fromPlatform();
        versionToShow = packageInfo.version;
      }

      setState(() {
        _versionFeatures = data[versionToShow] ?? [];
        _isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  Future<void> _onFinish() async {
    if (widget.version != null) {
      Navigator.of(context).pop();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    await prefs.setString('last_seen_version', packageInfo.version);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final locale = appLocalizations.localeName;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CustomColors.darkBlue,
              CustomColors.blue.withValues(alpha: 0.8)
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          widget.version != null
                              ? "Moneye ${widget.version}"
                              : appLocalizations.whatsNew,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.separated(
                    itemCount: _versionFeatures.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final item = _versionFeatures[index];
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _FeatureCard(
                            title: item['title'][locale] ?? item['title']['en'],
                            description: item['description'][locale] ??
                                item['description']['en'],
                            icon: _getIconData(item['icon']),
                            delay: index * 0.1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: CustomElevatedButton(
                    text: widget.version != null
                        ? appLocalizations.back
                        : appLocalizations.continueCTA,
                    onPressed: _onFinish,
                    isLoading: false,
                    mode: CustomElevatedButtonMode.light,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'save':
        return Icons.save_rounded;
      case 'auto_graph':
        return Icons.auto_graph_rounded;
      case 'notifications':
        return Icons.notifications_active_rounded;
      case 'brush':
        return Icons.brush_rounded;
      case 'history_update':
        return Icons.history_rounded;
      case 'palette_icons':
        return Icons.palette_rounded;
      case 'analytics_chart':
        return Icons.insights_rounded;
      case 'contact_support':
        return Icons.alternate_email_rounded;
      case 'shield_check':
        return Icons.security_outlined;
      default:
        return Icons.fiber_new_rounded;
    }
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final double delay;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
