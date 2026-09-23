import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

enum LocationFetchStatus {
  success,
  servicesDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
  error,
}

class LocationResult {
  final LocationFetchStatus status;
  final double? latitude;
  final double? longitude;
  final String? errorMessage;

  const LocationResult({
    required this.status,
    this.latitude,
    this.longitude,
    this.errorMessage,
  });

  bool get isSuccess =>
      status == LocationFetchStatus.success &&
      latitude != null &&
      longitude != null;
}

/// Service handling device GPS permissions and farm coordinate acquisition.
class LocationService {
  /// Checks if location services are enabled on the device.
  Future<bool> isServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('LocationService.isServiceEnabled error: $e');
      return false;
    }
  }

  /// Requests device location permission and returns position coordinates if granted.
  Future<LocationResult> requestPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult(
          status: LocationFetchStatus.servicesDisabled,
          errorMessage:
              'Device location is turned off. Please enable GPS in device settings.',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const LocationResult(
            status: LocationFetchStatus.permissionDenied,
            errorMessage:
                'Location permission is needed for accurate local weather.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(
          status: LocationFetchStatus.permissionPermanentlyDenied,
          errorMessage:
              'Location permission is permanently denied. You can allow it in App Settings or enter your location manually.',
        );
      }

      // Permission granted: acquire coordinates with medium accuracy
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );

      return LocationResult(
        status: LocationFetchStatus.success,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('LocationService.requestPosition error: $e');
      return LocationResult(
        status: LocationFetchStatus.error,
        errorMessage: 'Could not acquire GPS position. $e',
      );
    }
  }

  /// Opens system app settings if permission was permanently denied.
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (_) {
      return false;
    }
  }
}
