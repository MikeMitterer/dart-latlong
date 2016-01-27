//@TestOn("content-shell")
import 'package:test/test.dart';

import 'package:latlong/latlong.dart';
// import 'package:logging/logging.dart';

import '../config.dart';

main() {
    // final Logger _logger = new Logger("test.Circle");
    
    configLogging();

    final LatLng base = new LatLng(0.0,0.0);

    final Distance distance = const Distance();
    
    final Circle circle = new Circle(base, 1000.0);

    final Distance distanceHaversine = const DistanceHaversine();
    final Circle circleHaversine = new Circle(base, 1000.0,calculator: const Haversine());

    group('Circle with Vincenty', () {
        setUp(() { });

        test('> isInside - distance from 0.0,0.0 to 1.0,0.0 is 110574 meter (based on Vincenty)', () {
            final Circle circle = new Circle(new LatLng(0.0,0.0), 110574.0);
            final LatLng newPos = new LatLng(1.0,0.0);

            // final double dist = new Distance().distance(circle.center,newPos);
            // print(dist);

            expect(circle.isPointInside(newPos),isTrue);

            final Circle circle2 = new Circle(new LatLng(0.0,0.0), 110573.0);
            expect(circle2.isPointInside(newPos),isFalse);
        }); // end of 'isInside - ' test

        test('> isInside, bearing 0', () {

            final num bearing = 0;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circle.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circle.isPointInside(distance.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing 90', () {
            final num bearing = 90;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circle.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circle.isPointInside(distance.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing -90', () {
            final num bearing = -90;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circle.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circle.isPointInside(distance.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing 180', () {
            final num bearing = 180;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circle.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circle.isPointInside(distance.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing -180', () {
            final num bearing = -180;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circle.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circle.isPointInside(distance.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

    });
    // End of 'Circle with Haversine' group

    group('Circle with Haversine', () {
        test('> isInside, bearing 0', () {

            final num bearing = 0;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleHaversine.isPointInside(
                    distanceHaversine.offset(base,dist,bearing)),isTrue);
            });

            <num>[ 1001,1002,1003,1004,1005,1006,1007 ].forEach( (final num dist) {
                expect(circleHaversine.isPointInside(distanceHaversine.offset(base,dist,bearing)),isFalse);
            });

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing 90', () {
            final num bearing = 90;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleHaversine.isPointInside(distanceHaversine.offset(base,dist,bearing)),isTrue);
            });
            expect(circleHaversine.isPointInside(distanceHaversine.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing -90', () {
            final num bearing = -90;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleHaversine.isPointInside(distanceHaversine.offset(base,dist,bearing)),isTrue);
            });
            expect(circleHaversine.isPointInside(distanceHaversine.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing 180', () {
            final num bearing = 180;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleHaversine.isPointInside(distanceHaversine.offset(base,dist,bearing)),isTrue);
            });

            expect(circleHaversine.isPointInside(distanceHaversine.offset(base,1001,bearing)),isFalse);


        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing -180', () {
            final num bearing = -180;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleHaversine.isPointInside(distanceHaversine.offset(base,dist,bearing)),isTrue);
            });

            expect(circleHaversine.isPointInside(distanceHaversine.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test
    }); // End of 'Circle with Vincenty' group
}

// - Helper --------------------------------------------------------------------------------------
