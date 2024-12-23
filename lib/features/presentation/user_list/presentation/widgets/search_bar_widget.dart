import 'package:flutter/material.dart';

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
