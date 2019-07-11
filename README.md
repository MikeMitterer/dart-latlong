# DEPRECATED

---
# This package will not be maintained anymore!
The whole thing landed on **TypeScript**  

Check out the lib on [npmjs](https://www.npmjs.com/package/@mmit/latlong)

---
## LatLong provides a lightweight library for common latitude and longitude calculation.
This library supports both, the "Haversine" and the "Vincenty" algorithm.

"Haversine" is a bit faster but "Vincenty" is far more accurate!
 
<p align="center"> 
    <img alt="LatLong" src="https://github.com/MikeMitterer/dart-latlong/raw/master/doc/images/latlong.jpg"> 
</p>

[Catmull-Rom algorithm](http://hawkesy.blogspot.co.at/2010/05/catmull-rom-spline-curve-implementation.html) is used for smoothing out the path.
 
## Basic usage 

### Distance
```dart
    final Distance distance = new Distance();
    
    // km = 423
    final int km = distance.as(LengthUnit.Kilometer,
     new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444));
    
    // meter = 422591.551
    final int meter = distance(
        new LatLng(52.518611,13.408056),
        new LatLng(51.519475,7.46694444)
        );

```

## Offset
```dart
    final Distance distance = const Distance();
    final num distanceInMeter = (EARTH_RADIUS * math.PI / 4).round();
    
    final p1 = new LatLng(0.0, 0.0);
    final p2 = distance.offset(p1, distanceInMeter, 180);
    
    // LatLng(latitude:-45.219848, longitude:0.0)
    print(p2.round());
    
    // 45° 13' 11.45" S, 0° 0' 0.00" O
    print(p2.toSexagesimal());
            
```

## Path smoothing
```dart
    // zigzag is a list of coordinates
    final Path path = new Path.from(zigzag);
    
    // Result is below
    final Path steps = path.equalize(8,smoothPath: true);
```
<p align="center"> 
    <img alt="Smooth path" src="https://github.com/MikeMitterer/dart-latlong/raw/master/doc/images/smooth-path.jpg">
</p>

## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/MikeMitterer/dart-latlong/issues).

## License

    Copyright 2015 Michael Mitterer (office@mikemitterer.at),
    IT-Consulting and Development Limited, Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
    either express or implied. See the License for the specific language
    governing permissions and limitations under the License.


If this plugin is helpful for you - please [(Circle)](http://gplus.mikemitterer.at/) me
or **star** this repo here on GitHub
