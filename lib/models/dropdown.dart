import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options; // List of options for the dropdown
  final double width;
  final ValueChanged<String> onChanged; // Callback for selected option

  const CustomDropdown({
    super.key,
    required this.options,
    this.width = 150,
    required this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedOption = "";
  bool hasBeenPressed = false;
  late List<String> _dropdownOptions;

  @override
  void initState() {
    super.initState();
    _dropdownOptions = List.from(widget.options);
    selectedOption = _dropdownOptions[0];
  }

  void _onTopButtonClick() {
    setState(() {
      hasBeenPressed = true;
    });
  }

  void _onOptionClick(String option) {
    setState(() {
      selectedOption = option;
      _dropdownOptions.remove(option);
      _dropdownOptions.insert(0, option);
      hasBeenPressed = false;
    });

    // Call the onChanged callback with the new selected option
    widget.onChanged(option);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Button
        SizedBox(
          width: widget.width,
          child: MaterialButton(
            color: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () => _onTopButtonClick(),
            child: SizedBox(
              child: Row(
                children: [
                  Text(selectedOption),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
        // Dropdown List (Initially hidden)
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: hasBeenPressed ? 1 : 0,
          child: Visibility(
            visible: hasBeenPressed,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _dropdownOptions
                    .map(
                      (option) => SizedBox(
                        width: widget.width,
                        child: MaterialButton(
                          color: Theme.of(context).colorScheme.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onPressed: () {
                            _onOptionClick(option);
                          },
                          child: SizedBox(
                            child: Row(
                              children: [
                                Text(option),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
