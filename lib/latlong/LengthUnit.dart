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

class LengthUnit {
    static const LengthUnit Millimeter = const LengthUnit(1000.0);
    static const LengthUnit Centimeter = const LengthUnit(100.0);
    static const LengthUnit Meter = const LengthUnit(1.0);
    static const LengthUnit Kilometer = const LengthUnit(0.001);
    static const LengthUnit Mile = const LengthUnit(0.0006213712);

    final double scaleFactor;

    const LengthUnit(this.scaleFactor);

    double to(final LengthUnit unit,final num value) {
        if(unit.scaleFactor == scaleFactor) {
            return value;
        }

        // Convert to primary unit.
        final double primaryValue = value / scaleFactor;

        // Convert to destination unit.
        return primaryValue * unit.scaleFactor;
    }
}

