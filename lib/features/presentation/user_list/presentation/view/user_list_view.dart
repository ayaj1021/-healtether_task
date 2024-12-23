import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heal_tether_task/core/enums/enums.dart';
import 'package:heal_tether_task/features/presentation/user_list/data/model/get_users_list_response.dart';
import 'package:heal_tether_task/features/presentation/user_list/presentation/notifer/get_users_list_notifier.dart';
import 'package:heal_tether_task/features/presentation/user_list/presentation/widgets/animated_user_list_tile_widget.dart';

class UserListView extends ConsumerStatefulWidget {
  const UserListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserListViewState();
}

class _UserListViewState extends ConsumerState<UserListView> {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final _searchController = TextEditingController();
  bool myAnimation = false;
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refresh();
      setState(() {
        myAnimation = true;
      });
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      await ref.read(getUsersListNotifierProvider.notifier).getUsersList();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<GetUsersListResponse> _getFilteredUsers(
      List<GetUsersListResponse>? users) {
    if (users == null) return [];
    if (_searchQuery.isEmpty) return users;

    return users.where((user) {
      final name = user.name.toLowerCase();
      // final email = user.email.toLowerCase();
      final query = _searchQuery.toLowerCase();

      return name.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(
      getUsersListNotifierProvider.select((v) => v.getUsersListResponse),
    );

    final isLoading = ref.watch(
      getUsersListNotifierProvider.select((v) => v.getUsersListState.isLoading),
    );
    final filteredUsers = _getFilteredUsers(userList);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 36, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 34, 36, 49),
        title: const Text(
          'Users List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: _refresh,
        child: SafeArea(
          child: _errorMessage != null
              ? _buildErrorView()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SearchBar(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    isLoading == true
                        ? const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                final userData = filteredUsers[index];
                                return AnimatedUserListTile(
                                  user: userData,
                                  index: index,
                                  animated: myAnimation,
                                  width: width,
                                );
                              },
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _errorMessage ?? 'An error occurred',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refresh,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: Colors.transparent,
          hintText: 'Search by name or email',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
