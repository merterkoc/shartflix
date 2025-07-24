import 'package:flutter/material.dart';
import 'package:shartflix/core/widget/button/app_button.dart';
import 'package:shartflix/ui/app_ui.dart';
import 'dart:io';

class UploadPhotoView extends StatefulWidget {
  const UploadPhotoView({super.key});

  @override
  State<UploadPhotoView> createState() => _UploadPhotoViewState();
}

class _UploadPhotoViewState extends State<UploadPhotoView> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {

  }

  void _uploadPhoto() async {
    setState(() => _isLoading = true);
    // Fotoğraf yükleme işlemi burada yapılacak
    await Future.delayed(const Duration(seconds: 2)); // Simülasyon
    setState(() => _isLoading = false);
    // Başarılıysa bir sonraki sayfaya yönlendirme veya mesaj
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Fotoğraf Yükle',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Profil fotoğrafınızı yükleyin',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _selectedImage == null
                        ? Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: const Icon(Icons.add_a_photo, size: 40),
                          )
                        : ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _selectedImage == null
                        ? 'Bir fotoğraf seçmek için tıklayın'
                        : 'Seçilen fotoğraf',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingXLarge),
                child: AppButton.primary(
                  text: 'Fotoğraf Yükle',
                  width: double.infinity,
                  isLoading: _isLoading,
                  onPressed: _selectedImage == null || _isLoading ? null : _uploadPhoto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 