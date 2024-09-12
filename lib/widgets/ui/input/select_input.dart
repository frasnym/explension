import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class SelectInput extends StatefulWidget {
  final List<String> optionsList;
  final Function(String?) onChange;
  final String? placeholder;

  const SelectInput(
      {super.key,
      required this.optionsList,
      required this.onChange,
      this.placeholder});

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  List<String> _filteredOptionsList = [];
  String? _selectedOption;
  bool _showDropdown = false;

  bool get _optionIsSelected => _selectedOption == _searchController.text;

  String get _inputValue => _searchController.text.trim().toLowerCase();

  void _performSearch() {
    setState(() {
      if (!_optionIsSelected && _selectedOption != null) _selectedOption = null;

      _filteredOptionsList = widget.optionsList
          .where((String option) => option.toLowerCase().contains(_inputValue))
          .toList();
      _showDropdown = true;
    });
  }

  void _handleSelect(String option) {
    setState(() {
      widget.onChange(option);
      _showDropdown = false;
      _searchController.text = option;
      _selectedOption = option;
      _focusNode.unfocus();
    });
  }

  void _showAllOptionsList() {
    setState(() {
      _filteredOptionsList = widget.optionsList;
      _showDropdown = !_showDropdown;
    });
  }

  void _handleDropdownTapOutside() {
    setState(() {
      _showDropdown = false;
      if (!_optionIsSelected) _searchController.clear();
      _focusNode.unfocus();
    });
  }

  void _handleInputTapOutside() {
    if (_focusNode.hasFocus && !_showDropdown) {
      if (!_optionIsSelected) _searchController.clear();
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MoonDropdown(
        show: _showDropdown,
        constrainWidthToChild: true,
        onTapOutside: () => _handleDropdownTapOutside(),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: _filteredOptionsList.isEmpty
              ? const MoonMenuItem(
                  label: Text('No results found.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _filteredOptionsList.length,
                  itemBuilder: (BuildContext _, int index) {
                    if (index >= _filteredOptionsList.length) {
                      return const SizedBox.shrink();
                    }
                    final String option = _filteredOptionsList[index];

                    return MoonMenuItem(
                      onTap: () => _handleSelect(option),
                      label: Text(option),
                    );
                  },
                ),
        ),
        child: MoonTextInput(
          focusNode: _focusNode,
          hintText: widget.placeholder,
          controller: _searchController,
          // The onTap() and onChanged() properties are used instead of a listener to initiate search on every input tap.
          // Listener only triggers on input change.
          onTap: () => _performSearch(),
          onTapOutside: (PointerDownEvent _) => _handleInputTapOutside(),
          onChanged: (String _) => _performSearch(),
          trailing: MoonButton.icon(
            buttonSize: MoonButtonSize.xs,
            hoverEffectColor: Colors.transparent,
            onTap: () => _showAllOptionsList(),
            icon: AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: _showDropdown ? -0.5 : 0,
              child: const Icon(MoonIcons.controls_chevron_down_16_light),
            ),
          ),
        ),
      ),
    );
  }
}
