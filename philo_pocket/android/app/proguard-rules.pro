# ==============================================================================
# EduPocket Gabon - Règles ProGuard / R8 d'optimisation & d'obfuscation
# ==============================================================================

# 1. Règles générales d'obfuscation
-repackageclasses ''
-allowaccessmodification

# 2. Préservation des points d'entrée Flutter indispensables
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 3. Préservation des classes d'activité et application
-keep public class com.edupocket.MainActivity extends io.flutter.embedding.android.FlutterActivity
-keep class * implements io.flutter.plugin.common.PluginRegistry$PluginRegistrantCallback { *; }

# 4. Plugins & Sécurité (Supabase, SharedPreferences, Syncfusion, WebView)
-dontwarn io.flutter.**
-dontwarn com.syncfusion.**
-keep class com.syncfusion.** { *; }

# 5. Protection contre l'inspection des numéros de ligne et variables locales (Anti-Decompilation)
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
