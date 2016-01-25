//@TestOn("content-shell")
import 'package:test/test.dart';

// import 'package:logging/logging.dart';
import 'package:latlong/latlong.dart';

import '../config.dart';

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

                expect(distance.vincenty(new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444)),422592.0);

                expect(distance(new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444)),422592.0);

                expect(distance.as(LengthUnit.Kilometer,
                    new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444)),423.0);
            });

        }); // End of 'Vincenty' group

        group('Haversine - not so accurate', () {
            test('> Test 1', () {
                final Distance distance = new Distance();

                expect(distance.haversine(new LatLng(52.518611,13.408056),new LatLng(51.519475,7.46694444)),421786.0);
            });
        }); // End of 'Haversine' group
    });
    // End of 'Distance' group
}

// - Helper --------------------------------------------------------------------------------------
