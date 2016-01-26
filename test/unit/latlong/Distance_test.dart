//@TestOn("content-shell")
import 'package:test/test.dart';
import 'dart:math' as math;

// import 'package:logging/logging.dart';
import 'package:latlong/latlong.dart';

import '../config.dart';

final List<LatLng> polygon = <LatLng>[
    new LatLng( 51.513357512,7.45574331),
    new LatLng( 51.515400598,7.45518541),
    new LatLng( 51.516241842,7.456494328),
    new LatLng( 51.516722545,7.459863183),
    new LatLng( 51.517443592,7.463232037),
    new LatLng( 51.5177507,7.464755532),
    new LatLng( 51.517657233,7.466622349),
    new LatLng( 51.51722995,7.468317505),
    new LatLng( 51.516816015,7.47011995),
    new LatLng( 51.516308606,7.471793648),
    new LatLng( 51.515974782,7.472437378),
    new LatLng( 51.515413951,7.472845074),
    new LatLng( 51.514559338,7.472909447),
    new LatLng( 51.512195717,7.472651955),
    new LatLng( 51.511127373,7.47140741),
    new LatLng( 51.51029939,7.469948288),
    new LatLng( 51.509831973,7.468446251),
    new LatLng( 51.509978876,7.462481019),
    new LatLng( 51.510913701,7.460678574),
    new LatLng( 51.511594777,7.459434029),
    new LatLng( 51.512396029,7.457695958),
    new LatLng( 51.513317451,7.45574331),
];

main() {
    // final Logger _logger = new Logger("test.Compute");
    configLogging();

    group('Distance', () {
        setUp(() { });

        test('> Radius', () {
            expect((new Distance()).radius, EARTH_RADIUS);
            expect((new Distance.withRadius(100.0)).radius, 100.0);
        }); // end of 'Radius' test

        test('> Distance to the same point is 0', () {
            final Distance compute = new Distance();
            final LatLng p = new LatLng(0.0, 0.0);

            expect(compute.distance(p, p), equals(0));
        }); // end of 'Simple distance' test

        test('> Distance between 0 and 90.0 is around 10.000km', () {
            final Distance distance = new Distance();
            final LatLng p1 = new LatLng(0.0, 0.0);
            final LatLng p2 = new LatLng(90.0, 0.0);

            // no rounding
            expect(distance(p1, p2) ~/ 1000 , equals(10001));

            expect(LengthUnit.Meter.to(LengthUnit.Kilometer,distance(p1, p2)).round(), equals(10002));

            // rounds to 10002
            expect(distance.as(LengthUnit.Kilometer,p1, p2), equals(10002));
            expect(distance.as(LengthUnit.Meter,p1, p2), equals(10001966));

        }); // end of 'Distance between 0 and 90.0' test

        test('> Distance between 0 and 90.0 is 10001.96572931165 km ', () {
            final Distance distance = new Distance(roundResult: false);
            final LatLng p1 = new LatLng(0.0, 0.0);
            final LatLng p2 = new LatLng(90.0, 0.0);

            expect(distance.as(LengthUnit.Kilometer,p1, p2), equals(10001.96572931165));
        }); // end of 'Round' test

        test('> distance between 0,-180 and 0,180 is 0', () {
            final Distance distance = new Distance();
            final LatLng p1 = new LatLng(0.0, -180.0);
            final LatLng p2 = new LatLng(0.0, 180.0);

            expect(distance(p1, p2), 0);

        }); // end of 'distance between 0,-180 and 0,180 is 0' test

        group('Vincenty', () {
            test('> Test 1', () {
                final Distance distance = new Distance();

                expect(distance(new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444)),422592);

                expect(distance.as(LengthUnit.Kilometer,
                    new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444)),423);
            });

        }); // End of 'Vincenty' group

        group('Haversine - not so accurate', () {
            test('> Test 1', () {
                final Distance distance = new Distance(algorithm: distanceWithHaversine);

                expect(distance(new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444)),421786.0);
            });
        }); // End of 'Haversine' group
    });
    // End of 'Distance' group

    group('Bearing', () {


        test('bearing to the same point is 0 degree',(){
            final Distance distance = const Distance();
            final LatLng p = new LatLng(0.0, 0.0);
            expect(distance.bearing(p, p), equals(0));
        });

        test('bearing between 0,0 and 90,0 is 0 degree',(){
            final Distance distance = const Distance();
            final LatLng p1 = new LatLng(0.0, 0.0);
            final LatLng p2 = new LatLng(90.0, 0.0);
            expect(distance.bearing(p1, p2), equals(0));
        });

        test('bearing between 0,0 and -90,0 is 180 degree',(){
            final Distance distance = const Distance();
            final LatLng p1 = new LatLng(0.0, 0.0);
            final LatLng p2 = new LatLng(-90.0, 0.0);
            expect(distance.bearing(p1, p2), equals(180));
        });

        test('bearing between 0,-90 and 0,90 is -90 degree',(){
            final Distance distance = const Distance();
            final LatLng p1 = new LatLng(0.0, -90.0);
            final LatLng p2 = new LatLng(0.0, 90.0);
            expect(distance.bearing(p1, p2), equals(90));
        });

        test('bearing between 0,-180 and 0,180 is -90 degree',(){
            final Distance distance = const Distance();
            final LatLng p1 = new LatLng(0.0, -180.0);
            final LatLng p2 = new LatLng(0.0, 180.0);

            expect(distance.bearing(p1, p2), equals(-90));
            expect(normalizeBearing(distance.bearing(p1, p2)), equals(270));

        });

    }); // End of 'Direction' group

    group('Offset', () {
        test('offset from 0,0 with bearing 0 and distance ~ 10.000 km is 90,0',(){
            final Distance distance = const Distance();

            final num distanceInMeter = (EARTH_RADIUS * math.PI / 2).round();
            final num bearing = 0;

            final p1 = new LatLng(0.0, 0.0);
            final p2 = distance.offset(p1, distanceInMeter.round(), bearing);

            expect(p2.latitude.round(), equals(90));
            expect(p2.longitude.round(), equals(0));

            decimal2sexagesimal(3.25);
        });

        test('offset from 0,0 with bearing 180 and distance ~ 5.000 km is -45,0',(){
            final Distance distance = const Distance();
            final num distanceInMeter = (EARTH_RADIUS * math.PI / 4).round();

            final p1 = new LatLng(0.0, 0.0);
            final p2 = distance.offset(p1, distanceInMeter, 180);
            expect(p2.latitude.round(), equals(-45));
            expect(p2.longitude.round(), equals(0));
        });

        test('offset from 0,0 with bearing 180 and distance ~ 10.000 km is -90,0',(){
            final Distance distance = const Distance();
            final num distanceInMeter = (EARTH_RADIUS * math.PI / 2).round();

            final p1 = new LatLng(0.0, 0.0);
            final p2 = distance.offset(p1, distanceInMeter, 180);

            expect(p2.latitude.round(), equals(-90));
            expect(p2.longitude.round(), equals(0));
        });

        test('offset from 0,0 with bearing 90 and distance ~ 5.000 km is 0,45',(){
            final Distance distance = const Distance();
            final num distanceInMeter = (EARTH_RADIUS * math.PI / 4).round();

            final p1 = new LatLng(0.0, 0.0);
            final p2 = distance.offset(p1, distanceInMeter, 90);

            expect(p2.latitude.round(), equals(0));
            expect(p2.longitude.round(), equals(45));
        });
    }); // End of 'Offset' group

    group('PathLength', () {

        test('> Distance of empty path should be 0', () {
            final Distance distance = const Distance();

            expect(distance.pathLength([]),0);
        }); // end of 'Distance of empty path should be 0' test

        test('> Path length should be 3377m', () {
            final Distance distance = const Distance();

            expect(distance.pathLength(polygon),3377);

        }); // end of 'Path length should be 3377m' test

        test('> Path lenght should be 3.377km', () {
            final Distance distance = const Distance();

            expect(round(
                LengthUnit.Meter.to(LengthUnit.Kilometer,distance.pathLength(polygon)),decimals:3)
                    ,3.377);

        }); // end of 'Path length should be 3.377km' test

    }); // End of 'PathLength' group
}

// - Helper --------------------------------------------------------------------------------------
