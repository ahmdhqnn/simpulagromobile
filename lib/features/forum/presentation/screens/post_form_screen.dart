import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/circular_back_button_widget.dart';
import '../../../../shared/widgets/skeleton_loaders.dart';
import '../../../site/presentation/providers/site_provider.dart';
import '../providers/forum_provider.dart';

class PostFormScreen extends ConsumerStatefulWidget {
  final String? postId;

  const PostFormScreen({super.key, this.postId});

  @override
  ConsumerState<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends ConsumerState<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isSubmitting = false;
  bool _isLoadingData = false;
  String? _loadErrorMessage;

  XFile? _selectedImage;
  String? _existingImageUrl;
  String? _siteLabel;
  bool _removeExistingImage = false;

  bool get _isEditMode => widget.postId != null;
  String get _screenTitle =>
      _isEditMode ? 'Edit Postingan' : 'Tambah Postingan';

  String? get _imageToSubmit {
    if (_selectedImage != null) return _selectedImage!.path;
    if (!_removeExistingImage && _existingImageUrl != null) {
      return _existingImageUrl;
    }
    return null;
  }

  bool get _hasVisibleImage {
    if (_selectedImage != null) return true;
    return _existingImageUrl != null && !_removeExistingImage;
  }

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadPostData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadPostData() async {
    setState(() {
      _isLoadingData = true;
      _loadErrorMessage = null;
    });

    try {
      final repository = ref.read(forumRepositoryProvider);
      final result = await repository.getPostById(widget.postId!);

      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() {
            _isLoadingData = false;
            _loadErrorMessage = 'Gagal memuat data: ${failure.message}';
          });
        },
        (post) {
          final siteName = post.site?.siteName.trim();
          _titleController.text = post.postTitle;
          _contentController.text = post.postContent;
          _existingImageUrl = post.postImage?.isNotEmpty == true
              ? post.postImage
              : null;
          _siteLabel = siteName != null && siteName.isNotEmpty
              ? siteName
              : post.siteId;
          setState(() {
            _isLoadingData = false;
            _loadErrorMessage = null;
          });
        },
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingData = false;
        _loadErrorMessage =
            'Terjadi kesalahan: ${error.toString().replaceAll('Exception: ', '')}';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;

      setState(() {
        _selectedImage = picked;
        _removeExistingImage = false;
      });
    } catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(
        'Gagal memilih gambar: ${error.toString().replaceAll('Exception: ', '')}',
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih Gambar',
                  style: AppTextStyles.cardTitle(sheetContext, 16),
                ),
                const SizedBox(height: 12),
                _buildSheetAction(
                  context: sheetContext,
                  icon: Icons.photo_library_outlined,
                  iconColor: AppColors.primary,
                  backgroundColor: AppColors.softGreen,
                  label: 'Pilih dari Galeri',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 8),
                _buildSheetAction(
                  context: sheetContext,
                  icon: Icons.camera_alt_outlined,
                  iconColor: AppColors.primary,
                  backgroundColor: AppColors.softGreen,
                  label: 'Ambil Foto',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_hasVisibleImage) ...[
                  const SizedBox(height: 8),
                  _buildSheetAction(
                    context: sheetContext,
                    icon: Icons.delete_outline,
                    iconColor: AppColors.error,
                    backgroundColor: AppColors.softOrange,
                    label: 'Hapus Gambar',
                    labelColor: AppColors.error,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      setState(() {
                        _selectedImage = null;
                        _removeExistingImage = true;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetAction({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    required VoidCallback onTap,
    Color? labelColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.label(
                    context,
                    size: context.sp(14),
                    weight: FontWeight.w500,
                    color: labelColor ?? AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedSite = ref.read(selectedSiteProvider);
    if (!_isEditMode && selectedSite == null) {
      _showErrorSnackBar('Pilih site terlebih dahulu di halaman utama');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(forumRepositoryProvider);

      if (_isEditMode) {
        await repository.updatePost(
          postId: widget.postId!,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          imageUrl: _imageToSubmit,
        );
      } else {
        await repository.createPost(
          title: _titleController.text.trim(),
          siteId: selectedSite!.siteId,
          content: _contentController.text.trim(),
          imageUrl: _imageToSubmit,
        );
      }

      await ref.read(forumProvider.notifier).refreshPosts();
      ref.invalidate(myPostsProvider);
      ref.invalidate(likedPostsProvider);
      if (_isEditMode) {
        ref.invalidate(postDetailProvider(widget.postId!));
      }

      if (!mounted) return;

      _showSuccessSnackBar(
        _isEditMode
            ? 'Postingan berhasil diupdate'
            : 'Postingan berhasil dibuat',
      );
      context.pop(true);
    } catch (error) {
      if (!mounted) return;
      _showErrorSnackBar(error.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSite = ref.watch(selectedSiteProvider);

    if (!_isEditMode && selectedSite == null) {
      return _buildScreenShell(
        child: _buildMessageCard(
          icon: Icons.location_off_outlined,
          iconColor: AppColors.warning,
          title: 'Site belum dipilih',
          description:
              'Pilih site aktif di dashboard sebelum membuat postingan forum.',
          actionLabel: 'Kembali',
          onAction: () => context.pop(),
        ),
      );
    }

    final siteLabel = _isEditMode ? _siteLabel : selectedSite?.displayName;

    Widget child;
    if (_isLoadingData) {
      child = _buildLoadingCard();
    } else if (_loadErrorMessage != null) {
      child = _buildMessageCard(
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        title: 'Gagal memuat postingan',
        description: _loadErrorMessage!,
        actionLabel: 'Coba Lagi',
        onAction: _loadPostData,
      );
    } else {
      child = _buildFormCard(siteLabel);
    }

    return _buildScreenShell(child: child);
  }

  Widget _buildScreenShell({required Widget child}) {
    final hPad = context.rw(0.051);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.rh(0.015)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircularBackButtonWidget(
                    onPressed: () => context.pop(),
                  ),
                ),
                SizedBox(height: context.rh(0.03)),
                Text(_screenTitle, style: AppTextStyles.sectionTitle(context)),
                SizedBox(height: context.rh(0.03)),
                child,
                SizedBox(
                  height:
                      context.rh(0.02) + MediaQuery.paddingOf(context).bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() =>
      const FormCardSkeleton(fieldCount: 3, hasLargeField: true);

  Widget _buildMessageCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: context.rw(0.143).clamp(52.0, 60.0),
            color: iconColor,
          ),
          SizedBox(height: context.rh(0.02)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.cardTitle(context, context.sp(16)),
          ),
          SizedBox(height: context.rh(0.01)),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption(context, size: context.sp(13)),
          ),
          SizedBox(height: context.rh(0.03)),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            child: Text(
              actionLabel,
              style: AppTextStyles.label(
                context,
                size: context.sp(14),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(String? siteLabel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rw(0.051)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (siteLabel != null && siteLabel.trim().isNotEmpty) ...[
              _FormField(label: 'Site', child: _buildReadOnlyField(siteLabel)),
              SizedBox(height: context.rh(0.025)),
            ],
            _FormField(
              label: 'Judul',
              child: _buildTextField(
                controller: _titleController,
                hintText: 'Masukkan judul postingan',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Judul minimal 3 karakter';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: context.rh(0.025)),
            _FormField(
              label: 'Isi Postingan',
              child: _buildTextField(
                controller: _contentController,
                hintText: 'Tulis informasi yang ingin Anda bagikan',
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Konten tidak boleh kosong';
                  }
                  if (value.trim().length < 10) {
                    return 'Konten minimal 10 karakter';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: context.rh(0.025)),
            _FormField(label: 'Media', child: _buildImageField()),
            SizedBox(height: context.rh(0.025)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.rw(0.036)),
              decoration: BoxDecoration(
                color: AppColors.softOrange,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  SizedBox(width: context.rw(0.026)),
                  Expanded(
                    child: Text(
                      'Pastikan isi postingan tetap jelas, relevan, dan sesuai pedoman komunitas.',
                      style: AppTextStyles.caption(
                        context,
                        size: context.sp(11),
                        color: const Color(0xFF856404),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rh(0.037)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleActionButton(
                  svgPath: 'assets/icons/close-icon.svg',
                  onTap: () => context.pop(),
                ),
                _CircleActionButton(
                  svgPath: 'assets/icons/check-icon.svg',
                  onTap: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputAction? textInputAction,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final isMultiline = maxLines > 1;
    final borderRadius = BorderRadius.circular(
      isMultiline ? AppRadius.xl : AppRadius.pill,
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      textInputAction: textInputAction,
      style: AppTextStyles.label(
        context,
        size: context.sp(14),
        weight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hint(context, size: context.sp(14)),
        filled: true,
        fillColor: AppColors.surfaceVariant,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rw(0.041),
          vertical: isMultiline ? context.rh(0.016) : context.rh(0.012),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      height: context.rh(0.05).clamp(44.0, 48.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.rw(0.041)),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.label(
          context,
          size: context.sp(14),
          weight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildImageField() {
    if (!_hasVisibleImage) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showImageSourceSheet,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.rw(0.041)),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                SizedBox(width: context.rw(0.031)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambahkan gambar',
                        style: AppTextStyles.label(
                          context,
                          size: context.sp(13),
                          weight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Opsional. Postingan tanpa gambar tetap dapat dipublikasikan.',
                        style: AppTextStyles.hint(
                          context,
                          size: context.sp(11),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.rw(0.02)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Pilih',
                        style: AppTextStyles.caption(
                          context,
                          size: context.sp(11),
                          color: AppColors.textPrimary,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _selectedImage != null
                ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                : Image.network(
                    _existingImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        size: 40,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(height: context.rh(0.012)),
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedImage != null
                    ? 'Gambar baru siap diunggah'
                    : 'Gambar postingan aktif',
                style: AppTextStyles.label(
                  context,
                  size: context.sp(12),
                  weight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            _InlineActionButton(
              icon: Icons.edit_outlined,
              label: 'Ganti',
              onTap: _showImageSourceSheet,
            ),
            const SizedBox(width: 8),
            _InlineActionButton(
              icon: Icons.close_rounded,
              label: 'Hapus',
              onTap: () {
                setState(() {
                  _selectedImage = null;
                  _removeExistingImage = true;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showErrorSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label(
            context,
            size: context.sp(14),
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(height: context.rh(0.01)),
        child,
      ],
    );
  }
}

class _InlineActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _InlineActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.textPrimary),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.caption(
                  context,
                  size: context.sp(11),
                  color: AppColors.textPrimary,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback? onTap;
  final bool isLoading;

  const _CircleActionButton({
    required this.svgPath,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.rw(0.128).clamp(48.0, 56.0);
    final iconSize = context.rw(0.062).clamp(22.0, 28.0);
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.surfaceVariant.withValues(alpha: 0.5)
              : AppColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textPrimary,
                  ),
                )
              : SvgPicture.asset(
                  svgPath,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(
                    isDisabled
                        ? AppColors.textPrimary.withValues(alpha: 0.3)
                        : AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
        ),
      ),
    );
  }
}
