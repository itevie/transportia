import 'package:flutter/material.dart';

class AppTab {
  final String name;
  final IconData icon;
  final Widget child;
  final VoidCallback? onSelected;

  const AppTab({
    required this.name,
    required this.icon,
    required this.child,
    this.onSelected,
  });
}

class AppTabController extends StatefulWidget {
  final List<AppTab> tabs;
  final int initialIndex;
  final bool isScrollable;

  const AppTabController({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.isScrollable = true,
  }) : assert(tabs.length > 0);

  @override
  State<AppTabController> createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();

    _createController();
    _controller.addListener(_onTabChanged);
    widget.tabs[widget.initialIndex].onSelected?.call();
  }

  void _createController() {
    _controller = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
  }

  void _onTabChanged() {
    if (_controller.indexIsChanging) return;

    widget.tabs[_controller.index].onSelected?.call();
  }

  @override
  void didUpdateWidget(covariant AppTabController oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabs.length != widget.tabs.length) {
      _controller.removeListener(_onTabChanged);
      _controller.dispose();

      _createController();
      _controller.addListener(_onTabChanged);
      widget.tabs[_controller.index].onSelected?.call();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controller,
          isScrollable: widget.isScrollable,
          tabs: [
            for (final tab in widget.tabs)
              Tab(icon: Icon(tab.icon), text: tab.name),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [for (final tab in widget.tabs) tab.child],
          ),
        ),
      ],
    );
  }
}
