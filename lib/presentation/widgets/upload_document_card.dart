import 'package:flutter/material.dart';

class UploadDocumentCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const UploadDocumentCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file_outlined),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}