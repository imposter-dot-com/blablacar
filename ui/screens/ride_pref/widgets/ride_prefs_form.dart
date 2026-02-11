import 'package:blabla/ui/widgets/buttons/bla_button.dart';
import 'package:blabla/ui/widgets/inputs/bla_input_fields.dart';
import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/inputs/bla_input_fields.dart';
import '../../../../models/ride/locations.dart';
import '../../../../models/ride_pref/ride_pref.dart';
import '../../../../utils/date_time_utils.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref to prefill the form
  final RidePref? initRidePref;
  final Function(RidePref)?
  onSearch; //call back to parent when search is pressed, sends the RidePref Object
  final bool showSearchButton; //whether to display the search button

  const RidePrefForm({
    super.key,
    this.initRidePref,
    this.onSearch,
    this.showSearchButton = true,
  });

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  DateTime? departureDate;
  Location? arrival;
  int requestedSeats = 1;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      departureDate = widget.initRidePref!.departureDate;
      arrival = widget.initRidePref!.arrival;
      requestedSeats = widget.initRidePref!.requestedSeats;
    }
  }

  //check if the form is valid, all 4 fields are filled

  bool get isFormValid {
    return departure != null &&
        arrival != null &&
        departureDate != null &&
        requestedSeats > 0;
  }

  void _switchLocation() {
    setState(() {
      //swap departure and arrival locations
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void _onSearch() {
    //trigger the callback only if the form is valid
    if (isFormValid && widget.onSearch != null) {
      widget.onSearch!(
        RidePref(
          departure: departure!,
          departureDate: departureDate!,
          arrival: arrival!,
          requestedSeats: requestedSeats,
        ),
      );
    }
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BlaSpacings.m),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //departure input field with switch button on the right
          Stack(
            children: [
              BlaInputField(
                label: "Departure",
                value: departure?.name,
                icon: Icons.trip_origin,
                onTap: () {
                  print("Select departure");
                },
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: Icon(Icons.swap_vert, color: BlaColors.primary),
                  onPressed: _switchLocation,
                ),
              ),
            ],
          ),

          SizedBox(height: BlaSpacings.m),

          //arrival input field
          BlaInputField(
            label: 'Arrival',
            value: arrival?.name,
            icon: Icons.trip_origin,
            onTap: () {
              //will navigate to location picker later
              print("Select your arrival location: ");
            },
          ),

          SizedBox(height: BlaSpacings.m),

          //input field for date picker
          BlaInputField(
            label: "Date",
            value: departureDate != null
                ? DateTimeUtils.formatDateTime(departureDate!)
                : null,
            icon: Icons.calendar_today,
            onTap: () {
              //do date picker later
              print("select date");
            },
          ),

          SizedBox(height: BlaSpacings.m),

          //passenger input field
          BlaInputField(
            label: "$requestedSeats passenger${requestedSeats > 1 ? 's' : ''}",
            icon: Icons.person,
            onTap: () {
              //show seat picker later
              print("Select seats: ");
            },
          ),

          if (widget.showSearchButton) ...[
            SizedBox(height: BlaSpacings.m),
            BlaButton(
              text: 'Search',
              onPressed: isFormValid ? _onSearch : null,
            ),
          ],
        ],
      ),
    );
  }
}
