import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/notification.dart';

const _bannerDisplayDuration = Duration(seconds: 5);
const _bannerSlideDuration = Duration(milliseconds: 300);
const _openIconPath = 'assets/icons/arrow-up-right-long-outline-icon.svg';

class InAppPopupBanner extends StatefulWidget {
  final AppNotification notification;
  final VoidCallback onDismiss;

  const InAppPopupBanner({
    super.key,
    required this.notification,
    required this.onDismiss,
  });

  @override
  State<InAppPopupBanner> createState() => _InAppPopupBannerState();
}

class _InAppPopupBannerState extends State<InAppPopupBanner>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _progressController;
  late final Animation<Offset> _offsetAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: _bannerSlideDuration,
      vsync: this,
    );
    _progressController =
        AnimationController(duration: _bannerDisplayDuration, vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _dismiss();
            }
          });
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _dismiss({bool animate = true}) {
    if (_isClosing) return;
    _isClosing = true;
    _progressController.stop();

    if (!animate) {
      widget.onDismiss();
      return;
    }

    _slideController.reverse().whenComplete(widget.onDismiss);
  }

  String _getIconPath() {
    switch (widget.notification.type) {
      case NotificationType.recommendation:
        return 'assets/icons/recomendation-filled-icon.svg';
      case NotificationType.deviceAlert:
        return 'assets/icons/warning-outline-icon.svg';
      case NotificationType.siteInvite:
        return 'assets/icons/home-outline-icon.svg';
      case NotificationType.taskAssignment:
        return 'assets/icons/task-outline-icon.svg';
      case NotificationType.forumInteraction:
        return 'assets/icons/forum-outline-icon.svg';
      case NotificationType.general:
        return 'assets/icons/message-outline-icon.svg';
    }
  }

  Color _getAccentColor() {
    switch (widget.notification.type) {
      case NotificationType.recommendation:
        return AppColors.success;
      case NotificationType.deviceAlert:
        return AppColors.error;
      case NotificationType.siteInvite:
        return AppColors.primary;
      case NotificationType.taskAssignment:
        return AppColors.warning;
      case NotificationType.forumInteraction:
        return AppColors.info;
      case NotificationType.general:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = _getIconPath();
    final accentColor = _getAccentColor();

    return SlideTransition(
      position: _offsetAnimation,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Dismissible(
            key: Key(widget.notification.id),
            direction: DismissDirection.up,
            onDismissed: (_) => _dismiss(animate: false),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  _dismiss();
                  final redirectPath = widget.notification.redirectPath;
                  if (redirectPath != null) {
                    context.push(redirectPath);
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(width: 6, color: accentColor),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: accentColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          iconPath,
                                          colorFilter: ColorFilter.mode(
                                            accentColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.notification.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily:
                                                    AppTextStyles.fontFamily,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              widget.notification.body,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily:
                                                    AppTextStyles.fontFamily,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SvgPicture.asset(
                                        _openIconPath,
                                        width: 20,
                                        height: 20,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.textTertiary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            final widthFactor = (1 - _progressController.value)
                                .clamp(0.0, 1.0)
                                .toDouble();

                            return Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: widthFactor,
                                child: child,
                              ),
                            );
                          },
                          child: Container(height: 3, color: accentColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InAppPopupBannerManager {
  static final Queue<AppNotification> _queue = Queue<AppNotification>();
  static OverlayEntry? _currentEntry;
  static BuildContext? _currentContext;

  static void show(BuildContext context, AppNotification notification) {
    _currentContext = context;
    _queue.add(notification);
    if (_currentEntry == null) {
      _showNext();
    }
  }

  static void _showNext() {
    final context = _currentContext;
    if (context == null || _queue.isEmpty) return;

    final notification = _queue.removeFirst();
    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: InAppPopupBanner(
            notification: notification,
            onDismiss: () {
              if (_currentEntry == entry) {
                _currentEntry = null;
              }
              entry.remove();
              _showNext();
            },
          ),
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void hide() {
    _queue.clear();
    final entry = _currentEntry;
    if (entry != null) {
      _currentEntry = null;
      entry.remove();
    }
  }
}
