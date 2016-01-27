//@TestOn("content-shell")
import 'package:test/test.dart';

import 'package:latlong/latlong.dart';
// import 'package:logging/logging.dart';

import '../config.dart';

final Map<String,LatLng> cities = <String,LatLng> {
    "berlin" : new LatLng(52.518611,13.408056),
    "moscow" : new LatLng(55.751667,37.617778),
};

final List<LatLng> route = <LatLng>[
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
    // final Logger _logger = new Logger("test.Utils");
    
    configLogging();

    group('Intermediate steps', () {

        test('> 10 intermediate steps between 1000m (dist between startPos/endPos) should have the same length', () {
            final Distance distance = new Distance();
            final LatLng startPos = new LatLng(0.0,0.0);
            final LatLng endPos = distance.offset(startPos,1000,0);

            expect(distance(startPos,endPos),1000);

            final Path path = new Path.from(<LatLng>[ startPos,endPos ]);
            expect(path.length,1000);

            final Path steps = path.createIntermediateSteps(100);

            expect(steps.length,1000);
            expect(steps.coordinates.length,11);

            for(int index = 0;index < steps.nrOfCoordinates - 1;index++) {
                expect(distance(steps[index],steps[index + 1]), 100);
            }

        }); // end of '10 intermediate steps in 1000m should have the same length' test



    }); // End of 'Intermediate steps' group

    group('PathLength', () {

        test('> Distance of empty path should be 0', () {
            final Path path = new Path();

            expect(path.length,0);
        }); // end of 'Distance of empty path should be 0' test

        test('> Path length should be 3377m', () {
            final Path path = new Path.from(route);

            expect(path.length,3377);

        }); // end of 'Path length should be 3377m' test

        test('> Path lenght should be 3.377km', () {
            final Path path = new Path.from(route);

            expect(round(
                LengthUnit.Meter.to(LengthUnit.Kilometer,path.length),decimals:3)
            ,3.377);

        }); // end of 'Path length should be 3.377km' test

    }); // End of 'PathLength' group

    group('Center', () {

        test('> Center between Berlin and Moscow should be near Minsk '
            '(54.743683,25.033239)', () {

            final Path path = new Path.from([
                cities['berlin'], cities['moscow']
            ]);

            expect(path.center.latitude, 54.743683);
            expect(path.center.longitude, 25.033239);
        }); // end of 'Center' test

    }); // End of 'Center' group

    group('Utils', () {
        setUp(() { });

        test('> Round', () {
            expect(round(123.1), 123.1);
            expect(round(123.123456), 123.123456);
            expect(round(123.1234567), 123.123457);
            expect(round(123.1234565), 123.123457);
            expect(round(123.1234564), 123.123456);
            expect(round(123.1234564,decimals: 0), 123);
            expect(round(123.1234564,decimals: -1), 120);
            expect(round(123.1234564,decimals: -3), 0);
            expect(round(523.1234564,decimals: -3), 1000);
            expect(round(423.1234564,decimals: -3), 0);

        }); // end of 'Round' test
    });
    // End of 'Utils' group
}

// - Helper --------------------------------------------------------------------------------------
