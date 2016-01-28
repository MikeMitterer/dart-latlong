import 'package:test/test.dart';

import 'package:latlong/spline.dart';
// import 'package:logging/logging.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.CatmullRom");
    
    configLogging();


    group('CatmullRom 1D', () {
        setUp(() { });

        test('> one dimension', () {

            final CatmullRomSpline spline = new CatmullRomSpline(1,2,2,1);

            expect(spline.position(0.25),2.09375);
            expect(spline.position(0.5),2.125);
            expect(spline.position(0.75),2.09375);
        }); // end of 'one dimension' test

        test('> no endpoints', () {
            final CatmullRomSpline spline = new CatmullRomSpline.noEndpoints(1,2);

            expect(spline.position(0.25),1.203125);
            expect(spline.position(0.5),1.5);
            expect(spline.percentage(50),1.5);

            expect(spline.position(0.75),1.796875);
        }); // end of 'no endpoints' test

    });
    // End of 'CatmullRom 1D' group

    group('CatmullRom 2D', () {
        test('> Simple values', () {
            final CatmullRomSpline2D spline = new CatmullRomSpline2D(
                    new Point2D(1,1),
                    new Point2D(2,2),
                    new Point2D(2,2),
                    new Point2D(1,1)
                );

            expect(spline.position(0.25).x,2.09375);
            expect(spline.position(0.25).y,2.09375);

            expect(spline.position(0.5).x,2.125);
            expect(spline.position(0.5).y,2.125);
            expect(spline.percentage(50).x,2.125);
            expect(spline.percentage(50).y,2.125);

            expect(spline.position(0.75).x,2.09375);
            expect(spline.position(0.75).y,2.09375);
        });

        test('> no Endpoints', () {
            final CatmullRomSpline2D spline = new CatmullRomSpline2D.noEndpoints(
                new Point2D(1,1),
                new Point2D(2,2)
            );

            expect(spline.position(0.25).x,1.203125);
            expect(spline.position(0.25).y,1.203125);
        }); // end of 'no Endpoints' test

        test('> Exception', () {
            final CatmullRomSpline2D spline = new CatmullRomSpline2D.noEndpoints(
                new Point2D(1,1),
                new Point2D(2,2)
            );

            expect(() => spline.position(3.0).x,throws);

        }); // end of 'Exception' test


    }); // End of 'CatmullRom 2D' group
}

// - Helper --------------------------------------------------------------------------------------
