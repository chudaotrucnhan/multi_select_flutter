import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:multi_select_flutter/theme/lib_theme.dart';
import 'package:multi_select_flutter/widget/button_elevated.dart';
import '../util/multi_select_item.dart';
import '../util/multi_select_actions.dart';
import '../util/multi_select_list_type.dart';

/// A bottom sheet widget containing either a classic checkbox style list, or a chip style list.
class MultiSelectBottomSheet<T> extends StatefulWidget
    with MultiSelectActions<T> {
  /// List of items to select from.
  final List<MultiSelectItem<T>> items;

  /// The list of selected values before interaction.
  final List<T> initialValue;

  /// The text at the top of the BottomSheet.
  final Widget? title;

  /// Fires when the an item is selected / unselected.
  final void Function(List<T>)? onSelectionChanged;

  /// Fires when confirm is tapped.
  final void Function(List<T>)? onConfirm;

  /// Toggles search functionality.
  final bool searchable;

  /// Text on the confirm button.
  final Text? confirmText;

  /// Text on the cancel button.
  final Text? cancelText;

  /// An enum that determines which type of list to render.
  final MultiSelectListType? listType;

  /// Sets the color of the checkbox or chip when it's selected.
  final Color? selectedColor;

  /// Set the initial height of the BottomSheet.
  final double? initialChildSize;

  /// Set the minimum height threshold of the BottomSheet before it closes.
  final double? minChildSize;

  /// Set the maximum height of the BottomSheet.
  final double? maxChildSize;

  /// Set the placeholder text of the search field.
  final String? searchHint;

  /// A function that sets the color of selected items based on their value.
  /// It will either set the chip color, or the checkbox color depending on the list type.
  final Color? Function(T)? colorator;

  /// Color of the chip body or checkbox border while not selected.
  final Color? unselectedColor;

  /// Icon button that shows the search field.
  final Icon? searchIcon;

  /// Icon button that hides the search field
  final Icon? closeSearchIcon;

  /// Style the text on the chips or list tiles.
  final TextStyle? itemsTextStyle;

  /// Style the text on the selected chips or list tiles.
  final TextStyle? selectedItemsTextStyle;

  /// Style the search text.
  final TextStyle? searchTextStyle;

  /// Style the search hint.
  final TextStyle? searchHintStyle;

  /// Moves the selected items to the top of the list.
  final bool separateSelectedItems;

  /// Set the color of the check in the checkbox
  final Color? checkColor;

  final Widget Function(
    MultiSelectItem<T>,
    int,
    Function(MultiSelectItem<T>, bool?),
  )? listItemUI;

  final Widget Function(Function, Function)? actionTopBarUI;

  MultiSelectBottomSheet({
    required this.items,
    required this.initialValue,
    this.title,
    this.onSelectionChanged,
    this.onConfirm,
    this.listType,
    this.cancelText,
    this.confirmText,
    this.searchable = false,
    this.selectedColor,
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    this.colorator,
    this.unselectedColor,
    this.searchIcon,
    this.closeSearchIcon,
    this.itemsTextStyle,
    this.searchTextStyle,
    this.searchHint,
    this.searchHintStyle,
    this.selectedItemsTextStyle,
    this.separateSelectedItems = false,
    this.checkColor,
    this.listItemUI,
    this.actionTopBarUI,
  });

  @override
  _MultiSelectBottomSheetState<T> createState() =>
      _MultiSelectBottomSheetState<T>(items);
}

class _MultiSelectBottomSheetState<T> extends State<MultiSelectBottomSheet<T>> {
  List<T> _selectedValues = [];
  bool _showSearch = false;
  List<MultiSelectItem<T>> _items;

  _MultiSelectBottomSheetState(this._items);

  @override
  void initState() {
    super.initState();
    _selectedValues.addAll(widget.initialValue);

    for (int i = 0; i < _items.length; i++) {
      _items[i].selected = false;
      if (_selectedValues.contains(_items[i].value)) {
        _items[i].selected = true;
      }
    }

    if (widget.separateSelectedItems) {
      _items = widget.separateSelected(_items);
    }
  }

  void onChanged(MultiSelectItem<T> item, bool? checked) {
    setState(() {
      _selectedValues =
          widget.onItemCheckedChange(_selectedValues, item.value, checked!);

      if (checked) {
        item.selected = true;
      } else {
        item.selected = false;
      }
      if (widget.separateSelectedItems) {
        _items = widget.separateSelected(_items);
      }
    });
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(_selectedValues);
    }
  }

  /// Returns a CheckboxListTile
  Widget _buildListItem(MultiSelectItem<T> item, int index) {
    CheckboxListTile listItem = CheckboxListTile(
      checkColor: widget.checkColor,
      value: item.selected,
      activeColor: widget.colorator != null
          ? widget.colorator!(item.value) ?? widget.selectedColor
          : widget.selectedColor,
      title: Text(
        item.label,
        style: item.selected
            ? widget.selectedItemsTextStyle
            : widget.itemsTextStyle,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) {
        onChanged(item, checked);
      },
    );

    return Theme(
      data: ThemeData(
        unselectedWidgetColor: widget.unselectedColor ?? Colors.black54,
      ),
      child: widget.listItemUI != null
          ? widget.listItemUI!(item, index, onChanged)
          : CheckboxListTile(
              checkColor: widget.checkColor,
              value: item.selected,
              activeColor: widget.colorator != null
                  ? widget.colorator!(item.value) ?? widget.selectedColor
                  : widget.selectedColor,
              title: Text(
                item.label,
                style: item.selected
                    ? widget.selectedItemsTextStyle
                    : widget.itemsTextStyle,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (checked) {
                onChanged(item, checked);
              },
            ),
    );
  }

  /// Returns a ChoiceChip
  Widget _buildChipItem(MultiSelectItem<T> item) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: ChoiceChip(
        backgroundColor: widget.unselectedColor,
        selectedColor:
            widget.colorator != null && widget.colorator!(item.value) != null
                ? widget.colorator!(item.value)
                : widget.selectedColor != null
                    ? widget.selectedColor
                    : Theme.of(context).primaryColor.withOpacity(0.35),
        label: Text(
          item.label,
          style: _selectedValues.contains(item.value)
              ? TextStyle(
                  color: widget.selectedItemsTextStyle?.color ??
                      widget.colorator?.call(item.value) ??
                      widget.selectedColor?.withOpacity(1) ??
                      Theme.of(context).primaryColor,
                  fontSize: widget.selectedItemsTextStyle != null
                      ? widget.selectedItemsTextStyle!.fontSize
                      : null,
                )
              : widget.itemsTextStyle,
        ),
        selected: item.selected,
        onSelected: (checked) {
          if (checked) {
            item.selected = true;
          } else {
            item.selected = false;
          }
          setState(() {
            _selectedValues = widget.onItemCheckedChange(
                _selectedValues, item.value, checked);
          });
          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!(_selectedValues);
          }
        },
      ),
    );
  }

  Widget typeListUI(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return _buildListItem(_items[index], index);
      },
    );
  }

  Widget searchUI() {
    if (!widget.searchable) {
      return SizedBox();
    }
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          autofocus: true,
          style: widget.searchTextStyle,
          decoration: InputDecoration(
            hintStyle: widget.searchHintStyle,
            hintText: widget.searchHint ?? "Search",
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:
                      widget.selectedColor ?? Theme.of(context).primaryColor),
            ),
          ),
          onChanged: (val) {
            List<MultiSelectItem<T>> filteredList = [];
            filteredList = widget.updateSearchQuery(val, widget.items);
            setState(() {
              if (widget.separateSelectedItems) {
                _items = widget.separateSelected(filteredList);
              } else {
                _items = filteredList;
              }
            });
          },
        ),
      ),
    );
  }

  Widget getSearchUI() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: LibTheme.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                          color: LibTheme.borderColor,
                          width: LibTheme.borderWidth)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 40,
                              height: 40,
                              child: DecoratedBox(
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: Icon(
                                  LucideIcons.search,
                                  color: LibTheme.iconColor,
                                  size: LibTheme.iconSize,
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2.5),
                                  child: TextField(
                                    onChanged: (val) {
                                      List<MultiSelectItem<T>> filteredList =
                                          [];
                                      filteredList = widget.updateSearchQuery(
                                          val, widget.items);
                                      setState(() {
                                        if (widget.separateSelectedItems) {
                                          _items = widget
                                              .separateSelected(filteredList);
                                        } else {
                                          _items = filteredList;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: widget.searchHintStyle ??
                                          TextStyle(color: LibTheme.hintColor),
                                      hintText: widget.searchHint ?? "Search",
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBarUI() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _showSearch
              ? searchUI()
              : widget.title ?? Text("Select", style: TextStyle(fontSize: 18)),
          widget.searchable
              ? IconButton(
                  icon: _showSearch
                      ? widget.closeSearchIcon ?? Icon(Icons.close)
                      : widget.searchIcon ?? Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _showSearch = !_showSearch;
                      if (!_showSearch) {
                        if (widget.separateSelectedItems) {
                          _items = widget.separateSelected(widget.items);
                        } else {
                          _items = widget.items;
                        }
                      }
                    });
                  },
                )
              : Padding(
                  padding: EdgeInsets.all(15),
                ),
        ],
      ),
    );
  }

  Widget modalTopUI() {
    if (widget.actionTopBarUI != null) {
      return widget.actionTopBarUI!(
        () {
          widget.onCancelTap(context, widget.initialValue);
        },
        () {
          widget.onConfirmTap(context, _selectedValues, widget.onConfirm);
        },
      );
    }
    TextStyle buttonLabel = TextStyle(
      // fontFamily: appFontName,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      // color: colorPrimary,
    );
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 0),
      color: Colors.transparent,
      child: Row(
        children: [
          ButtonElevated(
            size: null,
            onPressed: () {
              widget.onCancelTap(context, widget.initialValue);
            },
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            child: widget.cancelText ?? Text("CANCEL", style: buttonLabel),
          ),
          Expanded(
              child: Center(
            child: widget.title ??
                Text(
                  'Select',
                  style: TextStyle(
                    // fontFamily: appFontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    // color: titleColor,
                  ),
                ),
          )),
          ButtonElevated(
            size: null,
            onPressed: () {
              widget.onConfirmTap(context, _selectedValues, widget.onConfirm);
            },
            backgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            child: widget.confirmText ?? Text("OK", style: buttonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: widget.initialChildSize ?? 0.3,
        minChildSize: widget.minChildSize ?? 0.3,
        maxChildSize: widget.maxChildSize ?? 0.6,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            children: [
              modalTopUI(),
              // searchBarUI(),
              getSearchUI(),
              Expanded(
                child: widget.listType == null ||
                        widget.listType == MultiSelectListType.LIST
                    ? typeListUI(scrollController)
                    : SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Wrap(
                            children: _items.map(_buildChipItem).toList(),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
