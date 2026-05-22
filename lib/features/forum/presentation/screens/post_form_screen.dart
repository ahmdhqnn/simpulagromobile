import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/loading_widget.dart';
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
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingData = false;

  bool get _isEditMode => widget.postId != null;

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
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadPostData() async {
    setState(() => _isLoadingData = true);
    try {
      final repository = ref.read(forumRepositoryProvider);
      final result = await repository.getPostById(widget.postId!);
      result.fold(
        (failure) {
          if (mounted) {
            setState(() => _isLoadingData = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal memuat data: ${failure.message}',
                  style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        (post) {
          if (mounted) {
            _titleController.text = post.postTitle;
            _contentController.text = post.postContent;
            _imageUrlController.text = post.postImage ?? '';
            setState(() => _isLoadingData = false);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Terjadi kesalahan: ${e.toString().replaceAll('Exception: ', '')}',
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi site terlebih dahulu untuk mode create
    if (!_isEditMode) {
      final siteId = ref.read(selectedSiteIdProvider);
      if (siteId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pilih site terlebih dahulu di halaman utama sebelum membuat postingan',
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(forumRepositoryProvider);

      if (_isEditMode) {
        await repository.updatePost(
          postId: widget.postId!,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
        );
      } else {
        final siteId = ref.read(selectedSiteIdProvider)!;
        await repository.createPost(
          title: _titleController.text.trim(),
          siteId: siteId,
          content: _contentController.text.trim(),
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
        );
      }

      // Refresh forum list agar postingan baru muncul
      await ref.read(forumProvider.notifier).refreshPosts();
      ref.invalidate(myPostsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Postingan berhasil diupdate'
                  : 'Postingan berhasil dibuat',
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Postingan' : 'Buat Postingan',
          style: AppTextStyles.cardTitle(context, 16),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: _submit,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  _isEditMode ? 'Update' : 'Posting',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(13),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoadingData
          ? const LoadingWidget(message: 'Memuat data postingan...')
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(context.rw(0.051)),
                children: [
                  // Title field
                  _buildInputCard(
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Judul postingan',
                        hintStyle: AppTextStyles.hint(context, size: 14),
                        border: InputBorder.none,
                      ),
                      style: AppTextStyles.label(
                        context,
                        size: 14,
                        weight: FontWeight.w600,
                      ),
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

                  const SizedBox(height: 16),

                  // Content field
                  _buildInputCard(
                    child: TextFormField(
                      controller: _contentController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Apa yang ingin Anda bagikan?',
                        hintStyle: AppTextStyles.hint(context, size: 13),
                        border: InputBorder.none,
                      ),
                      style: AppTextStyles.label(
                        context,
                        size: 13,
                        weight: FontWeight.w400,
                        height: 1.6,
                      ),
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

                  const SizedBox(height: 16),

                  // Image URL field
                  _buildInputCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'URL Gambar (Opsional)',
                              style: AppTextStyles.label(
                                context,
                                size: 13,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: InputDecoration(
                            hintText: 'https://example.com/image.jpg',
                            hintStyle: AppTextStyles.hint(context, size: 12),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          style: AppTextStyles.label(
                            context,
                            size: 12,
                            weight: FontWeight.w400,
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final uri = Uri.tryParse(value.trim());
                              if (uri == null ||
                                  (!uri.scheme.startsWith('http'))) {
                                return 'URL gambar tidak valid';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softOrange,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.warning,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Pastikan konten Anda sesuai dengan pedoman komunitas',
                            style: AppTextStyles.caption(
                              context,
                              size: 11,
                              color: const Color(0xFF856404),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInputCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: child,
    );
  }
}
