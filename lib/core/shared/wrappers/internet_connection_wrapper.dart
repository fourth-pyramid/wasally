import 'package:wassaly/core/imports/imports.dart';

class InternetConnectionWrapper extends StatefulWidget {
  final Widget child;

  const InternetConnectionWrapper({
    super.key,
    required this.child,
  });

  @override
  State<InternetConnectionWrapper> createState() =>
      _InternetConnectionWrapperState();
}

class _InternetConnectionWrapperState
    extends State<InternetConnectionWrapper> {
  late final StreamSubscription<InternetStatus> _subscription;
  bool _isConnected = true;
  bool _showBanner = false;
  Timer? _hideBannerTimer;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = sl<InternetConnectionService>()
        .internetConnection
        .onStatusChange
        .listen(_onStatusChanged);
  }

  Future<void> _checkInitialConnection() async {
    final connected = await sl<InternetConnectionService>().hasConnection();
    if (mounted) {
      sl<InternetConnectionService>().updateStatus(connected);
      setState(() {
        _isConnected = connected;
        _showBanner = !connected;
      });
    }
  }

  void _onStatusChanged(InternetStatus status) {
    if (!mounted) return;
    final isNowConnected = status == InternetStatus.connected;

    if (isNowConnected == _isConnected) return;

    // Notify service (triggers connectivityRestoredStream if restored)
    sl<InternetConnectionService>().updateStatus(isNowConnected);

    _hideBannerTimer?.cancel();

    setState(() {
      _isConnected = isNowConnected;
      _showBanner = true;
    });

    // Auto-hide the "restored" banner after 2.5 seconds
    if (isNowConnected) {
      _hideBannerTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted && _isConnected) {
          setState(() => _showBanner = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _hideBannerTimer?.cancel();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final topPadding = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          top: _showBanner ? (topPadding + 10.h) : -80.h,
          left: 16.w,
          right: 16.w,
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: _isConnected
                    ? const Color(0xFF2E7D32) // Premium green
                    : const Color(0xFFE65100), // Premium orange
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      _isConnected ? Icons.wifi : Icons.wifi_off_rounded,
                      key: ValueKey(_isConnected),
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        key: ValueKey(_isConnected),
                        _isConnected
                            ? (isAr
                                ? 'تم استعادة الاتصال بالإنترنت'
                                : 'Internet connection restored')
                            : context.l10n.errors_no_internet_title,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
