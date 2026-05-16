import 'package:wassaly/core/imports/imports.dart';

/// Auto-scrolling marquee text widget.
/// Only scrolls when [isActive] is true.
/// Resets to start instantly when [isActive] becomes false.
class MarqueeText extends StatefulWidget {
  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    required this.isActive,
  });

  final String text;
  final TextStyle? style;
  final bool isActive;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late final ScrollController _scrollController;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAndReset();
    }
  }

  void _startScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    if (_isRunning) return;

    _isRunning = true;
    _runMarquee(maxScroll);
  }

  void _stopAndReset() {
    _isRunning = false;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _runMarquee(double maxScroll) async {
    while (mounted && _isRunning) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted || !_isRunning) break;

      await _scrollController.animateTo(
        maxScroll,
        duration: Duration(milliseconds: (maxScroll * 18).toInt()),
        curve: Curves.linear,
      );
      if (!mounted || !_isRunning) break;

      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted || !_isRunning) break;

      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _isRunning = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}
