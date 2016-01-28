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

/// Path of [LatLng] values
class Path {
    /// Coordinates managed by this class
    final Set<LatLng> _coordinates;

    /// For [Distance] calculations
    final Distance _distance = const Distance();

    Path() : _coordinates = new Set<LatLng>();

    Path.from(final Iterable<LatLng> coordinates) : _coordinates = new Set.from(coordinates) {
        Validate.notNull(coordinates);
    }

    Set<LatLng> get coordinates => _coordinates;

    void clear() => _coordinates.clear();

    bool add(final LatLng value) {
        Validate.notNull(value);
        return _coordinates.add(value);
    }

    Path createIntermediateSteps(final int stepDistance) {
        Validate.isTrue(stepDistance > 0, "Distance must be greater than 0");
        Validate.isTrue(_coordinates.length >= 2,"At least 2 coordinates are needed to create the steps in between");

        final double baseLength = length;
        Validate.isTrue(baseLength >= stepDistance,
            "Path distance must be at least ${stepDistance}mn (step distance) but was ${baseLength}");

        // no steps possible - so return an empty path
        if(baseLength == stepDistance) {
            return new Path.from([ _coordinates.first, _coordinates.last ]);
        }

        final List<LatLng> tempCoordinates = new List.from(_coordinates);
        final Path path = new Path();

        double restSteps = 0.0;
        double bearing;

        path.add(tempCoordinates.first);
        LatLng baseStep = tempCoordinates.first;

        CatmullRomSpline2D<double> _createSpline(final int index) {
            if(index == 0) {
                return new CatmullRomSpline2D.noEndpoints(
                    new Point2D(tempCoordinates[0].latitude,tempCoordinates[0].longitude),
                    new Point2D(tempCoordinates[1].latitude,tempCoordinates[1].longitude));

            } else if(index >= tempCoordinates.length - 2) {
                return new CatmullRomSpline2D.noEndpoints(
                    new Point2D(tempCoordinates[index - 1].latitude,tempCoordinates[index - 1].longitude),
                    new Point2D(tempCoordinates.last.latitude,tempCoordinates.last.longitude));
            }
            return new CatmullRomSpline2D(
                new Point2D(tempCoordinates[index - 1].latitude,tempCoordinates[index - 1].longitude),
                new Point2D(tempCoordinates[index].latitude,tempCoordinates[index].longitude),
                new Point2D(tempCoordinates[index + 1].latitude,tempCoordinates[index + 1].longitude),
                new Point2D(tempCoordinates[index + 2].latitude,tempCoordinates[index + 2].longitude)
            );
        }

        for(int index = 0;index < coordinates.length - 1;index++) {
            final double distance = _distance(tempCoordinates[index],tempCoordinates[index + 1]);
            CatmullRomSpline2D<double> spline = _createSpline(index);

            bearing = _distance.bearing(tempCoordinates[index],tempCoordinates[index + 1]);

            if(restSteps <= distance || (stepDistance - restSteps) <= distance) {

                double firstStepPos = stepDistance - restSteps;

                final double steps = ((distance - firstStepPos) / stepDistance) + 1;

                final int fullSteps = steps.toInt();
                restSteps = round(fullSteps > 0 ? steps % fullSteps : steps,decimals: 6) * stepDistance;

                baseStep = tempCoordinates[index];
                int stepCounter = 0;
                for(; stepCounter < fullSteps;stepCounter++) {
    //                final double percent = firstStep * 100 / distance;
    //
    //                if(percent > 100.0) {
    //                    restSteps += ((percent - 100) / 100) * stepDistance;
    //                    continue;
    //                }

                    //final Point2D<double> point = spline.percentage(percent);

                    final LatLng nextStep = _distance.offset(baseStep,firstStepPos,bearing);
                    //final LatLng nextStep = new LatLng(point.x,point.y);
                    path.add(nextStep);
                    //baseStep = nextStep;

                    firstStepPos += stepDistance;
                }

            } else {
                restSteps += distance;
            }

        }

        // If last step is on the same position as the last generated step
        // then don't add the last base step.
        if(baseStep.round() != tempCoordinates.last.round()) {
            path.add(tempCoordinates.last);
        }
        return path;
    }

    /// Sums up all the distances on the path
    ///
    ///     final Path path = new Path.from(route);
    ///     print(path.length);
    ///
    num get length {
        final List<LatLng> tempCoordinates = new List.from(_coordinates);
        double length = 0.0;

        for(int index = 0;index < coordinates.length - 1;index++) {
            length += _distance(tempCoordinates[index],tempCoordinates[index + 1]);
        }
        return round(length);
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

    /// Returns the number of coordinates
    ///
    ///     final Path path = new Path.from(<LatLng>[ startPos,endPos ]);
    ///     final int nr = path.nrOfCoordinates; // nr == 2
    ///
    int get nrOfCoordinates => _coordinates.length;

    /// Returns the [LatLng] coordinate form [index]
    ///
    ///     final Path path = new Path.from(<LatLng>[ startPos,endPos ]);
    ///     final LatLng p1 = path[0]; // p1 == startPos
    ///
    LatLng operator[](final int index) => _coordinates.elementAt(index);
}

