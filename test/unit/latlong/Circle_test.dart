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
    final Circle circleVincenty = new Circle(base, 1000.0,algorithm: distanceWithVincenty);

    group('Circle with Haversine', () {
        setUp(() { });

        test('> isInside - distance from 0.0,0.0 to 1.0,0.0 is 111319 meter (based on Haversine)', () {
            final Circle circle = new Circle(new LatLng(0.0,0.0), 111319.0);
            final LatLng newPos = new LatLng(1.0,0.0);
            // final double dist = new Distance(algorithm: distanceWithHaversine).distance(circle.center,newPos);

            expect(circle.isPointInside(newPos),isTrue);

            final Circle circle2 = new Circle(new LatLng(0.0,0.0), 111318.0);
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

    group('Circle with Vincenty', () {
        test('> isInside, bearing 0', () {

            final num bearing = 0;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });

            // Vincenty uses an ellipsoid!
            <num>[ 1001,1002,1003,1004,1005,1006,1007 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circleVincenty.isPointInside(distance.offset(base,1008,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing 90', () {
            final num bearing = 90;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circleVincenty.isPointInside(distance.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing -90', () {
            final num bearing = -90;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circleVincenty.isPointInside(distance.offset(base,1001,bearing)),isFalse);

        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing 180', () {
            final num bearing = 180;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });

            // Vincenty uses an ellipsoid!
            <num>[ 1001,1002,1003,1004,1005,1006,1007 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circleVincenty.isPointInside(distance.offset(base,1008,bearing)),isFalse);


        }); // end of 'isInside, bearing 0' test

        test('> isInside, bearing -180', () {
            final num bearing = -180;
            <num>[ 100, 500, 999, 1000 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });

            // Vincenty uses an ellipsoid!
            <num>[ 1001,1002,1003,1004,1005,1006,1007 ].forEach( (final num dist) {
                expect(circleVincenty.isPointInside(distance.offset(base,dist,bearing)),isTrue);
            });
            expect(circleVincenty.isPointInside(distance.offset(base,1008,bearing)),isFalse);


        }); // end of 'isInside, bearing 0' test
    }); // End of 'Circle with Vincenty' group
}

// - Helper --------------------------------------------------------------------------------------
