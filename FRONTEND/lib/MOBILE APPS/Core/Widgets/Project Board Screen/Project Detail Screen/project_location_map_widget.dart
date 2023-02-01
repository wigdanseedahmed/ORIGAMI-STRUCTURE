import 'package:origami_structure/imports.dart';

class ProjectLocationMapMA extends StatelessWidget {
  const ProjectLocationMapMA({
    Key? key,
    required this.context,
    required this.latitude,
    required this.longitude,
    required this.animation,
    required this.zoomPanBehavior,
  }) : super(key: key);

  final BuildContext context;
  final double latitude;
  final double longitude;
  final CurvedAnimation animation;
  final MapZoomPanBehavior zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Center(
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              initialZoomLevel: 6,
            zoomPanBehavior: zoomPanBehavior,
              initialFocalLatLng: MapLatLng(latitude, longitude),
              initialMarkersCount: 1,
              markerBuilder: (BuildContext context, int index) {
                const Icon current = Icon(Icons.location_pin, size: 40.0);
                return MapMarker(
                  latitude: latitude, //markerData.latitude,
                  longitude: longitude,//markerData.longitude,
                  child: Transform.translate(
                    offset: const Offset(0.0, -40 / 2),
                    child: ScaleTransition(
                      alignment: Alignment.bottomCenter,
                      scale: animation,
                      child: current,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
