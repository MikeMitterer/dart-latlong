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

/// Polygon of [LatLng] values
class Polygon {
    final Set<LatLng> _coordinates;

    Polygon() : _coordinates = new Set<LatLng>();

    Polygon.from(final Iterable<LatLng> coordinates) : _coordinates = new Set.from(coordinates) {
        Validate.notNull(coordinates);
    }

    Set<LatLng> get coordinates => _coordinates;

    void clear() => _coordinates.clear();

    bool add(final LatLng value) {
        Validate.notNull(value);
        return _coordinates.add(value);
    }

    /// Calculates the center of a collection of geo coordinates
    ///
    /// The function rounds the result to 6 decimals
    LatLng get center {
        Validate.notEmpty(coordinates,"Coordinates must not be empty!");

        double X = 0.0;
        double Y = 0.0;
        double Z = 0.0;

        double lat, lon, hyp;

        coordinates.forEach( (final LatLng coordinate) {

            lat = coordinate.latitudeInRad;
            lon = coordinate.longitudeInRad;

            X += math.cos(lat) * math.cos(lon);
            Y += math.cos(lat) * math.sin(lon);
            Z += math.sin(lat);

        });

        final int nrOfCoordinates = coordinates.length;
        X = X / nrOfCoordinates;
        Y = Y / nrOfCoordinates;
        Z = Z / nrOfCoordinates;

        lon = math.atan2(Y, X);
        hyp = math.sqrt(X * X + Y * Y);
        lat = math.atan2(Z, hyp);

        return new LatLng(round(radianToDeg(lat)),round(radianToDeg(lon)));
    }
}

