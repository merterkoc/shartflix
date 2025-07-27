import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix/bloc/user/user_bloc.dart';
import 'package:shartflix/core/extensions/context_ext.dart';
import 'package:shartflix/core/widget/app_error_bottom_sheet.dart';
import 'package:shartflix/core/widget/button/app_button.dart';
import 'package:shartflix/core/widget/logo_box.dart';

class PhotoUploadView extends StatefulWidget {
  const PhotoUploadView({super.key});

  @override
  State<PhotoUploadView> createState() => _PhotoUploadViewState();
}

class _PhotoUploadViewState extends State<PhotoUploadView> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 20,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen: (state, previous) =>
          state.uploadProfilePictureResponse.status !=
          previous.uploadProfilePictureResponse.status,
      listener: (context, state) {
        if (state.uploadProfilePictureResponse.status.isSuccess) {
          context.pop();
        } else if (state.uploadProfilePictureResponse.status.isError) {
          if (state.uploadProfilePictureResponse.statusCode == 413) {
            showAppErrorBottomSheet(
              context: context,
              title: context.l10n.upload_failed_title,
              message: context.l10n.upload_failed_image_too_large,
            );
          } else {
            showAppErrorBottomSheet(
              context: context,
              title: context.l10n.upload_failed_title,
              message:
                  state.uploadProfilePictureResponse.message ??
                  context.l10n.upload_failed_unknown_error,
            );
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<UserBloc, UserState>(
              buildWhen: (state, previous) =>
                  state.uploadProfilePictureResponse.status !=
                  previous.uploadProfilePictureResponse.status,
              builder: (context, state) {
                return AppButton.primary(
                  isLoading:
                      state.uploadProfilePictureResponse.status.isLoading,
                  onPressed: _imageFile == null
                      ? null
                      : () {
                          context.read<UserBloc>().add(
                            UploadProfilePictureRequested(file: _imageFile!),
                          );
                        },
                  text: context.l10n.photo_upload_next_button,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
        appBar: AppBar(title: Text(context.l10n.photo_upload_title)),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              spacing: 20,
              children: [
                Text(
                  context.l10n.photo_upload_title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  context.l10n.photo_upload_subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (_imageFile != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _imageFile!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: LogoBox(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icons.add,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
