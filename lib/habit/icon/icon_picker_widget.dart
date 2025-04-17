// lib/habit/icon_picker/icon_picker_widget.dart
import 'package:flutter/material.dart';
import 'package:prabit_design/flutter_flow/flutter_flow_theme.dart'; // Adjust import
import 'habit_icon_data.dart'; // Import the icon data definition

class IconPickerWidget extends StatefulWidget {
  final String? currentlySelectedId;

  const IconPickerWidget({
    Key? key,
    this.currentlySelectedId,
  }) : super(key: key);

  @override
  _IconPickerWidgetState createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  String _searchTerm = '';
  String? _selectedCategory = 'All'; // Default to 'All'
  List<HabitIconInfo> _filteredIcons = allHabitIcons; // Start with all icons

  // Get unique categories including 'All'
  final List<String> _categories = ['All', ...getHabitIconCategories()];

  @override
  void initState() {
    super.initState();
    _filterIcons(); // Initial filter if needed
  }

  void _filterIcons() {
    setState(() {
      _filteredIcons = allHabitIcons.where((icon) {
        final bool matchesCategory = _selectedCategory == 'All' ||
            icon.category == _selectedCategory;
        final bool matchesSearch = _searchTerm.isEmpty ||
            icon.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            icon.id.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            icon.category.toLowerCase().contains(_searchTerm.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // ADD Material WRAPPER HERE:
    return Material(
      // If your Container provides the background color/shape,
      // you might not need specific properties here, or set to transparent.
      // If Container DIDN'T have color, you'd set it here:
      // color: theme.primaryBackground,
      // You might want to ensure the shape matches if the container had specific radii
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      clipBehavior: Clip.antiAlias, // Good practice with borderRadius

      child: Container( // This is the ORIGINAL root Container
        height: MediaQuery
            .of(context)
            .size
            .height * 0.75,
        decoration: BoxDecoration(
          color: theme.primaryBackground, // Keep this decoration
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            // Optional: Drag Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: TextField(
                onChanged: (value) {
                  _searchTerm = value;
                  _filterIcons();
                },
                decoration: InputDecoration(
                  hintText: 'Search icons...',
                  hintStyle: theme.bodySmall,
                  prefixIcon: Icon(Icons.search, color: theme.secondaryText),
                  filled: true,
                  fillColor: theme.secondaryBackground,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: theme.bodyMedium.override(
                    fontFamily: 'Inter', color: theme.primaryText),
              ),
            ),

            // Category Chips
            // Category Chips Section (Replace Padding + Wrap)

// Use Padding if you still want padding around the scroll view
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Only vertical padding for the whole row
              child: SingleChildScrollView( // Allows horizontal scrolling
                scrollDirection: Axis.horizontal, // Set scroll direction
                // Add padding inside the scroll view if needed (for start/end)
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row( // Use Row instead of Wrap
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    // Add Padding or SizedBox for spacing between chips
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0), // Spacing after each chip
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : 'All';
                          });
                          _filterIcons();
                        },
                        // Keep your existing FilterChip styling
                        backgroundColor: theme.secondaryBackground,
                        selectedColor: theme.buttonBackground,
                        labelStyle: theme.bodySmall.copyWith(
                            color: isSelected ? Colors.white : theme.secondaryText),
                        checkmarkColor: Colors.white,
                        shape: StadiumBorder(side: BorderSide(color: theme.alternate)),
                      ),
                    );
                  }).toList(),
                ), // End of Row
              ), // End of SingleChildScrollView
            ), // End of Padding

// End of Category Chips Section modification
            // Icon Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // Adjust number of columns
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _filteredIcons.length,
                  // Inside GridView.builder itemBuilder (around line 142)
                  itemBuilder: (context, index) {
                    final iconInfo = _filteredIcons[index];
                    final isSelected = widget.currentlySelectedId ==
                        iconInfo.id;

                    // Wrap the InkWell with Material
                    return Material(
                      color: Colors.transparent,
                      // Adjust as needed
                      borderRadius: BorderRadius.circular(8.0),
                      // Match shape if needed
                      clipBehavior: Clip.antiAlias,
                      // Often useful with borderRadius
                      child: InkWell( // InkWell is now the child of Material
                        // Inside the InkWell's onTap in the GridView itemBuilder:
                        onTap: () {
                          // CHANGE THIS LINE: Pop the IconData, not the String ID
                          Navigator.pop(context, iconInfo.iconData); // <-- Corrected line
                          // Navigator.pop(context, iconInfo.id); // <-- Old incorrect line
                        },
                        borderRadius: BorderRadius.circular(8.0),
                        // Keep for splash shape
                        child: Container( // The original Container remains the child of InkWell
                          // Important: Container color must be transparent if Material provides the color,
                          // or Material color must be transparent if Container provides the color.
                          // Here, Material is transparent, so Container sets the color.
                          decoration: BoxDecoration(
                              color: isSelected ? theme.buttonBackground
                                  .withOpacity(0.8) : theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: isSelected
                                    ? theme.buttonBackground
                                    : theme.alternate,
                                width: isSelected ? 2.0 : 1.0,
                              )
                          ),
                          child: Icon(
                            iconInfo.iconData,
                            color: isSelected ? Colors.white : theme
                                .primaryText,
                            size: 28.0,
                          ),
                        ),
                      ),
                    ); // End of Material
                  },
                ),
              ),
            ),
          ],
        ),
      ), // End of Original Container
    ); // End of Material wrapper
  }
}