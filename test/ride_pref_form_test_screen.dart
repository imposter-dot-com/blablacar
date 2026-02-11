import 'package:flutter/material.dart';
import '../../../models/ride_pref/ride_pref.dart';
import '../../../models/ride/locations.dart';
import '../ui/theme/theme.dart';
import '../ui/screens/ride_pref/widgets/ride_prefs_form.dart';

class RidePrefFormTestScreen extends StatefulWidget {
  const RidePrefFormTestScreen({super.key});

  @override
  State<RidePrefFormTestScreen> createState() => _RidePrefFormTestScreenState();
}

class _RidePrefFormTestScreenState extends State<RidePrefFormTestScreen> {
  RidePref? _lastSearchedPref;
  String _testScenario = 'Empty Form';

  // Test data
  final RidePref _samplePref = RidePref(
    departure: Location(name: "London", country: Country.uk),
    departureDate: DateTime.now().add(Duration(days: 2)),
    arrival: Location(name: "Paris", country: Country.france),
    requestedSeats: 2,
  );

  void _onSearch(RidePref pref) {
    setState(() {
      _lastSearchedPref = pref;
    });
    
    // Show a snackbar with the search result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Searched: ${pref.departure.name} → ${pref.arrival.name}, '
          '${pref.requestedSeats} seat(s)',
        ),
        backgroundColor: BlaColors.primary,
      ),
    );
  }

  Widget _buildTestScenarioSelector() {
    return Container(
      padding: EdgeInsets.all(BlaSpacings.m),
      color: BlaColors.backgroundAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Scenario',
            style: BlaTextStyles.heading.copyWith(fontSize: 18),
          ),
          SizedBox(height: BlaSpacings.s),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text('Empty Form'),
                selected: _testScenario == 'Empty Form',
                onSelected: (selected) {
                  if (selected) setState(() => _testScenario = 'Empty Form');
                },
              ),
              ChoiceChip(
                label: Text('Pre-filled'),
                selected: _testScenario == 'Pre-filled',
                onSelected: (selected) {
                  if (selected) setState(() => _testScenario = 'Pre-filled');
                },
              ),
              ChoiceChip(
                label: Text('No Search Button'),
                selected: _testScenario == 'No Search Button',
                onSelected: (selected) {
                  if (selected) setState(() => _testScenario = 'No Search Button');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastSearchResult() {
    if (_lastSearchedPref == null) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(BlaSpacings.m),
      padding: EdgeInsets.all(BlaSpacings.m),
      decoration: BoxDecoration(
        color: BlaColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
        border: Border.all(color: BlaColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: BlaColors.primary),
              SizedBox(width: BlaSpacings.s),
              Text(
                'Last Search Result',
                style: BlaTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: BlaColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: BlaSpacings.s),
          Text(
            _lastSearchedPref.toString(),
            style: BlaTextStyles.label.copyWith(color: BlaColors.textNormal),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer(Widget form) {
    return Container(
      margin: EdgeInsets.all(BlaSpacings.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: form,
    );
  }

  Widget _buildForm() {
    switch (_testScenario) {
      case 'Pre-filled':
        return _buildFormContainer(
          RidePrefForm(
            initRidePref: _samplePref,
            onSearch: _onSearch,
          ),
        );
      
      case 'No Search Button':
        return _buildFormContainer(
          Column(
            children: [
              RidePrefForm(
                onSearch: _onSearch,
                showSearchButton: false,
              ),
              Padding(
                padding: EdgeInsets.all(BlaSpacings.m),
                child: Text(
                  '↑ Form without search button (for modal usage)',
                  style: BlaTextStyles.label.copyWith(
                    color: BlaColors.textLight,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      
      case 'Empty Form':
      default:
        return _buildFormContainer(
          RidePrefForm(
            onSearch: _onSearch,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Pref Form Test'),
        backgroundColor: Colors.white,
        foregroundColor: BlaColors.textNormal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTestScenarioSelector(),
            SizedBox(height: BlaSpacings.m),
            _buildLastSearchResult(),
            _buildForm(),
            SizedBox(height: BlaSpacings.m),
            
            // Instructions
            Container(
              margin: EdgeInsets.all(BlaSpacings.m),
              padding: EdgeInsets.all(BlaSpacings.m),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(BlaSpacings.radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Instructions:',
                    style: BlaTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: BlaSpacings.s),
                  Text(
                    '1. Try filling all fields and clicking Search\n'
                    '2. Try the switch location button (↕)\n'
                    '3. Test with empty fields (button should be disabled)\n'
                    '4. Test pre-filled scenario\n'
                    '5. Test without search button (for modal usage)',
                    style: BlaTextStyles.label,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}