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
     
part of latlong;

/// Coordinates in Degrees
///
///     final Location location = new Location(10.000002,12.00001);
///
class LatLng {
    // final Logger _logger = new Logger('latlong.LatLng');

    double _latitude;
    double _longitude;

    LatLng(this._latitude, this._longitude) {
        Validate.inclusiveBetween(-90.0,90.0,_latitude,"Latitude must be between -90 and 90 degrees but was $_latitude");
        Validate.inclusiveBetween(-180.0,180.0,_longitude,"Longitude must be between -90 and 90 degrees but was $_longitude");
    }

    void set latitude(final double value) {
        Validate.inclusiveBetween(-90.0,90.0,_latitude,"Latitude must be between -90 and 90 degrees but was $_latitude");
        _latitude = value;
    }
    double get latitude => _latitude;

    void set longitude(final double value) {
        Validate.inclusiveBetween(-180.0,180.0,_longitude,"Longitude must be between -90 and 90 degrees but was $_longitude");
        _longitude = value;
    }
    double get longitude => _longitude;

    double get latitudeInRad => degToRadian(latitude);

    double get longitudeInRad => degToRadian(_longitude);

    String toString() => 'LatLng(latitude:$latitude, longitude:$longitude)';

    /// Converts lat/long values into sexagesimal
    ///
    ///     final LatLng p1 = new LatLng(51.519475, -19.37555556);
    ///
    ///     // Shows: 51° 31' 10.11" N, 19° 22' 32.00" W
    ///     print(p1..toSexagesimal());
    ///
    String toSexagesimal() {
        String latDirection = latitude >= 0 ? "N" : "S";
        String lonDirection = longitude >= 0 ? "O" : "W";
        return "${decimal2sexagesimal(latitude)} ${latDirection}, ${decimal2sexagesimal(longitude)} ${lonDirection}";
    }

    int get hashCode => latitude.hashCode + longitude.hashCode;

    bool operator==(final Object other)
        => other is LatLng && latitude == other.latitude && longitude == other.longitude;

    LatLng round({ final int decimals: 6 })
        => new LatLng(_round(latitude,decimals: decimals), _round(longitude,decimals: decimals));

    //- private -----------------------------------------------------------------------------------

    /// No qualifier for top level functions in Dart. Had to copy this function
    double _round(final double value, { final int decimals: 6 })
        => (value * math.pow(10,decimals)).round() / math.pow(10,decimals);
}
