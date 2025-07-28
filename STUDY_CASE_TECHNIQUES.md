# Shartflix Study Case - Kullanılan Teknikler ve Best Practices

Bu dokümanda Shartflix projesinde kullanılan modern Flutter teknikleri ve best practice'ler detaylı olarak açıklanmaktadır.

## 📋 İçindekiler

1. [Dependency Injection (GetIt)](#dependency-injection-getit)
2. [State Management (BLoC Pattern)](#state-management-bloc-pattern)
3. [Form Validation (Formz)](#form-validation-formz)
4. [Theme Management](#theme-management)
5. [Back Button Icon in Theme](#back-button-icon-in-theme)
6. [Isolate for Heavy Operations](#isolate-for-heavy-operations)
7. [CustomScrollView Optimization](#customscrollview-optimization)
8. [HTTP Client Architecture](#http-client-architecture)
9. [Authentication Management](#authentication-management)
10. [Asset Management](#asset-management)
11. [Environment Management](#environment-management)
12. [Localization](#localization)
13. [Testing](#testing)

---

## 🔧 Dependency Injection (GetIt)

### Kullanım Amacı
Global değişkenleri ve servisleri merkezi bir şekilde yönetmek için GetIt kullanılmıştır.

### Implementasyon

```dart
// lib/boot.dart
class BootService {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    GetIt.instance.registerSingleton<SettingsController>(
      SettingsController(SettingsService()),
    );
    // ...
  }
}

// Kullanım
final settingsController = GetIt.instance<SettingsController>();
```

### Avantajlar
- ✅ **Merkezi yönetim**: Tüm servisler tek yerden yönetilir
- ✅ **Test edilebilirlik**: Mock servisler kolayca enjekte edilebilir
- ✅ **Lazy loading**: Servisler sadece gerektiğinde yüklenir
- ✅ **Singleton pattern**: Tek instance garantisi

---

## 🎯 State Management (BLoC Pattern)

### Kullanım Amacı
Uygulama state'ini yönetmek ve UI ile business logic'i ayırmak için BLoC pattern kullanılmıştır.

### Implementasyon

```dart
// Event
abstract class UserEvent extends Equatable {
  const UserEvent();
}

class LoginRequested extends UserEvent {
  const LoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

// State
class UserState extends Equatable {
  const UserState({
    this.userResponse = const ResponseEntity<UserDTO>.initial(),
    this.uploadProfilePictureResponse = const ResponseEntity<UserDTO>.initial(),
  });

  final ResponseEntity<UserDTO> userResponse;
  final ResponseEntity<UserDTO> uploadProfilePictureResponse;

  UserState copyWith({
    ResponseEntity<UserDTO>? userResponse,
    ResponseEntity<UserDTO>? uploadProfilePictureResponse,
  }) {
    return UserState(
      userResponse: userResponse ?? this.userResponse,
      uploadProfilePictureResponse: uploadProfilePictureResponse ?? this.uploadProfilePictureResponse,
    );
  }

  @override
  List<Object?> get props => [userResponse, uploadProfilePictureResponse];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<UploadProfilePictureRequested>(_onUploadProfilePictureRequested);
  }

  final UserRepository userRepository;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(
      userResponse: ResponseEntity<UserDTO>.loading(),
    ));

    try {
      final response = await userRepository.login(
        email: event.email,
        password: event.password,
      );
      
      if (response.isOk) {
        // Success handling
        emit(state.copyWith(
          userResponse: ResponseEntity<UserDTO>.success(data: user),
        ));
      } else {
        // Error handling
        emit(state.copyWith(
          userResponse: ResponseEntity<UserDTO>.error(
            message: response.message ?? 'LOGIN_FAILED',
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        userResponse: ResponseEntity<UserDTO>.error(
          message: e.toString(),
        ),
      ));
    }
  }
}
```

### Avantajlar
- ✅ **Separation of concerns**: UI ve business logic ayrı
- ✅ **Predictable state**: State değişimleri öngörülebilir
- ✅ **Testable**: Her event ve state ayrı test edilebilir
- ✅ **Reactive**: UI otomatik olarak state değişimlerine tepki verir

---

## 📝 Form Validation (Formz)

### Kullanım Amacı
Form validasyonlarını type-safe ve reusable bir şekilde yönetmek için Formz kullanılmıştır.

### Implementasyon

```dart
// lib/core/form_validation/email_input.dart
enum EmailValidationError { empty, invalid }

class EmailInput extends FormzInput<String, EmailValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([super.value = '']) : super.dirty();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+ *$');

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return _emailRegex.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

// Kullanım
class LoginValidationBloc extends Bloc<LoginValidationEvent, LoginValidationState> {
  LoginValidationBloc() : super(LoginValidationState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginValidationState> emit) {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }
}
```

### Avantajlar
- ✅ **Type-safe**: Compile-time validation
- ✅ **Reusable**: Aynı validation farklı formlarda kullanılabilir
- ✅ **Testable**: Her validation ayrı test edilebilir
- ✅ **Composable**: Birden fazla validation birleştirilebilir

---

## 🎨 Theme Management

### Kullanım Amacı
Uygulama genelinde tutarlı bir tasarım sistemi oluşturmak ve dinamik tema değişimi sağlamak.

### Implementasyon

```dart
// lib/core/theme/material_theme.dart
abstract class MaterialTheme {
  const MaterialTheme();
  ThemeData? light();
  ThemeData? dark();
}

// lib/core/theme/default/default_theme.dart
class DefaultMaterialTheme extends MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff666014),
      surfaceTint: Color(0xff666014),
      onPrimary: Color(0xffffffff),
      // ... diğer renkler
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    // ... tema ayarları
  );
}

// lib/shartflix_app.dart
class ShartflixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsController = GetIt.instance<SettingsController>();

    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        final themeMap = <int, MaterialTheme>{
          0: const DefaultMaterialTheme(),
          1: const BlueMaterialTheme(),
          2: const GreenMaterialTheme(),
          3: const PinkMaterialTheme(),
        };

        final theme = themeMap[settingsController.themeStyle] ?? const DefaultMaterialTheme();
        
        return MaterialApp(
          theme: theme.light(),
          darkTheme: theme.dark(),
          // ...
        );
      },
    );
  }
}
```

### Avantajlar
- ✅ **Consistent design**: Tüm uygulamada tutarlı tasarım
- ✅ **Dynamic themes**: Runtime'da tema değişimi
- ✅ **Material 3**: Modern design system
- ✅ **Accessibility**: Renk kontrastları optimize edilmiş

---

## 🔙 Back Button Icon in Theme

### Kullanım Amacı
Back button ikonunu tema içinde tanımlayarak tüm uygulamada tutarlı bir görünüm sağlamak.

### Implementasyon

```dart
// lib/shartflix_app.dart
ThemeData applyBackButtonIcon(ThemeData baseTheme) {
  return baseTheme.copyWith(
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => LogoBox(
        width: 222,
        height: 222,
        borderRadius: 9999,
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
      ),
    ),
  );
}

// Kullanım
return MaterialApp(
  theme: applyBackButtonIcon(theme.light()),
  darkTheme: applyBackButtonIcon(theme.dark()),
  // ...
);
```

### Avantajlar
- ✅ **Consistent navigation**: Tüm sayfalarda aynı back button
- ✅ **Brand integration**: Logo ile entegre back button
- ✅ **Theme-aware**: Tema renklerine uyumlu
- ✅ **Centralized**: Tek yerden yönetim

---

## ⚡ Isolate for Heavy Operations

### Kullanım Amacı
UI thread'i bloklamamak için ağır işlemleri (image compression) background thread'de çalıştırmak.

### Implementasyon

```dart
// lib/bloc/user/user_bloc.dart
Future<File> _compressImage(File originalFile) async {
  try {
    // Use isolate to compress image in background thread
    final compressedBytes = await _compressImageInIsolate(originalFile);
    
    // Create a temporary file for the compressed image
    final tempPath = '${originalFile.path}_compressed.jpg';
    final compressedFile = File(tempPath);
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  } on Exception {
    return originalFile;
  }
}

Future<Uint8List> _compressImageInIsolate(File originalFile) async {
  final bytes = await originalFile.readAsBytes();
  
  return Isolate.run(() {
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      return bytes;
    }

    const maxDimension = 800;
    var newWidth = originalImage.width;
    var newHeight = originalImage.height;

    if (originalImage.width > maxDimension || originalImage.height > maxDimension) {
      if (originalImage.width > originalImage.height) {
        newWidth = maxDimension;
        newHeight = (originalImage.height * maxDimension / originalImage.width).round();
      } else {
        newHeight = maxDimension;
        newWidth = (originalImage.width * maxDimension / originalImage.height).round();
      }
    }

    final resizedImage = img.copyResize(
      originalImage,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.linear,
    );

    return img.encodeJpg(resizedImage, quality: 85);
  });
}
```

### Avantajlar
- ✅ **Non-blocking UI**: UI thread bloklanmaz
- ✅ **Better UX**: Kullanıcı deneyimi iyileşir
- ✅ **Background processing**: Ağır işlemler arka planda
- ✅ **Error handling**: Hata durumunda fallback

---

## 📱 CustomScrollView Optimization

### Kullanım Amacı
Scroll view'ın her durumda çalışmasını sağlamak ve nested scroll view sorunlarını çözmek.

### Implementasyon

```dart
// lib/feature/home/view/profile_tab.dart
return CustomScrollView(
  physics: const BouncingScrollPhysics(),
  slivers: [
    CupertinoSliverRefreshControl(
      onRefresh: () async {
        // Refresh logic
      },
    ),
    SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Content
        ]),
      ),
    ),
    const SliverFillRemaining(
      hasScrollBody: false,
      child: SizedBox.shrink(),
    ),
  ],
);
```

### Avantajlar
- ✅ **Always scrollable**: Her durumda scroll edilebilir
- ✅ **Refresh support**: Pull-to-refresh özelliği
- ✅ **No nested scroll**: Nested scroll view sorunu yok
- ✅ **Flexible content**: Dinamik içerik desteği

---

## 🌐 HTTP Client Architecture

### Kullanım Amacı
HTTP isteklerini yönetmek, token authentication ve error handling sağlamak.

### Implementasyon

```dart
// lib/http/dio/interface/i_dio_client.dart
abstract class IDioClient {
  IDioClient({
    required String url,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Interceptor? interceptor,
  }) {
    baseUrl = url;
    _dio
      ..options.baseUrl = url.endsWith('/') ? url : '$url/'
      ..options.connectTimeout = connectTimeout ?? const Duration(seconds: 20)
      ..options.receiveTimeout = receiveTimeout ?? const Duration(seconds: 20)
      ..options.responseType = ResponseType.json
      ..interceptors.add(LogInterceptor(
        responseBody: kDebugMode || kProfileMode,
        requestBody: kDebugMode || kProfileMode,
      ))
      ..interceptors.add(interceptor ?? DefaultHttpHeaderInterceptor())
      ..interceptors.add(_fresh);
  }

  final Fresh<OAuth2Token> _fresh = Fresh.oAuth2(
    tokenHeader: (token) => {'Authorization': token.accessToken},
    tokenStorage: TokenStorageImpl(),
    shouldRefresh: (response) => response?.statusCode == 401 || response?.statusCode == 403,
    refreshToken: (token, client) => throw RevokeTokenException(),
  );

  Future<ResponseEntity<T>> get<T>(String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    // Implementation
  }
}

// lib/api/interface/i_api_provider.dart
abstract class ApiProvider {
  ApiProvider(this._path, {this.interceptor});
  
  late final DioClient _dio = DioClient(interceptor: interceptor);
  final String _path;
  final Interceptor? interceptor;

  Future<ResponseEntity<dynamic>> get({
    String? resource,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    resource ??= '';
    final response = await _dio.get<dynamic>(
      resource == '' ? _path : '$_path/$resource',
      queryParameters: queryParameters,
    );
    return response;
  }
}
```

### Avantajlar
- ✅ **Token management**: Otomatik token yönetimi
- ✅ **Error handling**: Merkezi hata yönetimi
- ✅ **Logging**: Debug modunda detaylı loglar
- ✅ **Timeout handling**: Bağlantı timeout'ları
- ✅ **Interceptor support**: Özelleştirilebilir interceptor'lar

---

## 🔐 Authentication Management

### Kullanım Amacı
Kullanıcı authentication durumunu yönetmek ve otomatik yönlendirme sağlamak.

### Implementasyon

```dart
// lib/core/router/authentication_listener.dart
mixin AuthenticationRouterListener {
  static AuthenticationStatus _currentAuthenticationStatus = AuthenticationStatus.initial;
  static late StreamSubscription<AuthenticationStatus> _subscription;
  static final StreamController<AuthenticationStatus> _authenticationStatusController =
      StreamController<AuthenticationStatus>.broadcast();
  static DioClient dioClient = DioClient();

  static void listen() {
    _subscription = dioClient.authenticationStatus.listen(onAuthenticationChanged);
  }

  static void onAuthenticationChanged(AuthenticationStatus authenticationStatus) {
    _currentAuthenticationStatus = authenticationStatus;
    if (authenticationStatus == AuthenticationStatus.authenticated) {
      if (!goRouter.state.fullPath!.contains(AppRoute.home.name)) {
        goRouter.go(AppRoute.home.path);
      }
    } else if (authenticationStatus == AuthenticationStatus.unauthenticated) {
      goRouter.goNamed(AppRoute.login.name);
    }
    _authenticationStatusController.add(authenticationStatus);
  }
}

// lib/http/dio/token_storage/token_storage.dart
class TokenStorageImpl implements TokenStorage<OAuth2Token> {
  factory TokenStorageImpl() => _instance;
  TokenStorageImpl._();
  static final TokenStorageImpl _instance = TokenStorageImpl._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> delete() {
    return _secureStorage.delete(key: StorageKey.accessToken.rawValue);
  }

  @override
  Future<OAuth2Token?> read() async {
    final result = await _secureStorage.read(key: StorageKey.accessToken.rawValue);
    return result != null ? OAuth2Token(accessToken: result) : null;
  }

  @override
  Future<void> write(OAuth2Token token) {
    return _secureStorage.write(
      key: StorageKey.accessToken.rawValue,
      value: token.accessToken,
    );
  }
}
```

### Avantajlar
- ✅ **Secure storage**: Token'lar güvenli şekilde saklanır
- ✅ **Auto-redirect**: Otomatik yönlendirme
- ✅ **Token refresh**: Otomatik token yenileme
- ✅ **State management**: Authentication state yönetimi

---

## 🎨 Asset Management

### Kullanım Amacı
Asset'leri otomatik olarak yönetmek ve farklı çözünürlükler için optimize etmek.

### Implementasyon

```dart
// asset_resizer.dart
import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  const scales = [1.5, 2.0, 3.0, 4.0];
  final imagesDir = Directory('assets/images');
  
  for (final file in imagesDir.listSync()) {
    if (file is File && file.path.endsWith('.png')) {
      final image = img.decodeImage(await file.readAsBytes());
      if (image != null) {
        for (final scale in scales) {
          final scaledImage = img.copyResize(
            image,
            width: (image.width * scale).round(),
            height: (image.height * scale).round(),
          );
          
          final scaleDir = Directory('assets/images/${scale}x');
          if (!scaleDir.existsSync()) {
            scaleDir.createSync(recursive: true);
          }
          
          final outputFile = File('${scaleDir.path}/${file.path.split('/').last}');
          await outputFile.writeAsBytes(img.encodePng(scaledImage));
        }
      }
    }
  }
}
```

### Avantajlar
- ✅ **Automated scaling**: Otomatik çözünürlük ayarlama
- ✅ **Multi-resolution**: Farklı ekran boyutları için optimize
- ✅ **Build automation**: Build sürecinde otomatik işlem
- ✅ **Performance**: Optimize edilmiş asset boyutları

---

## 🌍 Environment Management

### Kullanım Amacı
Farklı ortamlar (development, staging, production) için konfigürasyon yönetimi.

### Implementasyon

```dart
// lib/core/environment_manager/environment_manager.dart
class EnvironmentManager {
  factory EnvironmentManager() {
    _instance ??= EnvironmentManager._();
    return _instance!;
  }

  EnvironmentManager._();
  static EnvironmentManager? _instance;

  late List<EnvVariables> _envVariables;
  final DotEnv _dotEnv = DotEnv();

  Future<void> init() async {
    await _dotEnv.load();
    loadConfig();
  }

  String getValue(EnvVariables envVariable) {
    return _dotEnv.env[envVariable.name]!;
  }
}

// lib/core/environment_manager/env_variables.dart
enum EnvVariables {
  BASE_URL,
}

// .env dosyası
BASE_URL=https://api.example.com
```

### Avantajlar
- ✅ **Environment separation**: Ortamlar arası ayrım
- ✅ **Secure configuration**: Hassas bilgiler güvenli
- ✅ **Easy deployment**: Kolay deployment süreci
- ✅ **Type-safe**: Enum kullanımı ile type safety

---

## 🌐 Localization

### Kullanım Amacı
Çoklu dil desteği sağlamak ve kullanıcı deneyimini iyileştirmek.

### Implementasyon

```dart
// lib/core/l10n/app_en.arb
{
  "app_name": "Shartflix",
  "login_view_title": "Hello!",
  "login_view_subtitle": "Log in or sign up",
  "login_view_email_hint": "Email address",
  "login_view_password_hint": "Password",
  "login_view_login_button": "Log in"
}

// lib/core/l10n/app_tr.arb
{
  "app_name": "Shartflix",
  "login_view_title": "Merhaba!",
  "login_view_subtitle": "Giriş yap veya kayıt ol",
  "login_view_email_hint": "E-posta adresi",
  "login_view_password_hint": "Şifre",
  "login_view_login_button": "Giriş yap"
}

// lib/core/extensions/context_ext.dart
extension ContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Kullanım
Text(context.l10n.login_view_title)
```

### Avantajlar
- ✅ **Multi-language**: Çoklu dil desteği
- ✅ **Type-safe**: Compile-time kontrol
- ✅ **Easy maintenance**: Kolay bakım
- ✅ **Context-aware**: Context'e göre dil seçimi

---

## 🧪 Testing

### Kullanım Amacı
Kod kalitesini artırmak ve regression'ları önlemek için kapsamlı test yazımı.

### Implementasyon

```dart
// test/core/widget/text_field/app_text_field_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shartflix/core/widget/text_field/app_text_field.dart';

void main() {
  testWidgets('AppTextField shows hint and prefix icon', (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'E-mail',
            prefixIcon: const Icon(Icons.email),
          ),
        ),
      ),
    );
    
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);
    
    await tester.enterText(find.byType(TextField), 'test@example.com');
    expect(controller.text, 'test@example.com');
  });
}
```

### Avantajlar
- ✅ **Quality assurance**: Kod kalitesi garantisi
- ✅ **Regression prevention**: Geriye dönüş hatalarını önleme
- ✅ **Documentation**: Testler dokümantasyon görevi görür
- ✅ **Confidence**: Değişiklik yaparken güven

---

## 📊 Performance Optimizations

### 1. Image Caching
```dart
// CachedNetworkImage kullanımı
CachedNetworkImage(
  imageUrl: movie.posterUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

### 2. Lazy Loading
```dart
// GridView.builder ile lazy loading
GridView.builder(
  itemCount: movies.length,
  itemBuilder: (context, index) => MovieCard(movie: movies[index]),
)
```

### 3. Memory Management
```dart
// Dispose pattern
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  _emailFocus.dispose();
  _passwordFocus.dispose();
  super.dispose();
}
```

---

## 🏗️ Architecture Patterns

### 1. Repository Pattern
```dart
abstract class IRepository {}

class UserRepository extends IRepository {
  final _userApi = UserApi();
  
  Future<ResponseEntity<dynamic>> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    return _userApi.login(
      email: email,
      password: password,
      cancelToken: cancelToken,
    );
  }
}
```

### 2. Factory Pattern
```dart
class DioClient extends IDioClient {
  factory DioClient({Interceptor? interceptor}) {
    _instance ??= DioClient._internal(interceptor: interceptor);
    return _instance!;
  }
  
  DioClient._internal({this.interceptor})
    : super(url: EnvironmentManager().getValue(EnvVariables.BASE_URL));
}
```

### 3. Singleton Pattern
```dart
class Shared {
  factory Shared() => _instance;
  Shared._privateConstructor();
  static final Shared _instance = Shared._privateConstructor();
}
```

---

## 🎯 Best Practices Summary

### ✅ Do's
- **Dependency Injection** kullanın (GetIt)
- **BLoC pattern** ile state management yapın
- **Formz** ile form validation yapın
- **Isolate** kullanarak ağır işlemleri background'da çalıştırın
- **CustomScrollView** ile scroll optimizasyonu yapın
- **Theme management** ile tutarlı tasarım sağlayın
- **Repository pattern** ile data layer'ı ayırın
- **Comprehensive testing** yazın
- **Localization** desteği ekleyin
- **Environment management** ile ortam ayırımı yapın

### ❌ Don'ts
- UI thread'de ağır işlemler yapmayın
- Global değişkenler kullanmayın
- Hard-coded string'ler kullanmayın
- Nested scroll view'lar kullanmayın
- Memory leak'lere neden olmayın
- Error handling'i unutmayın
- Performance optimizasyonlarını göz ardı etmeyin

---

## 📚 Kaynaklar

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)
- [GetIt Documentation](https://pub.dev/packages/get_it)
- [Formz Documentation](https://pub.dev/packages/formz)
- [Go Router Documentation](https://pub.dev/packages/go_router)
- [Fresh Dio Documentation](https://pub.dev/packages/fresh_dio)

---

Bu study case, modern Flutter uygulaması geliştirirken kullanılması gereken en iyi teknikleri ve pattern'leri göstermektedir. Bu teknikler, ölçeklenebilir, maintainable ve performanslı uygulamalar geliştirmek için kritik öneme sahiptir. 