// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/repo/menu-item/menu_repository.dart';
import 'package:graduation_project/firebase/firestore_services.dart';
import 'package:graduation_project/presentation/comments/comments.dart';
import 'package:graduation_project/presentation/comments/comments_list.dart';
import 'package:graduation_project/presentation/comments/http.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/app_bar.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/build_restaurant_info.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/menu_grid.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/post_grid.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/home/bloc/restauranthome_bloc.dart';
import 'package:graduation_project/utils/widgets/shimmer_loader.dart';

FirebaseCommentService _commentService = FirebaseCommentService();

class RestaurantHomePage extends StatelessWidget {
  final String restaurantId;

  const RestaurantHomePage({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantHomeBloc(
        restaurantId: restaurantId,
        menuRepository: GetIt.I<MenuRepository>(),
      )..add(LoadRestaurantHomeData()),
      child: const _RestaurantHomeView(),
    );
  }
}

class _RestaurantHomeView extends StatefulWidget {
  const _RestaurantHomeView();

  @override
  State<_RestaurantHomeView> createState() => _RestaurantHomeViewState();
}

class _RestaurantHomeViewState extends State<_RestaurantHomeView> {
  int _selectedSection = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantHomeBloc, RestaurantHomeState>(
      builder: (context, state) {
        if (state is RestaurantHomeLoading) {
          return Scaffold(
            body: Center(child: ShimmerLoader()),
          );
        }

        if (state is RestaurantHomeError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${state.message}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }

        if (state is RestaurantHomeLoaded) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                LuxuryAppBar(
                  restaurant: state.restaurant,
                  menuItems: state.menuItems,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionSelector(context),
                      _buildSelectedSectionContent(state),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }

  Widget _buildSectionSelector(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SectionButton(
            label: 'Menu',
            isSelected: _selectedSection == 0,
            onTap: () => setState(() => _selectedSection = 0),
          ),
          _SectionButton(
            label: 'Posts',
            isSelected: _selectedSection == 1,
            onTap: () => setState(() => _selectedSection = 1),
          ),
          _SectionButton(
            label: 'Contact',
            isSelected: _selectedSection == 2,
            onTap: () => setState(() => _selectedSection = 2),
          ),
          _SectionButton(
            label: 'Reviews',
            isSelected: _selectedSection == 3,
            onTap: () => setState(() => _selectedSection = 3),
          ),
        ],
      ),
    );
  }

  bool _isSubmitting = false;

  Widget _buildSelectedSectionContent(RestaurantHomeLoaded state) {
    switch (_selectedSection) {
      case 0:
        return MenuGrid(
          restaurantId: state.restaurant['id'],
        );
      case 1:
        return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: RestaurantPostsScreen(restaurantId: state.restaurant['id']));
      case 2:
        return RestaurantInfo(restaurant: state.restaurant);
      case 3:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Comment submission section (fixed height)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: CommentSection(
                  submitButtonText: 'Post Review',
                  onSubmit: (comment) async {
                    if (_isSubmitting) return;

                    setState(() {
                      _isSubmitting = true;
                    });

                    try {
                      final result = await postComment(comment); // ✅ waits here
                      await FirebaseCommentService().saveComment(
                        restaurantId: state.restaurant['id'],
                        comment: comment,
                        commentResult: result,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Review posted successfully!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      setState(() {}); // Refresh comments list
                      BlocProvider.of<RestaurantHomeBloc>(context)
                          .add(LoadRestaurantHomeData());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Failed to post review: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      setState(() {
                        _isSubmitting = false;
                      });
                    }
                  }),
            ),
            // Comments list (flexible space)
            Flexible(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: CommentsList(
                  restaurantId: state.restaurant['id'],
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _SectionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SectionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
