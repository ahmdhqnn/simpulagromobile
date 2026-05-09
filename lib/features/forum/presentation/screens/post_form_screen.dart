import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
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
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadPostData() async {
    setState(() => _isLoadingData = true);
    try {
      final repository = ref.read(forumRepositoryProvider);
      final post = await repository.getPostById(widget.postId!);
      if (mounted) {
        _contentController.text = post.postContent;
        _imageUrlController.text = post.postImage ?? '';
        setState(() => _isLoadingData = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingData = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memuat data postingan: $e',
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(forumRepositoryProvider);
      final siteId = ref.read(selectedSiteIdProvider);

      if (_isEditMode) {
        await repository.updatePost(
          postId: widget.postId!,
          content: _contentController.text.trim(),
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
        );
      } else {
        if (siteId == null) {
          throw Exception('Pilih site terlebih dahulu');
        }
        await repository.createPost(
          siteId: siteId,
          content: _contentController.text.trim(),
          imageUrl: _imageUrlController.text.trim().isEmpty
              ? null
              : _imageUrlController.text.trim(),
        );
      }

      ref.invalidate(forumProvider);
      ref.invalidate(myPostsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Postingan berhasil diupdate'
                  : 'Postingan berhasil dibuat',
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
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
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
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
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Postingan' : 'Buat Postingan',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1D1D1D)),
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
            TextButton(
              onPressed: _submit,
              child: Text(
                _isEditMode ? 'Update' : 'Posting',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: _isLoadingData
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(context.rw(0.051)),
                children: [
                  // Content field
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextFormField(
                      controller: _contentController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        hintText: 'Apa yang ingin Anda bagikan?',
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
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

                  SizedBox(height: context.rh(0.02)),

                  // Image URL field
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'URL Gambar (Opsional)',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF1D1D1D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: InputDecoration(
                            hintText: 'https://example.com/image.jpg',
                            hintStyle: const TextStyle(
                              color: Color(0xFF999999),
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
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

                  SizedBox(height: context.rh(0.02)),

                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF856404),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pastikan konten Anda sesuai dengan pedoman komunitas',
                            style: TextStyle(
                              color: Color(0xFF856404),
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
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
}
