import 'package:flutter/services.dart';

class AssetRegistry {
  AssetRegistry._();

  static final AssetRegistry instance = AssetRegistry._();

  Set<String>? _assetPaths;

  Future<void> init() async {
    if (_assetPaths != null) return;
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    _assetPaths = manifest.listAssets().toSet();
  }

  bool exists(String path) {
    return _assetPaths?.contains(path) ?? false;
  }
}
