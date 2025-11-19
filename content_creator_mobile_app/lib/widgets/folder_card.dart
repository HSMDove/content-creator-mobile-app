import 'package:flutter/material.dart';

import '../models/content_folder.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
  });

  final ContentFolder folder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      folder.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Chip(
                    label: Text('${folder.ideaCount} فكرة'),
                    avatar: const Icon(Icons.lightbulb_outline, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                folder.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.collections_bookmark, size: 20, color: Colors.blueGrey.shade400),
                  const SizedBox(width: 4),
                  Text('${folder.sources.length} مصادر'),
                  const Spacer(),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
