import 'package:flutter/material.dart';

class TDropDownItem {
  final String label;
  final VoidCallback callback;
  final IconData? icon;
  final bool isDanger;

  TDropDownItem({
    required this.label,
    required this.callback,
    this.icon,
    this.isDanger = false,
  });
}

class TDropDownMenu extends StatefulWidget {
  final List<TDropDownItem> options;
  final Future<List<TDropDownItem>> Function()? loadOptions;
  final double mobileBreakpoint;
  final bool showOnSecondaryClick;
  final VoidCallback? onTap;
  final Widget child;

  const TDropDownMenu({
    super.key,
    required this.options,
    this.loadOptions,
    this.mobileBreakpoint = 600,
    this.showOnSecondaryClick = false,
    required this.child,
    this.onTap,
  });

  @override
  State<TDropDownMenu> createState() => _TDropDownMenuState();
}

class _TDropDownMenuState extends State<TDropDownMenu> {
  bool _isLoading = false;

  Future<List<TDropDownItem>?> _getOptions() async {
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

    final selected = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        MediaQuery.sizeOf(context).width - position.dx,
        MediaQuery.sizeOf(context).height - position.dy,
      ),
      items: options
          .asMap()
          .entries
          .map(
            (item) => PopupMenuItem<int>(
              value: item.key,
              child: item.value.icon == null
                  ? Text(
                      item.value.label,
                      style: item.value.isDanger
                          ? TextStyle(color: Colors.red)
                          : null,
                    )
                  : Row(
                      children: [
                        Icon(
                          item.value.icon,
                          color: item.value.isDanger ? Colors.red : null,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.value.label,
                          style: item.value.isDanger
                              ? TextStyle(color: Colors.red)
                              : null,
                        ),
                      ],
                    ),
            ),
          )
          .toList(),
    );

    if (selected != null) {
      options[selected].callback.call();
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
            children: options.map((entry) {
              return ListTile(
                title: Text(
                  entry.label,
                  style: entry.isDanger ? TextStyle(color: Colors.red) : null,
                ),
                onTap: () {
                  Navigator.pop(context);
                  entry.callback();
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
