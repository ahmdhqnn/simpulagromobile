import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationSection(context, ref, settings),
          const SizedBox(height: 16),
          _buildDataSection(context, ref, settings),
          const SizedBox(height: 16),
          _buildDisplaySection(context, ref, settings),
          const SizedBox(height: 16),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> settings,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifikasi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Aktifkan Notifikasi'),
              subtitle: const Text('Terima notifikasi untuk alert dan update'),
              value: settings['notifications'] ?? true,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('notifications', value);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> settings,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data & Sinkronisasi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Auto Refresh'),
              subtitle: const Text('Perbarui data secara otomatis'),
              value: settings['autoRefresh'] ?? true,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('autoRefresh', value);
              },
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              title: const Text('Interval Refresh'),
              subtitle: Text('${settings['refreshInterval'] ?? 30} detik'),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () => _showRefreshIntervalDialog(context, ref, settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplaySection(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> settings,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tampilan',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Bahasa'),
              subtitle: Text(
                settings['language'] == 'id' ? 'Indonesia' : 'English',
              ),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () => _showLanguageDialog(context, ref, settings),
            ),
            const Divider(),
            ListTile(
              title: const Text('Tema'),
              subtitle: Text(settings['theme'] == 'light' ? 'Terang' : 'Gelap'),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () => _showThemeDialog(context, ref, settings),
            ),
            const Divider(),
            ListTile(
              title: const Text('Satuan Suhu'),
              subtitle: Text(
                settings['temperatureUnit'] == 'celsius'
                    ? 'Celsius (°C)'
                    : 'Fahrenheit (°F)',
              ),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () => _showTemperatureUnitDialog(context, ref, settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Versi Aplikasi'),
              subtitle: const Text('1.0.0'),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              title: const Text('Bantuan & Dukungan'),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                // TODO: Navigate to help screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Kebijakan Privasi'),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRefreshIntervalDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Interval Refresh'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('15 detik'),
              value: 15,
              groupValue: settings['refreshInterval'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('refreshInterval', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('30 detik'),
              value: 30,
              groupValue: settings['refreshInterval'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('refreshInterval', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('60 detik'),
              value: 60,
              groupValue: settings['refreshInterval'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('refreshInterval', value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Indonesia'),
              value: 'id',
              groupValue: settings['language'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('language', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: settings['language'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('language', value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Terang'),
              value: 'light',
              groupValue: settings['theme'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('theme', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Gelap'),
              value: 'dark',
              groupValue: settings['theme'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('theme', value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTemperatureUnitDialog(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Satuan Suhu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Celsius (°C)'),
              value: 'celsius',
              groupValue: settings['temperatureUnit'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('temperatureUnit', value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Fahrenheit (°F)'),
              value: 'fahrenheit',
              groupValue: settings['temperatureUnit'],
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .updateSetting('temperatureUnit', value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
