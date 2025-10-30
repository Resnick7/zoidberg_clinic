# zoidberg

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




Para clonar sin importar el SO:

# Clona el repo
git clone <url-repo>
cd proyecto


# Instala dependencias
flutter pub get
flutter config --enable-linux-desktop

# Después de clonar el repo
dart pub global activate flutterfire_cli
# Seleccionar plataformas necesarias
flutterfire configure

# CMakeList.txt se ignora
# (Contiene rutas absolutas específicas del sistema &#40;ej: /home/user/flutter/...&#41;)
# (Las configuraciones de compilación varían entre SO y entornos)
# (Flutter puede regenerarlo automáticamente)

# Después de clonar el repo
flutter create --platforms=linux .