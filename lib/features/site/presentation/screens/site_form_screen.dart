import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../admin/presentation/widgets/admin_form_fields.dart';
import '../../../admin/presentation/widgets/admin_scaffold.dart';
import '../../domain/entities/site.dart';
import '../providers/site_provider.dart';

class SiteFormScreen extends ConsumerStatefulWidget {
  final String? siteId;

  const SiteFormScreen({super.key, this.siteId});

  @override
  ConsumerState<SiteFormScreen> createState() => _SiteFormScreenState();
}

class _SiteFormScreenState extends ConsumerState<SiteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  final _altController = TextEditingController();
  bool _isActive = true;
  bool _isLoadingData = false;

  bool get isEdit => widget.siteId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) _loadSiteData();
  }

  Future<void> _loadSiteData() async {
    setState(() => _isLoadingData = true);
    try {
      final site = await ref.read(siteDetailProvider(widget.siteId!).future);
      if (mounted) {
        _idController.text = site.siteId;
        _nameController.text = site.siteName ?? '';
        _addressController.text = site.siteAddress ?? '';
        _latController.text = site.siteLat?.toString() ?? '';
        _lonController.text = site.siteLon?.toString() ?? '';
        _altController.text = site.siteAlt?.toString() ?? '';
        _isActive = site.siteSts == 1;
        setState(() => _isLoadingData = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.siteLoadDataFailed(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lonController.dispose();
    _altController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(siteFormProvider);
    final submitLabel = isEdit
        ? context.l10n.commonSaveChanges
        : context.l10n.siteAddTitle;
    final title = isEdit
        ? context.l10n.siteEditTitle
        : context.l10n.siteAddTitle;

    return AdminFormScaffold(
      title: title,
      isLoading: formState.isLoading,
      loadingMessage: submitLabel,
      body: _isLoadingData
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.rw(0.051),
                vertical: context.rh(0.01),
              ),
              children: const [
                FormCardSkeleton(fieldCount: 6, hasLargeField: true),
              ],
            )
          : Form(
              key: _formKey,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: context.rw(0.051),
                  vertical: context.rh(0.01),
                ),
                children: [
                  if (formState.error != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              formState.error!,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: AppColors.error,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  _buildCard(
                    context,
                    children: [
                      if (!isEdit) ...[
                        _buildField(
                          label: '${context.l10n.siteIdLabel} *',
                          controller: _idController,
                          hint: context.l10n.siteIdHint,
                          icon: Icons.tag,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return context.l10n.siteIdRequired;
                            }
                            return null;
                          },
                        ),
                        const Gap(16),
                      ],
                      _buildField(
                        label: '${context.l10n.siteNameLabel} *',
                        controller: _nameController,
                        hint: context.l10n.siteNameHint,
                        icon: Icons.location_on,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return context.l10n.siteNameRequired;
                          }
                          if (v.trim().length < 3) {
                            return context.l10n.siteNameMinLength;
                          }
                          return null;
                        },
                      ),
                      const Gap(16),
                      _buildField(
                        label: isEdit
                            ? context.l10n.commonAddress
                            : '${context.l10n.commonAddress} *',
                        controller: _addressController,
                        hint: context.l10n.siteAddressHint,
                        icon: Icons.location_city,
                        maxLines: 2,
                        validator: (v) {
                          if (!isEdit && (v == null || v.trim().isEmpty)) {
                            return context.l10n.commonRequired;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const Gap(16),

                  _buildCard(
                    context,
                    children: [
                      Text(
                        context.l10n.siteGpsCoordinates,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                      const Gap(12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              label: isEdit
                                  ? context.l10n.commonLatitude
                                  : '${context.l10n.commonLatitude} *',
                              controller: _latController,
                              hint: '-6.200000',
                              icon: Icons.explore,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              validator: (v) {
                                if (!isEdit &&
                                    (v == null || v.trim().isEmpty)) {
                                  return context.l10n.commonRequired;
                                }
                                if (v != null && v.trim().isNotEmpty) {
                                  final lat = double.tryParse(v.trim());
                                  if (lat == null || lat < -90 || lat > 90) {
                                    return context.l10n.commonInvalid;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _buildField(
                              label: isEdit
                                  ? context.l10n.commonLongitude
                                  : '${context.l10n.commonLongitude} *',
                              controller: _lonController,
                              hint: '106.816666',
                              icon: Icons.explore,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              validator: (v) {
                                if (!isEdit &&
                                    (v == null || v.trim().isEmpty)) {
                                  return context.l10n.commonRequired;
                                }
                                if (v != null && v.trim().isNotEmpty) {
                                  final lon = double.tryParse(v.trim());
                                  if (lon == null || lon < -180 || lon > 180) {
                                    return context.l10n.commonInvalid;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      _buildField(
                        label: isEdit
                            ? context.l10n.siteAltitudeLabel
                            : '${context.l10n.siteAltitudeLabel} *',
                        controller: _altController,
                        hint: context.l10n.siteAltitudeHint,
                        icon: Icons.terrain,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        suffix: 'm',
                        validator: (v) {
                          if (!isEdit && (v == null || v.trim().isEmpty)) {
                            return context.l10n.commonRequired;
                          }
                          if (v != null &&
                              v.trim().isNotEmpty &&
                              double.tryParse(v.trim()) == null) {
                            return context.l10n.commonInvalid;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const Gap(16),

                  AdminSectionCard(
                    child: AdminFormFields.buildStatusToggle(
                      context,
                      label: context.l10n.siteStatusLabel,
                      value: _isActive,
                      onChanged: (value) => setState(() => _isActive = value),
                    ),
                  ),

                  SizedBox(height: context.rh(0.03)),
                  AdminSubmitButton(
                    label: submitLabel,
                    isLoading: formState.isLoading,
                    onPressed: _handleSave,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return AdminSectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return AdminFormFields.buildField(
      context,
      controller: controller,
      label: label,
      hint: hint ?? '',
      icon: icon ?? Icons.text_fields,
      maxLines: maxLines,
      keyboardType: keyboardType,
      suffixText: suffix,
      validator: validator,
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(siteFormProvider.notifier).reset();

    final site = Site(
      siteId: isEdit ? widget.siteId! : _idController.text.trim(),
      siteName: _nameController.text.trim(),
      siteAddress: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      siteLat: double.tryParse(_latController.text),
      siteLon: double.tryParse(_lonController.text),
      siteAlt: double.tryParse(_altController.text),
      siteSts: _isActive ? 1 : 0,
    );

    final notifier = ref.read(siteFormProvider.notifier);
    final success = isEdit
        ? await notifier.updateSite(widget.siteId!, site)
        : await notifier.createSite(site);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? context.l10n.siteUpdateSuccess
                : context.l10n.siteCreateSuccess,
            style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
    // Error ditampilkan via formState.error di UI
  }
}
