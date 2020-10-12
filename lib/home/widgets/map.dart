import 'dart:async';

import 'package:covid_tracing/home/repo/repo.dart';
import 'package:covid_tracing/home/widgets/case_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapWidget extends StatelessWidget {
  final ScrollController scrollController;
  final PanelController panelController;
  final List<Case> cases;

  MapWidget({
    Key key,
    this.cases,
    @required this.scrollController,
    @required this.panelController,
  })  : assert(scrollController != null),
        assert(panelController != null),
        super(key: key);

  final _mapController = Completer<GoogleMapController>();
  final _kGooglePlex = CameraPosition(
    target: LatLng(-33.918200, 151.035000),
    zoom: 9,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      markers: cases != null ? _mapCasesToMarkers(context, cases) : null,
      onTap: (_) => panelController.close(),
    );
  }

  Set<Marker> _mapCasesToMarkers(BuildContext context, List<Case> cases) {
    final markers = <Marker>{};
    for (var myCase in cases) {
      markers.add(Marker(
        markerId: MarkerId(myCase.venue),
        position: myCase.latLng,
        onTap: () => CaseDialog.show(context, scrollController, myCase),
      ));
    }

    return markers;
  }
}