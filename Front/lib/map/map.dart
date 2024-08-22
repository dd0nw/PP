// 가까운 병원 찾기
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location _location = Location();
  LatLng _initialPosition = LatLng(37.43296265331129, -122.08832357078792);
  bool _isLoading = true;
  String _locationText = 'Location: Unknown';
  String _permissionStatus = 'Permission status: Unknown';
  List<dynamic> _places = [];
  Set<Marker> _markers = {};


  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation(); // 지도 초기화 후 위치 가져오기
  }

  Future<void> _requestLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location service is enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          _isLoading = false;
          _permissionStatus = 'Location service is disabled.';
        });
        return;
      }
    }

    // Check if location permission is granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        setState(() {
          _permissionStatus = 'Location permission granted.';
        });
      } else {
        setState(() {
          _isLoading = false;
          _permissionStatus = 'Location permission denied.';
        });
        return;
      }
    } else if (_permissionGranted == PermissionStatus.granted) {
      setState(() {
        _permissionStatus = 'Location permission already granted.';
      });
    } else {
      setState(() {
        _permissionStatus = 'Location permission status: $_permissionGranted';
        _isLoading = false;
      });
      return;
    }

    // After permission is granted or already granted, try to get location
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationData _locationData = await _location.getLocation();
      setState(() {
        if (_locationData.latitude != null && _locationData.longitude != null) {
          _initialPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
          _locationText = 'Location: Lat ${_locationData.latitude}, Lng ${_locationData.longitude}';
          // 위치가 성공적으로 가져온 후 병원 목록을 가져옵니다.
          _getNearbyHospitals();
        } else {
          _locationText = 'Location: Unable to get location.';
        }
        _isLoading = false;
      });

      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _locationText = 'Error: $e';
      });
      print("Error getting location: $e");
    }
  }

  // 병원 목록을 가져오는 함수 추가
  Future<void> _getNearbyHospitals() async {
    final String url = 'http://192.168.27.113:3000/hospitals'
        '?latitude=${_initialPosition.latitude}&longitude=${_initialPosition.longitude}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>?;

        if (data != null && data.isNotEmpty) {
          setState(() {
            _places = data;
            _markers = data.map<Marker>((place) {
              final position = LatLng(
                place['geometry']['location']['lat'] ?? 0.0,
                place['geometry']['location']['lng'] ?? 0.0,
              );
              return Marker(
                markerId: MarkerId(place['place_id'] ?? ''),
                position: position,
                infoWindow: InfoWindow(
                  title: place['name'] ?? 'Unknown',
                  snippet: place['address'] ?? 'No address',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              );
            }).toSet();
          });
        } else {
          setState(() {
            _places = [];
            _markers = {};
          });
        }
      } else {
        print('Failed to fetch places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "가까운 병원 찾기",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          }, // 전페이지로 이동
        ),
        backgroundColor: Color(0xFFFFF8F9),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers, // 마커 추가
            ),
          ),
          Expanded(
            flex: 1,
            child: _places.isNotEmpty
                ? ListView.builder(
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return GestureDetector(
                  onTap: (){
                  },
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.hospital),
                    title: Text(place['name']),
                    subtitle: Text(place['address']),
                  ),
                );
              },
            )
                : Center(child: Text('No places found')),
          ),
        ],
      ),
    );
  }
}
