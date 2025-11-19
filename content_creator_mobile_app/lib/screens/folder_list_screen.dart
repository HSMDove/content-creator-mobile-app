import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/folder_provider.dart';
import '../widgets/folder_card.dart';
import 'folder_detail_screen.dart';

class FolderListScreen extends StatefulWidget {
  const FolderListScreen({super.key});

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  final TextEditingController _folderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FolderProvider>().seedWithExamples();
    });
  }

  @override
  void dispose() {
    _folderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منظم أفكار المحتوى'),
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 16),
            child: Icon(Icons.auto_awesome),
          ),
        ],
      ),
      body: Consumer<FolderProvider>(
        builder: (context, provider, _) {
          if (provider.folders.isEmpty) {
            return const Center(
              child: Text('لا توجد مجلدات بعد، أنشئ أول مجلد لإضافة المصادر.'),
            );
          }

          return ListView.builder(
            itemCount: provider.folders.length,
            itemBuilder: (context, index) {
              final folder = provider.folders[index];
              return FolderCard(
                folder: folder,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FolderDetailScreen(folder: folder),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFolderSheet,
        icon: const Icon(Icons.create_new_folder),
        label: const Text('مجلد جديد'),
      ),
    );
  }

  void _showAddFolderSheet() {
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
              Text('إنشاء مجلد', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _folderController,
                decoration: const InputDecoration(
                  labelText: 'اسم المجلد',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final name = _folderController.text.trim();
                    if (name.isEmpty) return;
                    context.read<FolderProvider>().addFolder(name);
                    _folderController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('حفظ'),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(_folderController.clear);
  }
}
