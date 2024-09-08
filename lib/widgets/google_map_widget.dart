import 'dart:convert'; // for jsonDecode
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // for making API calls
import 'package:lost_property/models/post_model.dart';
import 'package:lost_property/widgets/custom_loading.dart';
import '../globals/colors.dart';

class GoogleMapWidget extends StatefulWidget {
  final PostModel post;
  const GoogleMapWidget({
    super.key,
    required this.post,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;
  LatLng? _center; // 中心點初始為 null
  bool _isLoading = true; // 控制進度條顯示
  Marker? _marker; // 用來顯示紅色標記
  // final LatLng _center = const LatLng(25.0330, 121.5654); // 台北101座標

  @override
  void initState() {
    super.initState();
    _getCoordinatesFromAddress(widget.post.lostLocation); // 根據地址取得經緯度
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // 呼叫 Geocoding API 將地址轉換為經緯度
  Future<void> _getCoordinatesFromAddress(String address) async {
    const apiKey =
        'AIzaSyAMbmNNct9nSHK4WRT8CDempAeDJmtbLVE'; // 你的 Google Maps API 金鑰
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          setState(() {
            _center = LatLng(location['lat'], location['lng']);
            _isLoading = false; // 地圖加載完成
            _marker = Marker(
              markerId: MarkerId('lost_location'),
              position: _center!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed), // 紅色標記
            );
          });
        }
      } else {
        throw Exception('Failed to load geocoding data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 342,
      width: 342,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: grey50,
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: _isLoading
              ? const CustomLoadong()
              : Image.asset("assets/map.png", fit: BoxFit.cover)
          // : GoogleMap(
          //     onMapCreated: _onMapCreated,
          //     initialCameraPosition: CameraPosition(
          //       target: _center ?? LatLng(0, 0), // 如果無法取得經緯度，顯示預設位置
          //       zoom: 15.0,
          //     ),
          //     markers: _marker != null ? {_marker!} : {}, // 顯示紅色標記
          //   ),
          ),
    );
  }
}
