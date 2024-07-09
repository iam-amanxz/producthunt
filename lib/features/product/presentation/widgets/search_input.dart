import 'package:flutter/material.dart';
import 'package:producthunt/core/theme/app_palette.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    required this.onSearch,
  });

  final void Function(String) onSearch;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (text) {
        widget.onSearch(text);
        setState(() {});
      },
      cursorColor: AppPalette.silverMedal,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            _searchController.clear();
            widget.onSearch("");
            setState(() {});
          },
          child: Icon(
            _searchController.text.isEmpty ? Icons.search : Icons.close,
            color: AppPalette.silverMedal,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "Search here...",
        hintStyle: const TextStyle(
          color: AppPalette.codexGrey,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
