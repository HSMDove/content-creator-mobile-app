import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content_folder.dart';
import '../providers/folder_provider.dart';

class FolderDetailScreen extends StatefulWidget {
  const FolderDetailScreen({super.key, required this.folder});

  final ContentFolder folder;

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  final TextEditingController _sourceNameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  ContentSourceType _selectedType = ContentSourceType.youtube;

  @override
  void dispose() {
    _sourceNameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folder.name)),
      body: Consumer<FolderProvider>(
        builder: (context, provider, _) {
          final folder = widget.folder;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.analytics_outlined),
                          const SizedBox(width: 8),
                          Text('ملخص الأفكار', style: Theme.of(context).textTheme.titleMedium),
                          const Spacer(),
                          IconButton(
                            tooltip: 'تحديث الملخص',
                            onPressed: () => provider.refreshFolder(folder),
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(folder.summary),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.lightbulb, size: 18),
                            label: Text('${folder.ideaCount} فكرة متاحة'),
                          ),
                          Chip(
                            avatar: const Icon(Icons.link, size: 18),
                            label: Text('${folder.sources.length} مصادر مضافة'),
                          ),
                          Chip(
                            avatar: const Icon(Icons.access_time, size: 18),
                            label: Text('آخر تحديث: ${folder.lastUpdated.hour.toString().padLeft(2, '0')}:${folder.lastUpdated.minute.toString().padLeft(2, '0')}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('المصادر', style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _showAddSourceSheet,
                    icon: const Icon(Icons.add_link),
                    label: const Text('إضافة مصدر'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (folder.sources.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('لا توجد مصادر في هذا المجلد بعد.'),
                )
              else
                ...folder.sources.map(
                  (source) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(source.type.label.characters.first),
                    ),
                    title: Text(source.name),
                    subtitle: Text(source.url),
                    trailing: Text(source.type.label),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showAddSourceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إضافة مصدر', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _sourceNameController,
                decoration: const InputDecoration(
                  labelText: 'اسم القناة / الموقع',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'الرابط',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ContentSourceType>(
                value: _selectedType,
                items: ContentSourceType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        ))
                    .toList(),
                onChanged: (type) {
                  if (type != null) {
                    setState(() => _selectedType = type);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'نوع المصدر',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final name = _sourceNameController.text.trim();
                    final url = _urlController.text.trim();
                    if (name.isEmpty || url.isEmpty) return;
                    context.read<FolderProvider>().addSourceToFolder(
                          folder: widget.folder,
                          name: name,
                          url: url,
                          type: _selectedType,
                        );
                    _sourceNameController.clear();
                    _urlController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('حفظ'),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      _sourceNameController.clear();
      _urlController.clear();
    });
  }
}
