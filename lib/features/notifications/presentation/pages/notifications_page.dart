import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/notifications/domain/entities/notification_entity.dart';
import 'package:wassaly/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:wassaly/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:wassaly/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:wassaly/features/notifications/presentation/widgets/notification_card.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'notifications_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(
            StorageService.instance.setHasSeenShowcase('notifications_v1', value: true),
          );
        },
        builder: Builder(
          builder: (context) => const _NotificationsView(),
        ),
      );
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  void _onLoadMore(BuildContext context, bool hasMore, bool isLoadingMore) {
    if (hasMore && !isLoadingMore) {
      context.read<NotificationsBloc>().add(const LoadMoreNotificationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocListener<NotificationsBloc, NotificationsState>(
      listenWhen: (prev, curr) => prev.actionStatus != curr.actionStatus && curr.actionStatus.isFailure,
      listener: (context, state) {
        context.showTypedSnackBar(
          state.errorMessage ?? '',
          type: SnackBarType.error,
        );
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<NotificationsBloc>().add(const GetNotificationsEvent(isRefresh: true));
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              AppSliverTopBar(
                title: context.l10n.notifications,
                actions: [
                  BlocSelector<NotificationsBloc, NotificationsState, bool>(
                    selector: (state) => state.notifications.isNotEmpty,
                    builder: (context, hasNotifications) {
                      if (!hasNotifications) return const SizedBox.shrink();
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.done_all, color: cs.primary),
                            onPressed: () => context.read<NotificationsBloc>().add(const ReadAllNotificationsEvent()),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_sweep_outlined,
                              color: cs.error,
                            ),
                            onPressed: () => _confirmDeleteAll(context),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              // ── Page-level status (loading / error) ──
              BlocSelector<NotificationsBloc, NotificationsState, AppStatus>(
                selector: (state) => state.status,
                builder: (context, status) {
                  if (status.isLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: AppLoading()),
                    );
                  }
                  if (status.isFailure) {
                    return SliverFillRemaining(
                      child: BlocSelector<NotificationsBloc, NotificationsState, String?>(
                        selector: (s) => s.errorMessage,
                        builder: (context, msg) => AppErrorWidget.failure(
                          failure: UnknownFailure(msg ?? ''),
                          onRetry: () => context.read<NotificationsBloc>().add(const GetNotificationsEvent()),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              // ── Notification list ──
              BlocSelector<NotificationsBloc, NotificationsState, _ListSelectorData>(
                selector: (state) => _ListSelectorData(
                  notifications: state.notifications,
                  isSuccess: state.status.isSuccess,
                ),
                builder: (context, data) {
                  if (data.isSuccess && data.notifications.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppEmptyState(
                        icon: Icons.notifications_none_outlined,
                        title: context.l10n.notification_no_notifications,
                        subtitle: context.l10n.notification_no_notifications_desc,
                      ),
                    );
                  }

                  if (data.isSuccess && data.notifications.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        ShowCaseWidget.of(context).startShowCase([
                          AppShowcaseKeys.notificationsList,
                        ]);
                      }
                    });
                  }

                  if (data.notifications.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  return SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final notification = data.notifications[index];
                          final card = NotificationCard(
                            notification: notification,
                            onTap: () {
                              if (!notification.isRead) {
                                context.read<NotificationsBloc>().add(MarkAsReadEvent(notification.id));
                              }
                              _handleNotificationNavigation(
                                context,
                                notification,
                              );
                            },
                            onDelete: () =>
                                context.read<NotificationsBloc>().add(DeleteNotificationEvent(notification.id)),
                          );

                          if (index == 0) {
                            return AppShowcase(
                              showcaseKey: AppShowcaseKeys.notificationsList,
                              title: context.l10n.showcase_notifications_list_title,
                              description: context.l10n.showcase_notifications_list_desc,
                              isLast: true,
                              child: card,
                            );
                          }
                          return card;
                        },
                        childCount: data.notifications.length,
                      ),
                    ),
                  );
                },
              ),

              // ── Load-more indicator at the bottom (Standardized & Redundant Trigger) ──
              BlocSelector<NotificationsBloc, NotificationsState, _PaginationSelectorData>(
                selector: (state) => _PaginationSelectorData(
                  isLoadingMore: state.isLoadingMore,
                  hasMore: state.hasMore,
                ),
                builder: (context, data) {
                  final (isLoadingMore, hasMore) = (data.isLoadingMore, data.hasMore);

                  return SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        if (hasMore && !isLoadingMore) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _onLoadMore(context, hasMore, isLoadingMore);
                          });
                        }

                        if (isLoadingMore) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: const AppLoading(),
                          );
                        }

                        if (!hasMore && !isLoadingMore) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child: Text(
                                context.l10n.noMoreNotifications,
                                style: context.theme.textTheme.bodySmall?.copyWith(
                                  color: context.theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    unawaited(
      context.showAppDialog<void>(
        builder: (ctx) => _DeleteAllDialog(context: ctx),
      ),
    );
  }

  void _handleNotificationNavigation(
    BuildContext context,
    NotificationEntity notification,
  ) {
    final type = notification.type;
    final data = notification.data;

    try {
      switch (type) {
        case 'new_offer':
        case 'cart_offer_discount':
        case 'favorite_offer_discount':
          final productId = int.tryParse(data['product_id']?.toString() ?? '');
          if (productId != null) {
            unawaited(
              context.push(
                AppRoutes.productDetails,
                extra: {'productId': productId},
              ),
            );
          }

        case 'booking_accepted':
        case 'booking_reschedule_proposed':
          unawaited(context.push(AppRoutes.orders, extra: {'initialIndex': 1}));

        case 'order_status_updated':
          final orderId = int.tryParse(data['order_id']?.toString() ?? '');
          if (orderId != null) {
            unawaited(
              context.push(
                AppRoutes.orderDetails,
                extra: {'orderId': orderId},
              ),
            );
          }

        case 'general':
          context.showTypedSnackBar(
            notification.body,
          );

        default:
          break;
      }
    } on Object catch (e) {
      debugPrint('Error handling notification navigation: $e');
    }
  }
}

// ---------------------------------------------------------------------------
// BlocSelector data holders — Equatable prevents unnecessary rebuilds
// ---------------------------------------------------------------------------
class _ListSelectorData extends Equatable {
  final List<NotificationEntity> notifications;
  final bool isSuccess;

  const _ListSelectorData({
    required this.notifications,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [notifications, isSuccess];
}

class _PaginationSelectorData extends Equatable {
  final bool isLoadingMore;
  final bool hasMore;

  const _PaginationSelectorData({
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [isLoadingMore, hasMore];
}

// ---------------------------------------------------------------------------
// Extracted dialogs
// ---------------------------------------------------------------------------
class _DeleteAllDialog extends StatelessWidget {
  final BuildContext context;

  const _DeleteAllDialog({required this.context});

  @override
  Widget build(BuildContext _) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_sweep_outlined, size: 48.r, color: cs.error),
            16.verticalSpace,
            Text(
              context.l10n.deleteAllNotifications,
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              context.l10n.deleteAllNotificationsConfirm,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: context.l10n.shared_cancel,
                    variant: ButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: AppButton(
                    label: context.l10n.shared_delete,
                    variant: ButtonVariant.danger,
                    isFullWidth: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<NotificationsBloc>().add(const DeleteAllNotificationsEvent());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
