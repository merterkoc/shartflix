import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:image/image.dart' as img;
import 'package:shartflix/api/interface/i_api_provider.dart';
import 'package:shartflix/model/dto/user/user_dto.dart';
import 'package:shartflix/repository/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserState.initial()) {
    on<FetchUser>(_onFetchUser);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<UploadProfilePictureRequested>(_onUploadProfilePictureRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final UserRepository userRepository;

  Future<void> _onFetchUser(
    FetchUser event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        userResponse: ResponseEntity<UserDTO>.loading(
          data: state.userResponse.data,
        ),
      ),
    );

    try {
      final response = await userRepository.getUserProfile();
      if (response.isOk) {
        final data = response.data as Map<String, dynamic>;
        final user = UserDTO.fromJson(data['data'] as Map<String, dynamic>);
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.success(data: user),
          ),
        );
      } else {
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.error(
              message: response.message ?? 'FETCH_USER_FAILED',
              statusCode: response.statusCode,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userResponse: ResponseEntity<UserDTO>.error(
            message: e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        userResponse: ResponseEntity<UserDTO>.loading(),
      ),
    );

    try {
      final response = await userRepository.login(
        email: event.email,
        password: event.password,
      );
      if (response.isOk) {
        final data = response.data as Map<String, dynamic>;
        final user = UserDTO.fromJson(data['data'] as Map<String, dynamic>);
        await userRepository.setToken(OAuth2Token(accessToken: user.token!));
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.success(data: user),
          ),
        );
      } else {
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.error(
              message: response.message ?? 'LOGIN_FAILED',
              statusCode: response.statusCode,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userResponse: ResponseEntity<UserDTO>.error(
            message: e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        userResponse: ResponseEntity<UserDTO>.loading(),
      ),
    );
    try {
      final response = await userRepository.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      if (event.password != event.confirmPassword) {
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.error(
              message: 'NO_PASSWORD_MATCH',
            ),
          ),
        );
        return;
      }
      if (response.isOk) {
        final data = response.data as Map<String, dynamic>;
        final user = UserDTO.fromJson(data['data'] as Map<String, dynamic>);
        await userRepository.setToken(OAuth2Token(accessToken: user.token!));
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.success(data: user),
          ),
        );
      } else {
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.error(
              message: response.message ?? 'UNKNOWN_ERROR',
              statusCode: response.statusCode,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userResponse: ResponseEntity<UserDTO>.error(
            message: e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onUploadProfilePictureRequested(
    UploadProfilePictureRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        uploadProfilePictureResponse: ResponseEntity<UserDTO>.loading(),
      ),
    );
    try {
      final compressedFile = await _compressImage(event.file);

      final response = await userRepository.uploadProfilePicture(
        file: compressedFile,
      );
      if (response.isOk) {
        final data = response.data as Map<String, dynamic>;
        final userDTO = UserDTO.fromJson(data['data'] as Map<String, dynamic>);
        emit(
          state.copyWith(
            userResponse: ResponseEntity<UserDTO>.success(
              data: state.userResponse.data!.copyWith(
                photoUrl: userDTO.photoUrl,
              ),
            ),
            uploadProfilePictureResponse: ResponseEntity<UserDTO>.success(
              data: userDTO,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            uploadProfilePictureResponse: ResponseEntity<UserDTO>.error(
              message: response.message ?? 'PROFILE_PICTURE_UPLOAD_FAILED',
              statusCode: response.statusCode,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userResponse: ResponseEntity<UserDTO>.error(
            message: e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  /// Compresses the image to reduce file size while maintaining quality
  Future<File> _compressImage(File originalFile) async {
    try {
      // Read the original image
      final Uint8List bytes = await originalFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        return originalFile; // Return original if decoding fails
      }

      // Calculate new dimensions (max width/height of 800px while maintaining aspect ratio)
      const int maxDimension = 800;
      int newWidth = originalImage.width;
      int newHeight = originalImage.height;

      if (originalImage.width > maxDimension ||
          originalImage.height > maxDimension) {
        if (originalImage.width > originalImage.height) {
          newWidth = maxDimension;
          newHeight =
              (originalImage.height * maxDimension / originalImage.width)
                  .round();
        } else {
          newHeight = maxDimension;
          newWidth = (originalImage.width * maxDimension / originalImage.height)
              .round();
        }
      }

      // Resize the image
      final img.Image resizedImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Encode as JPEG with quality 85 (good balance between quality and file size)
      final Uint8List compressedBytes = img.encodeJpg(
        resizedImage,
        quality: 85,
      );

      // Create a temporary file for the compressed image
      final String tempPath = '${originalFile.path}_compressed.jpg';
      final File compressedFile = File(tempPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      // If compression fails, return the original file
      return originalFile;
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<UserState> emit,
  ) async {
    userRepository.logout();
  }
}
