import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../core/api/rover_api.dart';
import '../../core/config/api_config.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/language_provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../../shared/utils/snack.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/surface_panel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _backendCtrl;
  late final TextEditingController _camCtrl;
  late final TextEditingController _apiKeyCtrl;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    final cfg = context.read<ApiConfig>();
    _backendCtrl = TextEditingController(text: cfg.backendBaseUrl);
    _camCtrl = TextEditingController(text: cfg.esp32CamUrl);
    _apiKeyCtrl = TextEditingController(text: cfg.apiKey);
  }

  @override
  void dispose() {
    _backendCtrl.dispose();
    _camCtrl.dispose();
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context)!;
    await context.read<ApiConfig>().update(
          backendBaseUrl: _backendCtrl.text,
          esp32CamUrl: _camCtrl.text,
          apiKey: _apiKeyCtrl.text,
        );
    if (!mounted) return;
    showAppSnack(context, loc.save);
  }

  Future<void> _test() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _testing = true);
    final config = context.read<ApiConfig>();
    await config.update(
      backendBaseUrl: _backendCtrl.text,
      esp32CamUrl: _camCtrl.text,
      apiKey: _apiKeyCtrl.text,
    );
    final result = await RoverApi(config).health();
    if (!mounted) return;
    setState(() => _testing = false);
    showAppSnack(
      context,
      result.ok ? loc.connectionOk : (result.error ?? loc.connectionFailed),
      isError: !result.ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final c = context.colors;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isEnglish = languageProvider.locale.languageCode == 'en';

    return AppScaffold(
      title: loc.settings,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      body: ListView(
        children: [
          _SectionLabel(loc.connect),
          const SizedBox(height: 10),
          SurfacePanel(
            child: Text(
              loc.connectionInstructions,
              style: GoogleFonts.outfit(
                fontSize: 15,
                height: 1.45,
                color: c.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.backendUrl, style: _fieldLabel),
                const SizedBox(height: 8),
                TextField(
                  controller: _backendCtrl,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'http://192.168.100.12:8000',
                  ),
                ),
                const SizedBox(height: 16),
                Text(loc.esp32CamUrl, style: _fieldLabel),
                const SizedBox(height: 8),
                TextField(
                  controller: _camCtrl,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'http://192.168.100.50/stream',
                  ),
                ),
                const SizedBox(height: 16),
                Text(loc.apiKey, style: _fieldLabel),
                const SizedBox(height: 8),
                TextField(
                  controller: _apiKeyCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'rover-secret-key',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        child: Text(loc.save),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _testing ? null : _test,
                        child: Text(
                          _testing ? '...' : loc.testConnection,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _SectionLabel(loc.theme),
          const SizedBox(height: 10),
          SurfacePanel(
            padding: const EdgeInsets.all(8),
            child: Consumer<ThemeProvider>(
              builder: (context, theme, _) {
                return Row(
                  children: [
                    Expanded(
                      child: _LangChip(
                        label: loc.themeSystem,
                        selected: theme.followsSystem,
                        onTap: () => theme.setSystem(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LangChip(
                        label: loc.themeDark,
                        selected: theme.mode == ThemeMode.dark,
                        onTap: () => theme.setDark(true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LangChip(
                        label: loc.themeLight,
                        selected: theme.mode == ThemeMode.light,
                        onTap: () => theme.setDark(false),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          _SectionLabel(loc.language),
          const SizedBox(height: 10),
          SurfacePanel(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: _LangChip(
                    label: 'Français',
                    selected: !isEnglish,
                    onTap: () =>
                        languageProvider.setLocale(const Locale('fr')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LangChip(
                    label: 'English',
                    selected: isEnglish,
                    onTap: () =>
                        languageProvider.setLocale(const Locale('en')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _SectionLabel(loc.about),
          const SizedBox(height: 10),
          SurfacePanel(
            onTap: () => Navigator.pushNamed(context, AppRoutes.about),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: c.accent),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    loc.about,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: c.textMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _fieldLabel => GoogleFonts.outfit(
    color: context.colors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: c.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? c.accent.withValues(alpha: 0.55)
                  : Colors.transparent,
            ),
            color: selected
                ? c.accent.withValues(alpha: 0.18)
                : Colors.transparent,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                color:
                    selected ? c.accentBright : c.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
