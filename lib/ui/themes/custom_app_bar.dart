import 'package:essumin_mix/ui/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int progressBarIndex;
  final int totalItems;
  final VoidCallback onLeadingPressed;

  const CustomAppBar({
    Key? key,
    required this.progressBarIndex,
    required this.totalItems,
    required this.onLeadingPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0XFF0d1117),
      title: ProgressBar(
        totalItems: totalItems,
        currentIndex: progressBarIndex,
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onLeadingPressed,
      ),
      actions: [
        TextButton(
          onPressed: null,
          child: Text(
            '$progressBarIndex/$totalItems',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
