/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Helps with latitude / longitude calculations.
///
/// For distance calculations the default algorithm [Vincenty] is used.
/// [Vincenty] is a bit slower than [Haversine] but fare more accurate!
///
///      final Distance distance = new Distance();
///
///      // km = 423
///      final int km = distance.as(LengthUnit.Kilometer,
///         new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));
///
///      // meter = 422592
///      final int meter = distance(new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));
///
/// Find more infos on [Movable Type Scripts](http://www.movable-type.co.uk/scripts/latlong.html)
/// and [Movable Type Scripts - Vincenty](http://www.movable-type.co.uk/scripts/latlong-vincenty.html)
///
/// ![LatLong](http://eogn.com/images/newsletter/2014/Latitude-and-longitude.png)
///
/// ![Map](http://www.isobudgets.com/wp-content/uploads/2014/03/latitude-longitude.jpg)
///
library latlong;

import 'dart:math' as math;

import 'package:latlong/spline.dart';
import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

part "latlong/interfaces.dart";

part 'latlong/calculator/Haversine.dart';
part 'latlong/calculator/Vincenty.dart';

part "latlong/Distance.dart";
part "latlong/LatLng.dart";
part "latlong/LengthUnit.dart";

part "latlong/Path.dart";
part "latlong/Circle.dart";

/// Equator radius in meter (WGS84 ellipsoid)
const double EQUATOR_RADIUS = 6378137.0;

/// Polar radius in meter (WGS84 ellipsoid)
const double POLAR_RADIUS = 6356752.314245;

/// WGS84
const double FLATTENING = 1 / 298.257223563;

/// Earth radius in meter
const double EARTH_RADIUS = EQUATOR_RADIUS;

/// Converts degree to radian
double degToRadian(final double deg) => deg * (math.PI / 180.0);

/// Radian to degree
double radianToDeg(final double rad) => rad * (180.0 / math.PI);

/// Rounds [value] to given number of [decimals]
double round(final double value, { final int decimals: 6 })
    => (value * math.pow(10,decimals)).round() / math.pow(10,decimals);

/// Convert a bearing to be within the 0 to +360 degrees range.
/// Compass bearing is in the rangen 0° ... 360°
double normalizeBearing(final double bearing) => (bearing + 360) % 360;

/// Converts a decimal coordinate value to sexagesimal format
///
///     final String sexa1 = decimal2sexagesimal(51.519475);
///     expect(sexa1, '51° 31\' 10.11"');
///
String decimal2sexagesimal(final double dec) {
    List<int> _split(final double value) {
        final List<String> tmp = round(value,decimals: 10).toString().split('.');
        return <int>[ int.parse(tmp[0]).abs(), int.parse(tmp[1])];
    }

    final List<int> parts = _split(dec);
    final int integerPart = parts[0];
    final int fractionalPart = parts[1];

    final int deg = integerPart;
    final double min = double.parse("0.${fractionalPart}") * 60;

    final List<int> minParts = _split(min);
    final int minFractionalPart = minParts[1];

    final double sec = (double.parse("0.${minFractionalPart}") * 60);

    return "${deg}° ${min.floor()}' ${round(sec,decimals: 2).toStringAsFixed(2)}\"";
}
