import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

class InternetConnectionWrapper extends StatefulWidget {
  final Widget child;

  const InternetConnectionWrapper({
    super.key,
    required this.child,
  });

  @override
  State<InternetConnectionWrapper> createState() => _InternetConnectionWrapperState();
}

class _InternetConnectionWrapperState extends State<InternetConnectionWrapper> {
  late final StreamSubscription<InternetStatus> _statusSub;
  late final StreamSubscription<NetworkState> _stateSub;

  NetworkState _state = NetworkState.connected;
  bool _showBanner = false;
  bool _isRefreshing = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    final svc = sl<InternetConnectionService>();

    _statusSub = svc.internetConnection.onStatusChange.listen((status) {
      svc.updateStatus(status == InternetStatus.connected);
    });

    _stateSub = svc.stateStream.listen(_onStateChanged);

    _bootstrap(svc);
  }

  Future<void> _bootstrap(InternetConnectionService svc) async {
    final connected = await svc.hasConnection();
    if (!mounted) return;
    svc.updateStatus(connected);
  }

  void _onStateChanged(NetworkState state) {
    if (!mounted) return;
    _hideTimer?.cancel();

    setState(() {
      _state = state;
      _showBanner = true;
    });

    // Auto hide only for "connected" state
    if (state == NetworkState.connected) {
      _hideTimer = Timer(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _showBanner = false);
      });
    } else {
      // Keep unstable/disconnected banner visible until resolved
      _hideTimer = null;
    }
  }

  Future<void> _handleTap() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    await sl<InternetConnectionService>().checkNow();
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _statusSub.cancel();
    _stateSub.cancel();
    sl<InternetConnectionService>().stopPingCheck();
    super.dispose();
  }

  Color get _bannerColor => switch (_state) {
    NetworkState.disconnected => const Color(0xFFB71C1C),
    NetworkState.unstable => const Color(0xFFE65100),
    NetworkState.connected => const Color(0xFF2E7D32),
  };

  IconData get _bannerIcon => switch (_state) {
    NetworkState.disconnected => Icons.wifi_off_rounded,
    NetworkState.unstable => Icons.network_check_rounded,
    NetworkState.connected => Icons.wifi_rounded,
  };

  String _bannerText(bool isAr) {
    if (_isRefreshing) return isAr ? 'جاري التحقق...' : 'Checking...';

    return switch (_state) {
      NetworkState.disconnected => isAr ? 'لا يوجد اتصال بالإنترنت' : 'No internet connection',
      NetworkState.unstable => isAr ? 'الشبكة غير مستقرة' : 'Unstable connection',
      NetworkState.connected => isAr ? 'تم استعادة الاتصال' : 'Connection restored',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final topPadding = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          top: _showBanner ? topPadding + 10.h : -90.h,
          left: 16.w,
          right: 16.w,
          child: GestureDetector(
            onTap: _handleTap,
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: _bannerColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isRefreshing
                          ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Icon(
                        _bannerIcon,
                        key: ValueKey(_state),
                        color: Colors.white,
                        size: 22.r,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          key: ValueKey('$_state$_isRefreshing'),
                          _bannerText(isAr),
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}