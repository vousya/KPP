import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 120,

      // LOGO → /main
      leading: InkWell(
        onTap: () => context.go('/lists'),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            'assets/images/logo.jpg',
            width: 120,
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
      ),

      actions: [
        // NOTIFICATIONS → /notifications
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none, size: 30),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () => context.go('/notifications'),
        ),

        const SizedBox(width: 10),

        // PROFILE → /settings
        IconButton(
          icon: const Icon(Icons.person, size: 30),
          onPressed: () => context.go('/settings'),
        ),

        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
