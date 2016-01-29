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
    final List<LatLng> _coordinates;

    /// For [Distance] calculations
    final Distance _distance = const Distance();

    Path() : _coordinates = new List<LatLng>();

    Path.from(final Iterable<LatLng> coordinates) : _coordinates = new List.from(coordinates) {
        Validate.notNull(coordinates);
    }

    List<LatLng> get coordinates => _coordinates;

    void clear() => _coordinates.clear();

    void add(final LatLng value) {
        Validate.notNull(value);
        return _coordinates.add(value);
    }

    Path createIntermediateSteps(final int stepDistance) {
        Validate.isTrue(stepDistance > 1, "Distance must be greater than 1");
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

        for(int index = 0;index < coordinates.length - 1;index++) {
            final double distance = _distance(tempCoordinates[index],tempCoordinates[index + 1]);

            bearing = _distance.bearing(tempCoordinates[index],tempCoordinates[index + 1]);

            if(restSteps <= distance || (stepDistance - restSteps) <= distance) {

                double firstStepPos = stepDistance - restSteps;

                final double steps = ((distance - firstStepPos) / stepDistance) + 1;

                final int fullSteps = steps.toInt();
                restSteps = round(fullSteps > 0 ? steps % fullSteps : steps,decimals: 6) * stepDistance;

                baseStep = tempCoordinates[index];

                int stepCounter = 0;
                for(; stepCounter < fullSteps;stepCounter++) {
                    final LatLng nextStep = _distance.offset(baseStep,firstStepPos,bearing);
                    path.add(nextStep);
                    firstStepPos += stepDistance;

                    CatmullRomSpline2D<double> spline;

                    if(path.nrOfCoordinates == 3) {
                        spline = _createSpline(path[0],path[0],path[1],path[2]);

                        // Insert new point between 0 and 1
                        path.coordinates.insert(1,_pointToLatLng(spline.percentage(50)));

                    } else if(path.nrOfCoordinates > 3) {
                        final int baseIndex = path.nrOfCoordinates - 1;
                        spline = _createSpline(
                            path[baseIndex - 3],
                            path[baseIndex - 2],
                            path[baseIndex - 1],
                            path[baseIndex]);

                        // Insert new point at last position - 2 (pushes the next 2 items down)
                        path.coordinates.insert(baseIndex - 1,_pointToLatLng(spline.percentage(50)));
                    }
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

        int baseIndex = path.nrOfCoordinates - 1;
        CatmullRomSpline2D<double> spline = _createSpline(
            path[baseIndex - 3],
            path[baseIndex - 2],
            path[baseIndex - 1],
            path[baseIndex - 0]);

        path.coordinates.insert(baseIndex - 1,_pointToLatLng(spline.percentage(50)));

        if(restSteps > stepDistance / 2) {
            baseIndex = path.nrOfCoordinates - 1;
            spline = _createSpline(
                path[baseIndex - 1],path[baseIndex - 1],
                path[baseIndex - 0],path[baseIndex - 0]);

            path.coordinates.insert(baseIndex,_pointToLatLng(spline.percentage(50)));
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

    //- private -----------------------------------------------------------------------------------

    CatmullRomSpline2D<double> _createSpline(final LatLng p0,final LatLng p1,final LatLng p2,final LatLng p3) {
        Validate.notNull(p0);
        Validate.notNull(p1);
        Validate.notNull(p2);
        Validate.notNull(p3);

        return new CatmullRomSpline2D(
            new Point2D(p0.latitude,p0.longitude),
            new Point2D(p1.latitude,p1.longitude),
            new Point2D(p2.latitude,p2.longitude),
            new Point2D(p3.latitude,p3.longitude)
        );
    }

    LatLng _pointToLatLng(final Point2D point) => new LatLng(point.x,point.y);
}

