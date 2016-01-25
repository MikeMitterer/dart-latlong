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

typedef double DistanceAlgorithm(final LatLng p1, final LatLng p2);

class Distance {
    // final Logger _logger = new Logger('latlong.Compute');

    final double _radius;
    final _roundResult;

    const Distance({ final bool roundResult: true}) : _radius = EARTH_RADIUS, _roundResult = roundResult;

    Distance.withRadius(final double radius,{ final bool roundResult: true})
        : _radius = radius, _roundResult = roundResult {

        Validate.isTrue(radius > 0, "Radius must be greater than 0 but was $radius");
    }

    double get radius => _radius;

    num call(final LatLng p1, final LatLng p2) {
        return _result(distance(p1,p2));
    }

    num as(final LengthUnit unit,final LatLng p1, final LatLng p2) {
        final double dist = distance(p1,p2);
        return _result(LengthUnit.Meter.to(unit,dist));
    }

    num distance(final LatLng p1, final LatLng p2) => vincenty(p1,p2);

    double haversine(final LatLng p1, final LatLng p2) {
        final sinDLat = math.sin((p2.latitudeInRad - p1.latitudeInRad) / 2);
        final sinDLng = math.sin((p2.longitudeInRad - p1.longitudeInRad) / 2);

        // Sides
        final a = sinDLat * sinDLat + sinDLng * sinDLng * math.cos(p1.latitudeInRad) * math.cos(p2.latitudeInRad);
        final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

        return _result(_radius * c);
    }

    double vincenty(final LatLng p1, final LatLng p2) {
        double a = EARTH_RADIUS, b = 6356752.314245, f = 1 / 298.257223563; // WGS-84 ellipsoid params
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
                return _result(0.0); // co-incident points
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
            return haversine(p1,p2); // formula failed to converge
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

        return _result(dist);
    }

    //- private -----------------------------------------------------------------------------------

    double _result(final double value) => (_roundResult ? value.round() * 1.0 : value);
}
