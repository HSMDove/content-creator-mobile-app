import 'package:flutter/material.dart';

import '../models/content_folder.dart';

class FolderProvider extends ChangeNotifier {
  final List<ContentFolder> _folders = [];

  List<ContentFolder> get folders => List.unmodifiable(_folders);

  void addFolder(String name) {
    final folder = ContentFolder(name: name)..refreshSummary();
    _folders.add(folder);
    notifyListeners();
  }

  void addSourceToFolder({
    required ContentFolder folder,
    required String name,
    required String url,
    required ContentSourceType type,
  }) {
    folder.addSource(ContentSource(name: name, url: url, type: type));
    notifyListeners();
  }

  void refreshFolder(ContentFolder folder) {
    folder.refreshSummary();
    notifyListeners();
  }

  void seedWithExamples() {
    if (_folders.isNotEmpty) return;
    final trendsFolder = ContentFolder(name: 'أفكار فيديوهات يوتيوب');
    trendsFolder.addSource(
      const ContentSource(
        name: 'قناة التقنية بالعربي',
        url: 'https://youtube.com/techinarabic',
        type: ContentSourceType.youtube,
      ),
    );
    trendsFolder.addSource(
      const ContentSource(
        name: 'TechCrunch',
        url: 'https://techcrunch.com',
        type: ContentSourceType.website,
      ),
    );

    final researchFolder = ContentFolder(name: 'مصادر بحث عن الذكاء الاصطناعي');
    researchFolder.addSource(
      const ContentSource(
        name: 'نشرة AI بالعربي',
        url: 'https://aiexample.com/newsletter',
        type: ContentSourceType.newsletter,
      ),
    );

    _folders.addAll([trendsFolder, researchFolder]);
    notifyListeners();
  }
}
