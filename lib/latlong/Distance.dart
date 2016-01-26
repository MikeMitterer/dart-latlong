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

typedef double DistanceAlgorithm(final LatLng p1, final LatLng p2, final double radius );

/// Calculates the distance between points.
///
/// Default algorithm is [distanceWithVincenty], default radius is [EARTH_RADIUS]
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
class Distance {
    // final Logger _logger = new Logger('latlong.Distance');

    final double _radius;
    final _roundResult;
    final DistanceAlgorithm _algorithm;

    const Distance({ final bool roundResult: true, final DistanceAlgorithm algorithm: distanceWithVincenty })
        : _radius = EARTH_RADIUS, _roundResult = roundResult, _algorithm = algorithm;

    Distance.withRadius(final double radius,
        { final bool roundResult: true, final DistanceAlgorithm algorithm: distanceWithVincenty})
        : _radius = radius, _roundResult = roundResult, _algorithm = algorithm {

        Validate.isTrue(radius > 0, "Radius must be greater than 0 but was $radius");
    }

    double get radius => _radius;

    /// Shortcut for [distance]
    num call(final LatLng p1, final LatLng p2) {
        return _round(_algorithm(p1,p2,_radius));
    }

    /// Converts the distance to the given [LengthUnit]
    ///
    ///     final int km = distance.as(LengthUnit.Kilometer,
    ///         new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));
    ///
    num as(final LengthUnit unit,final LatLng p1, final LatLng p2) {
        final double dist = _algorithm(p1,p2,_radius);
        return _round(LengthUnit.Meter.to(unit,dist));
    }

    /// Computes the distance between two points.
    ///
    /// The function uses the [DistanceAlgorithm] specified in the CTOR
    num distance(final LatLng p1, final LatLng p2)
        => _round(_algorithm(p1,p2,_radius));

    /// Returns the great circle bearing (direction) in degrees to the next point ([p2])
    ///
    /// Find out about the difference between rhumb line and
    /// great circle bearing on [Wikipedia](http://en.wikipedia.org/wiki/Rhumb_line#General_and_mathematical_description).
    ///
    ///     final Distance distance = const Distance();
    ///
    ///     final LatLng p1 = new LatLng(0.0, 0.0);
    ///     final LatLng p2 = new LatLng(-90.0, 0.0);
    ///
    ///     expect(distance.direction(p1, p2), equals(180));
    double bearing(final LatLng p1, final LatLng p2) {
        final diffLongitude = p2.longitudeInRad - p1.longitudeInRad;

        final y = math.sin(diffLongitude) * math.cos(p2.latitudeInRad);
        final x = math.cos(p1.latitudeInRad) * math.sin(p2.latitudeInRad) -
            math.sin(p1.latitudeInRad) * math.cos(p2.latitudeInRad) * math.cos(diffLongitude);

        return radianToDeg(math.atan2(y, x));
    }

    /// Returns a destination point based on the given [distance] and [bearing]
    ///
    /// Given a [from] (start) point, initial [bearing], and [distance],
    /// this will calculate the destination point and
    /// final bearing travelling along a (shortest distance) great circle arc.
    ///
    ///     final Distance distance = const Distance();
    ///
    ///     final num distanceInMeter = (EARTH_RADIUS * math.PI / 4).round();
    ///
    ///     final p1 = new LatLng(0.0, 0.0);
    ///     final p2 = distance.offset(p1, distanceInMeter, 180);
    ///
    LatLng offset(final LatLng from,final num distanceInMeter,final num bearing,{ final double radius: EARTH_RADIUS }) {
        Validate.inclusiveBetween(-180.0,180.0,bearing,"Bearing must be between -180 and 180 degrees but was $bearing");

        final double h = degToRadian(bearing.toDouble());

        final double a = distanceInMeter / radius;

        final double lat2 = math.asin(math.sin(from.latitudeInRad) * math.cos(a) +
            math.cos(from.latitudeInRad) * math.sin(a) * math.cos(h) );

        final double lng2 = from.longitudeInRad +
            math.atan2(math.sin(h) * math.sin(a) * math.cos(from.latitudeInRad),
                math.cos(a) - math.sin(from.latitudeInRad) * math.sin(lat2));

        return new LatLng(radianToDeg(lat2), radianToDeg(lng2));
    }

    /// Calculates the length of a given path
    num pathLength(final List<LatLng> coordinates) {
        Validate.notNull(coordinates);

        double length = 0.0;

        for(int index = 0;index < coordinates.length - 1;index++) {
            length += distance(coordinates[index],coordinates[index + 1]);
        }
        return _round(length);
    }

    //- private -----------------------------------------------------------------------------------

    double _round(final double value) => (_roundResult ? value.round().toDouble() : value);
}

/// Calculates distance with Haversine algorithm.
///
/// Accuracy can be out by 0.3%
/// More on [Wikipedia](https://en.wikipedia.org/wiki/Haversine_formula)
double distanceWithHaversine(final LatLng p1, final LatLng p2, final double radius) {
    final sinDLat = math.sin((p2.latitudeInRad - p1.latitudeInRad) / 2);
    final sinDLng = math.sin((p2.longitudeInRad - p1.longitudeInRad) / 2);

    // Sides
    final a = sinDLat * sinDLat + sinDLng * sinDLng * math.cos(p1.latitudeInRad) * math.cos(p2.latitudeInRad);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return radius * c;
}

/// Calculates distance with Vincenty algorithm.
///
/// Accuracy is about 0.5mm
/// More on [Wikipedia](https://en.wikipedia.org/wiki/Vincenty%27s_formulae)
double distanceWithVincenty(final LatLng p1, final LatLng p2,final double radius) {
    double a = radius, b = 6356752.314245, f = 1 / 298.257223563; // WGS-84 ellipsoid params
    double L = p2.longitudeInRad - p1.longitudeInRad;
    double U1 = math.atan((1 - f) * math.tan(p1.latitudeInRad));
    double U2 = math.atan((1 - f) * math.tan(p2.latitudeInRad));
    double sinU1 = math.sin(U1), cosU1 = math.cos(U1);
    double sinU2 = math.sin(U2), cosU2 = math.cos(U2);

    double sinLambda, cosLambda, sinSigma, cosSigma, sigma, sinAlpha, cosSqAlpha, cos2SigmaM;
    double lambda = L, lambdaP;
    int maxIterations = 100;

    do {
        sinLambda = math.sin(lambda);
        cosLambda = math.cos(lambda);
        sinSigma = math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda)
            + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));

        if (sinSigma == 0) {
            return 0.0; // co-incident points
        }

        cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
        sigma = math.atan2(sinSigma, cosSigma);
        sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
        cosSqAlpha = 1 - sinAlpha * sinAlpha;
        cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;

        if (cos2SigmaM.isNaN) {
            cos2SigmaM = 0.0; // equatorial line: cosSqAlpha=0 (§6)
        }

        double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
        lambdaP = lambda;
        lambda = L + (1 - C) * f * sinAlpha
            * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));

    } while ((lambda - lambdaP).abs() > 1e-12 && --maxIterations > 0);

    if (maxIterations == 0) {
        return distanceWithHaversine(p1,p2, a); // formula failed to converge
    }

    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
    double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    double deltaSigma = B
        * sinSigma
        * (cos2SigmaM + B
            / 4
            * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM
                * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));

    double dist = b * A * (sigma - deltaSigma);

    return dist;
}