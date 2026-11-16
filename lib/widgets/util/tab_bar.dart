import 'package:flutter/material.dart';

class AppTab {
  final String id;
  final String name;
  final IconData icon;
  final Widget child;
  final VoidCallback? onSelected;

  const AppTab({
    required this.id,
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
    with TickerProviderStateMixin {
  late TabController _controller;

  String? _selectedTabId;

  @override
  void initState() {
    super.initState();

    final index = widget.initialIndex.clamp(0, widget.tabs.length - 1);

    _selectedTabId = widget.tabs[index].id;

    _createController(index);
  }

  void _createController(int initialIndex) {
    _controller = TabController(
      length: widget.tabs.length,
      initialIndex: initialIndex,
      vsync: this,
    );

    _controller.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_controller.indexIsChanging) return;

    final tab = widget.tabs[_controller.index];

    if (_selectedTabId == tab.id) return;

    _selectedTabId = tab.id;
    tab.onSelected?.call();
  }

  @override
  void didUpdateWidget(covariant AppTabController oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.tabs.isEmpty) return;

    final oldIndex = _controller.index;

    // Find the previously selected tab in the new list.
    var newIndex = widget.tabs.indexWhere((tab) => tab.id == _selectedTabId);

    // If it was removed, use the nearest available index.
    if (newIndex == -1) {
      newIndex = oldIndex.clamp(0, widget.tabs.length - 1);
    }

    final lengthChanged = oldWidget.tabs.length != widget.tabs.length;

    if (lengthChanged) {
      _controller.removeListener(_onTabChanged);
      _controller.dispose();

      _selectedTabId = widget.tabs[newIndex].id;

      _createController(newIndex);

      widget.tabs[newIndex].onSelected?.call();
    } else {
      // The controller can stay alive if only the tab contents changed.
      if (_controller.index != newIndex) {
        _controller.animateTo(newIndex);
      }

      _selectedTabId = widget.tabs[newIndex].id;
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
    if (widget.tabs.isEmpty) {
      return const SizedBox.shrink();
    }

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
            children: [
              for (final tab in widget.tabs)
                KeyedSubtree(key: ValueKey(tab.id), child: tab.child),
            ],
          ),
        ),
      ],
    );
  }
}
