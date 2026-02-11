import 'package:flutter/material.dart';
import '../../../models/ride/locations.dart';
import '../../../services/location_service.dart';
import '../../theme/theme.dart';

class LocationPickerScreen extends StatefulWidget{
  final String title;
  final Location? initialLocation;

  const LocationPickerScreen({
    super.key,
    this.title = "Select location",
    this.initialLocation,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen>{
  final TextEditingController _searchController = TextEditingController();
  List<Location> _filteredLocations = [];

  @override
  void initState(){
    super.initState();
    _searchController.addListener(_filterLocations);
  }

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  void _filterLocations(){
    final query = _searchController.text.toLowerCase();
    setState(() {
      if(query.isEmpty){
        _filteredLocations = [];
      }else{
        _filteredLocations = LocationsService.availableLocations.where((location) => location.name.toLowerCase().contains(query) || location.country.name.toLowerCase().contains(query)).toList();
      }
    });
  }

  void _selectedLocation(Location location){
    Navigator.pop(context, location);
  }

  void _clearSearch(){
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: BlaColors.textNormal,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(BlaSpacings.m),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:  'Search location',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty ? IconButton(onPressed: _clearSearch, icon: Icon(Icons.clear)) : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BlaSpacings.radius),
                  borderSide: BorderSide(color: BlaColors.greyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BlaSpacings.radius),
                  borderSide: BorderSide(color: BlaColors.primary, width: 2),
                )
              ),
            )
          ),

          Expanded(
            child: _filteredLocations.isEmpty ?
          Center(
            child: Text('No location found', style: BlaTextStyles.body.copyWith(
              color: BlaColors.textLight,
            ),
            ),
          ) : ListView.builder(
            itemCount: _filteredLocations.length,
            itemBuilder: (context, index) {
              final location = _filteredLocations[index];
              final isSelected = widget.initialLocation == location;

              return ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: isSelected ? BlaColors.primary : BlaColors.iconLight,
                ),

                title: Text(
                  location.name,
                  style: BlaTextStyles.body.copyWith(
                    color: isSelected ? BlaColors.primary : BlaColors.textNormal,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                subtitle: Text(
                  location.country.name,
                  style: BlaTextStyles.label.copyWith(
                    color: BlaColors.textLight,
                  ),
                ),
                trailing: isSelected ? Icon(Icons.check, color: BlaColors.primary) : null,
                onTap: () => {
                  _selectedLocation(location),
                }
              );
            })
          ) 
        ],
      ),
    );
  }
}
