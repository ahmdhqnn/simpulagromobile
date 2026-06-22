import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card_widget.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/icon_badge_widget.dart';
import '../../../../shared/widgets/section_header_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
          children: [
            SizedBox(height: context.rh(0.022)),
            _buildHeader(context),
            SizedBox(height: context.rh(0.026)),
            _SettingsSection(
              title: l10n.settingsNotificationsSection,
              children: [
                _SettingsSwitchItem(
                  iconPath: 'assets/icons/warning-outline-icon.svg',
                  iconBackground: const Color(0x1AEF5350),
                  iconTint: AppColors.error,
                  title: l10n.settingsEnableNotifications,
                  subtitle: l10n.settingsNotificationsSubtitle,
                  value: settings['notifications'] ?? true,
                  onChanged: (value) => ref
                      .read(settingsProvider.notifier)
                      .updateSetting('notifications', value),
                ),
              ],
            ),
            SizedBox(height: context.rh(0.024)),
            _SettingsSection(
              title: l10n.settingsDataSyncSection,
              children: [
                _SettingsSwitchItem(
                  iconPath: 'assets/icons/arrow-rotate-left.svg',
                  iconBackground: const Color(0x1A42A5F5),
                  iconTint: AppColors.info,
                  title: l10n.settingsAutoRefresh,
                  subtitle: l10n.settingsAutoRefreshSubtitle,
                  value: settings['autoRefresh'] ?? true,
                  onChanged: (value) => ref
                      .read(settingsProvider.notifier)
                      .updateSetting('autoRefresh', value),
                ),
                const _SettingsDivider(),
                _SettingsNavigationItem(
                  iconPath: 'assets/icons/date-outline-icon.svg',
                  iconBackground: const Color(0x1A66BB6A),
                  iconTint: AppColors.primary,
                  title: l10n.settingsRefreshInterval,
                  subtitle: l10n.settingsRefreshIntervalSeconds(
                    settings['refreshInterval'] as int? ?? 30,
                  ),
                  onTap: () => _showRefreshIntervalDialog(
                    context,
                    ref,
                    settings['refreshInterval'] as int? ?? 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rh(0.024)),
            _SettingsSection(
              title: l10n.settingsAppearanceSection,
              children: [
                _SettingsNavigationItem(
                  iconPath: 'assets/icons/message-outline-icon.svg',
                  iconBackground: const Color(0x1A42A5F5),
                  iconTint: AppColors.info,
                  title: l10n.settingsLanguage,
                  subtitle: settings['language'] == 'en'
                      ? l10n.settingsLanguageEnglish
                      : l10n.settingsLanguageIndonesian,
                  onTap: () => _showLanguageDialog(
                    context,
                    ref,
                    settings['language'] as String? ?? 'id',
                  ),
                ),
                const _SettingsDivider(),
                _SettingsNavigationItem(
                  iconPath: 'assets/icons/setting-outline-icon.svg',
                  iconBackground: const Color(0x1A1B5E20),
                  iconTint: AppColors.primary,
                  title: l10n.settingsTheme,
                  subtitle: l10n.settingsThemeUnavailableSubtitle,
                  onTap: () => _showThemeUnavailableDialog(context),
                ),
                const _SettingsDivider(),
                _SettingsNavigationItem(
                  iconPath: 'assets/icons/indicator-outline-icon.svg',
                  iconBackground: const Color(0x1AFFA726),
                  iconTint: AppColors.warning,
                  title: l10n.settingsTemperatureUnit,
                  subtitle: settings['temperatureUnit'] == 'fahrenheit'
                      ? l10n.settingsTemperatureFahrenheit
                      : l10n.settingsTemperatureCelsius,
                  onTap: () => _showTemperatureUnitDialog(
                    context,
                    ref,
                    settings['temperatureUnit'] as String? ?? 'celsius',
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rh(0.024)),
            _SettingsSection(
              title: l10n.settingsAccountSection,
              children: [
                _SettingsNavigationItem(
                  iconPath: 'assets/icons/user-outline-icon.svg',
                  iconBackground: const Color(0x1A1B5E20),
                  iconTint: AppColors.primary,
                  title: l10n.settingsChangePassword,
                  subtitle: l10n.settingsChangePasswordSubtitle,
                  onTap: () => context.push('/settings/change-password'),
                ),
              ],
            ),
            SizedBox(height: context.rh(0.024)),
            _SettingsSection(
              title: l10n.settingsAboutSection,
              children: [
                _SettingsStaticItem(
                  iconPath: 'assets/images/simpulagro_logo.svg',
                  iconBackground: const Color(0x1A1B5E20),
                  iconTint: AppColors.primary,
                  title: l10n.settingsAppVersion,
                  subtitle: '1.0.0',
                ),
                const _SettingsDivider(),
                _SettingsNavigationItem(
                  iconPath: 'assets/icons/phone-outline-icon.svg',
                  iconBackground: const Color(0x1A42A5F5),
                  iconTint: AppColors.info,
                  title: l10n.settingsHelpSupport,
                  subtitle: l10n.settingsHelpSupportSubtitle,
                  onTap: () => _showInfoDialog(
                    context,
                    l10n.settingsHelpSupport,
                    l10n.settingsHelpSupportMessage,
                  ),
                ),
                const _SettingsDivider(),
                _SettingsNavigationItem(
                  iconPath: 'assets/icons/check-icon.svg',
                  iconBackground: const Color(0x1A66BB6A),
                  iconTint: AppColors.success,
                  title: l10n.settingsPrivacyPolicy,
                  subtitle: l10n.settingsPrivacyPolicySubtitle,
                  onTap: () => _showInfoDialog(
                    context,
                    l10n.settingsPrivacyPolicy,
                    l10n.settingsPrivacyPolicyMessage,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rh(0.04)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CircularBackButtonWidget(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/profile');
          }
        },
      ),
    );
  }

  void _showRefreshIntervalDialog(
    BuildContext context,
    WidgetRef ref,
    int currentValue,
  ) {
    _showOptionDialog<int>(
      context: context,
      title: context.l10n.settingsRefreshInterval,
      currentValue: currentValue,
      options: [
        _OptionItem(
          value: 30,
          label: context.l10n.settingsRefreshIntervalSeconds(30),
        ),
        _OptionItem(
          value: 60,
          label: context.l10n.settingsRefreshIntervalSeconds(60),
        ),
        _OptionItem(
          value: 120,
          label: context.l10n.settingsRefreshIntervalSeconds(120),
        ),
        _OptionItem(
          value: 300,
          label: context.l10n.settingsRefreshIntervalSeconds(300),
        ),
      ],
      onSelected: (value) => ref
          .read(settingsProvider.notifier)
          .updateSetting('refreshInterval', value),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    String currentValue,
  ) {
    _showOptionDialog<String>(
      context: context,
      title: context.l10n.settingsSelectLanguage,
      currentValue: currentValue,
      options: [
        _OptionItem(
          value: 'id',
          label: context.l10n.settingsLanguageIndonesian,
        ),
        _OptionItem(value: 'en', label: context.l10n.settingsLanguageEnglish),
      ],
      onSelected: (value) =>
          ref.read(settingsProvider.notifier).updateSetting('language', value),
    );
  }

  void _showThemeUnavailableDialog(BuildContext context) {
    _showInfoDialog(
      context,
      context.l10n.settingsTheme,
      context.l10n.settingsThemeUnavailableMessage,
    );
  }

  void _showTemperatureUnitDialog(
    BuildContext context,
    WidgetRef ref,
    String currentValue,
  ) {
    _showOptionDialog<String>(
      context: context,
      title: context.l10n.settingsTemperatureUnit,
      currentValue: currentValue,
      options: [
        _OptionItem(
          value: 'celsius',
          label: context.l10n.settingsTemperatureCelsius,
        ),
        _OptionItem(
          value: 'fahrenheit',
          label: context.l10n.settingsTemperatureFahrenheit,
        ),
      ],
      onSelected: (value) => ref
          .read(settingsProvider.notifier)
          .updateSetting('temperatureUnit', value),
    );
  }

  void _showOptionDialog<T>({
    required BuildContext context,
    required String title,
    required T currentValue,
    required List<_OptionItem<T>> options,
    required ValueChanged<T> onSelected,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        backgroundColor: AppColors.surface,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w300,
            fontSize: 22,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options)
              RadioListTile<T>(
                value: option.value,
                groupValue: currentValue,
                activeColor: AppColors.primary,
                title: Text(
                  option.label,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                onChanged: (value) {
                  if (value == null) return;
                  onSelected(value);
                  Navigator.pop(dialogContext);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        backgroundColor: AppColors.surface,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w300,
            fontSize: 22,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: Text(
              context.l10n.commonOk,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(title: title),
        SizedBox(height: context.rh(0.014)),
        AppCardWidget(
          width: double.infinity,
          radius: AppRadius.lg,
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsSwitchItem extends StatelessWidget {
  final String iconPath;
  final Color iconBackground;
  final Color iconTint;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchItem({
    required this.iconPath,
    required this.iconBackground,
    required this.iconTint,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconBadgeWidget.svg(
            svgIconPath: iconPath,
            background: iconBackground,
            tint: iconTint,
            radius: 10,
          ),
          SizedBox(width: context.rw(0.02)),
          Expanded(
            child: _SettingsTextBlock(title: title, subtitle: subtitle),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsNavigationItem extends StatelessWidget {
  final String iconPath;
  final Color iconBackground;
  final Color iconTint;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsNavigationItem({
    required this.iconPath,
    required this.iconBackground,
    required this.iconTint,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconBadgeWidget.svg(
              svgIconPath: iconPath,
              background: iconBackground,
              tint: iconTint,
              radius: 10,
            ),
            SizedBox(width: context.rw(0.02)),
            Expanded(
              child: _SettingsTextBlock(title: title, subtitle: subtitle),
            ),
            SvgPicture.asset(
              'assets/icons/chevron-right-icon.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsStaticItem extends StatelessWidget {
  final String iconPath;
  final Color iconBackground;
  final Color iconTint;
  final String title;
  final String subtitle;

  const _SettingsStaticItem({
    required this.iconPath,
    required this.iconBackground,
    required this.iconTint,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconBadgeWidget.svg(
            svgIconPath: iconPath,
            background: iconBackground,
            tint: iconTint,
            radius: 10,
          ),
          SizedBox(width: context.rw(0.02)),
          Expanded(
            child: _SettingsTextBlock(title: title, subtitle: subtitle),
          ),
        ],
      ),
    );
  }
}

class _SettingsTextBlock extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SettingsTextBlock({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: context.sp(16),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 3),
        Text(subtitle, style: AppTextStyles.hint(context)),
      ],
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 76),
      child: Divider(height: 1, color: AppColors.divider),
    );
  }
}

class _OptionItem<T> {
  final T value;
  final String label;

  const _OptionItem({required this.value, required this.label});
}
