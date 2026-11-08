import 'package:flutter/material.dart';

class TDropDownMenu extends StatefulWidget {
  final Widget child;
  final Map<String, VoidCallback> options;
  final Future<Map<String, VoidCallback>> Function()? loadOptions;
  final double mobileBreakpoint;
  final bool showOnSecondaryClick;
  final VoidCallback? onTap;

  const TDropDownMenu({
    super.key,
    required this.child,
    required this.options,
    this.loadOptions,
    this.mobileBreakpoint = 600,
    this.showOnSecondaryClick = false,
    this.onTap,
  });

  @override
  State<TDropDownMenu> createState() => _TDropDownMenuState();
}

class _TDropDownMenuState extends State<TDropDownMenu> {
  bool _isLoading = false;

  Future<Map<String, VoidCallback>?> _getOptions() async {
    if (_isLoading) return null;

    if (widget.loadOptions == null) {
      return widget.options;
    }

    setState(() => _isLoading = true);

    try {
      return await widget.loadOptions!();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load menu: $error')));
      }
      return null;
    }
  }

  void _finishLoading() {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showDesktopMenu(Offset position) async {
    final options = await _getOptions();

    if (!mounted || options == null) {
      _finishLoading();
      return;
    }

    _finishLoading();

    if (options.isEmpty) return;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        MediaQuery.sizeOf(context).width - position.dx,
        MediaQuery.sizeOf(context).height - position.dy,
      ),
      items: options.keys
          .map((name) => PopupMenuItem<String>(value: name, child: Text(name)))
          .toList(),
    );

    if (selected != null) {
      options[selected]?.call();
    }
  }

  Future<void> _showBottomSheet() async {
    final options = await _getOptions();

    if (!mounted || options == null) {
      _finishLoading();
      return;
    }

    _finishLoading();

    if (options.isEmpty) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 8),
            children: options.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                onTap: () {
                  Navigator.pop(context);
                  entry.value();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < widget.mobileBreakpoint;

    if (widget.showOnSecondaryClick) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onSecondaryTapDown: isMobile
            ? null
            : (details) => _showDesktopMenu(details.globalPosition),
        onLongPress: isMobile ? _showBottomSheet : null,
        child: Stack(
          children: [
            widget.child,
            if (_isLoading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x55000000),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      );
    }

    if (isMobile) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showBottomSheet,
          child: IgnorePointer(child: widget.child),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => _showDesktopMenu(details.globalPosition),
      child: Stack(
        children: [
          widget.child,
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x55000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
