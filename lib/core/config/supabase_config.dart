/// Konfigurasi Supabase untuk E-Ticketing Helpdesk
///
/// Cara pakai:
/// 1. Untuk DEVELOPMENT: Edit langsung nilai di bawah
/// 2. Untuk PRODUCTION: Gunakan --dart-define saat run/build:
///    ```
///    flutter run \
///      --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///      --dart-define=SUPABASE_ANON_KEY=eyJhbGc...
///    ```
class SupabaseConfig {
  /// URL project Supabase Anda
  /// ⚠️ WAJIB DIGANTI: Ganti dengan URL dari Project Settings > API > Project URL
  /// Contoh: 'https://abcdefghij.supabase.co'
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vbcgcthyszdtmxizfvvp.supabase.co',  // ← GANTI dengan URL Anda
  );

  /// Anon public key dari Supabase
  /// ⚠️ WAJIB DIGANTI: Ganti dengan anon key dari Project Settings > API > anon public
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZiY2djdGh5c3pkdG14aXpmdnZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA1NDg4MzksImV4cCI6MjA5NjEyNDgzOX0.bnaS4-mnAxPaLl5HWHNv13O2fmdHM8R3y1GyBBjvpOc',  // ← GANTI dengan anon key Anda
  );

  /// Storage buckets
  static const String ticketAttachmentsBucket = 'ticket-attachments';
  static const String avatarsBucket = 'avatars';

  /// Helper: Cek apakah config sudah diisi
  static bool get isConfigured {
    return !url.contains('ganti-dengan') && !anonKey.contains('ganti-dengan');
  }
}
