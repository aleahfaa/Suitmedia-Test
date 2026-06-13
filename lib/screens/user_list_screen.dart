import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/app_state.dart';
import '../providers/user_list_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/shimmer_user_item.dart';
import '../widgets/user_list_item.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserListProvider>(
        context,
        listen: false,
      ).fetchUsers(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<UserListProvider>(context, listen: false);
    if (provider.isLoading || provider.isRefreshing || !provider.hasMore) {
      return;
    }
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      provider.fetchUsers();
    }
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      itemCount: 6,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.divider, height: 1, thickness: 0.5),
      itemBuilder: (_, __) => const ShimmerUserItem(),
    );
  }

  Widget _buildErrorState(BuildContext context, UserListProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: AppColors.textMedium,
            ),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Retry',
              onPressed: () => provider.fetchUsers(refresh: true),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Third Screen',
        backArrowColor: AppColors.accentPurple,
      ),
      body: Consumer<UserListProvider>(
        builder: (context, provider, child) {
          if (provider.users.isEmpty && provider.isLoading) {
            return _buildShimmerList();
          }
          if (provider.hasError && provider.users.isEmpty) {
            return _buildErrorState(context, provider);
          }
          if (provider.users.isEmpty && provider.isRefreshing) {
            return RefreshIndicator(
              onRefresh: () => provider.fetchUsers(refresh: true),
              color: AppColors.primary,
              child: _buildShimmerList(),
            );
          }
          if (provider.users.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => provider.fetchUsers(refresh: true),
              color: AppColors.primary,
              child: Stack(
                children: [
                  ListView(),
                  Center(
                    child: Text(
                      'No users available',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchUsers(refresh: true),
            color: AppColors.primary,
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              itemCount: provider.users.length + (provider.hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const Divider(
                color: AppColors.divider,
                height: 1,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                if (index == provider.users.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }
                final user = provider.users[index];
                return UserListItem(
                  user: user,
                  onTap: () {
                    Provider.of<AppState>(
                      context,
                      listen: false,
                    ).setSelectedUserName(user.fullName);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
