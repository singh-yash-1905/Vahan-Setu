import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileImageSection extends StatelessWidget {
  final File? profileImage;
  final VoidCallback? onChangeImage;

  const ProfileImageSection({super.key, this.profileImage, this.onChangeImage});

  void _viewImage(BuildContext context) {
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No profile picture uploaded yet.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Image.file(profileImage!, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _viewImage(context),
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: ClipOval(
              child: profileImage != null
                  ? Image.file(
                      profileImage!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.person_rounded,
                      size: 72,
                      color: AppColors.primary,
                    ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () => _viewImage(context),
              icon: const Icon(Icons.visibility_rounded, size: 17),
              label: const Text('View Picture'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(
                  0,
                  44,
                ), // Fixes infinite width constraint crash
                foregroundColor: AppColors.primary,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.45),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),

            const SizedBox(width: 10),

            ElevatedButton.icon(
              onPressed: onChangeImage,
              icon: const Icon(Icons.camera_alt_rounded, size: 17),
              label: Text(profileImage == null ? 'Upload' : 'Change'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  0,
                  44,
                ), // Fixes infinite width constraint crash
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
