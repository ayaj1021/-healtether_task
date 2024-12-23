import 'package:flutter/material.dart';
import 'package:heal_tether_task/features/presentation/user_list/data/model/get_users_list_response.dart';

class AnimatedUserListTile extends StatelessWidget {
  final GetUsersListResponse user;
  final int index;
  final bool animated;
  final double width;

  const AnimatedUserListTile({
    super.key,
    required this.user,
    required this.index,
    required this.animated,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 250)),
      curve: Curves.decelerate,
      transform: Matrix4.translationValues(animated ? 0 : width, 0, 0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          user.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          user.email,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
