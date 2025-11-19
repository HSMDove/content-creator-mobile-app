import 'package:intl/intl.dart';

enum ContentSourceType {
  youtube('يوتيوب'),
  website('موقع'),
  podcast('بودكاست'),
  newsletter('نشرة بريدية'),
  other('أخرى');

  const ContentSourceType(this.label);
  final String label;
}

class ContentSource {
  const ContentSource({
    required this.name,
    required this.url,
    required this.type,
  });

  final String name;
  final String url;
  final ContentSourceType type;
}

class ContentFolder {
  ContentFolder({required this.name});

  final String name;
  final List<ContentSource> sources = [];
  String summary = 'أضف مصادر ليتم إنشاء ملخص ذكي لها.';
  int ideaCount = 0;
  DateTime lastUpdated = DateTime.now();

  void addSource(ContentSource source) {
    sources.add(source);
    refreshSummary();
  }

  void refreshSummary() {
    if (sources.isEmpty) {
      summary = 'لا توجد مصادر بعد. أضف روابط قنوات أو مواقع للبدء.';
      ideaCount = 0;
      lastUpdated = DateTime.now();
      return;
    }

    final buffer = StringBuffer('المجلد "$name" يحتوي على ${sources.length} مصدرًا:\n');
    for (final source in sources) {
      buffer.writeln('- ${source.type.label}: ${source.name} (${source.url})');
    }
    buffer.writeln('\nآخر تحديث: ${DateFormat('dd MMM yyyy', 'ar').format(DateTime.now())}');

    summary = buffer.toString().trim();
    ideaCount = sources.fold(0, (total, source) => total + ((source.name.length % 3) + 2));
    lastUpdated = DateTime.now();
  }
}
