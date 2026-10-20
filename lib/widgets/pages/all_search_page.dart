import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transportia/api/big_search.dart';
import 'package:transportia/main_old.dart';
import 'package:transportia/util_widgets/tab_bar.dart';
import 'package:transportia/widgets/pages/operator_page.dart';
import 'package:transportia/widgets/pages/user.dart';
import 'package:transportia/widgets/profile_picture.dart';
import 'package:transportia/widgets/service_number.dart';
// Import ApiBigSearch from wherever it is defined.

class AllSearchPage extends StatefulWidget {
  const AllSearchPage({super.key});

  @override
  State<AllSearchPage> createState() => _AllSearchPageState();
}

class _AllSearchPageState extends State<AllSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  ApiBigSearch? _results;
  bool _isLoading = false;
  String? _error;

  void _onSearchChanged(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _results = null;
        _isLoading = false;
        _error = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query.trim());
    });
  }

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await ApiBigSearch.search(query);

      if (!mounted) return;

      // Ignore stale responses if the query has changed.
      if (_searchController.text.trim() != query) return;

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SearchBar(
          controller: _searchController,
          hintText: "Search everything...",
          onChanged: _onSearchChanged,
          trailing: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Search failed: $_error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: AppTabController(
            tabs: [
              AppTab(
                name: "Users (${_results?.users.length ?? 0})",
                icon: Icons.person,
                child: ListView.builder(
                  itemCount: _results?.users.length ?? 0,
                  itemBuilder: (context, index) {
                    final user = _results!.users[index];

                    return ListTile(
                      leading: ProfilePicture(
                        usage: ProfilePictureUsage.nextToName,
                      ),
                      title: Text(user.username),
                      onTap: () {
                        setAppPage(UserViewer(user: user));
                      },
                    );
                  },
                ),
              ),
              AppTab(
                name: "Operators (${_results?.operators.length ?? 0})",
                icon: Icons.business,
                child: ListView.builder(
                  itemCount: _results?.operators.length ?? 0,
                  itemBuilder: (context, index) {
                    final operator = _results!.operators[index];

                    return ListTile(
                      title: Text(operator.displayName),
                      onTap: () {
                        setAppPage(OperatorPage(operator: operator));
                      },
                    );
                  },
                ),
              ),
              AppTab(
                name: "Routes (${_results?.routes.length ?? 0})",
                icon: Icons.route,
                child: ListView.builder(
                  itemCount: _results?.routes.length ?? 0,
                  itemBuilder: (context, index) {
                    final route = _results!.routes[index];

                    return Row(
                      children: [
                        ServiceNumber(
                          lineName: route.name,
                          operator: route.operatorNationalCode,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            route.displayName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              AppTab(
                name: "Vehicle Types (${_results?.vehicleTypes.length ?? 0})",
                icon: Icons.directions_bus,
                child: ListView.builder(
                  itemCount: _results?.vehicleTypes.length ?? 0,
                  itemBuilder: (context, index) {
                    final vehicleType = _results!.vehicleTypes[index];

                    return ListTile(
                      title: Text(vehicleType.name),
                      onTap: () {},
                    );
                  },
                ),
              ),
              AppTab(
                name: "Liveries (${_results?.liveries.length ?? 0})",
                icon: Icons.palette,
                child: ListView.builder(
                  itemCount: _results?.liveries.length ?? 0,
                  itemBuilder: (context, index) {
                    final liveries = _results!.liveries[index];

                    return ListTile(title: Text(liveries.name), onTap: () {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
