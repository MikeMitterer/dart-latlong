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

final List<LatLng> westendorf = <LatLng>[
    new LatLng(47.43074295001961,12.21235112213462),
    new LatLng(47.43089093351458,12.21272597555608),
    new LatLng(47.43112096728846,12.21318739290575),
    new LatLng(47.43136362193013,12.21357041557469),
    new LatLng(47.43151718768905,12.21381341692645),
    new LatLng(47.43165029999054,12.2140511609222),
    new LatLng(47.43197227207169,12.21443856698021),
];

final List<LatLng> zigzag = <LatLng>[
    new LatLng(47.43082546234226,12.21255804885847),
    new LatLng(47.43103958915331,12.21268605330973),
    new LatLng(47.43105710900187,12.21307899558343),
    new LatLng(47.43122940724644,12.21334560213179),
    new LatLng(47.43140402736853,12.21345312442578),
    new LatLng(47.43145463473182,12.21370919972242),
    new LatLng(47.43152498372309,12.21383217398376),
    new LatLng(47.43154236046533,12.213861433609),
    new LatLng(47.43156491014229,12.21389982585238),
    new LatLng(47.43170715787343,12.21411329481371),
    new LatLng(47.4316056796912,12.21427241091704),
    new LatLng(47.43148429441857,12.21439779676563),
    new LatLng(47.43144240029867,12.21446788249065),
    new LatLng(47.43150069195054,12.21456420272734),
    new LatLng(47.4315919174373,12.21469743884608),
    new LatLng(47.43163947608171,12.21477097582562),
    new LatLng(47.43171300672132,12.21474044606232),
    new LatLng(47.43178565483553,12.21464852517297),
    new LatLng(47.43186412401507,12.21455971070946),
    new LatLng(47.43196361890569,12.21443596175264)
];

main() {
    // final Logger _logger = new Logger("test.Utils");
    
    configLogging();

    group('Equalize path', () {


        test('> The total size of a path with 1000m lengt devided by 10sections must have the same'
            'length as the base path', () {

            final Distance distance = new Distance();
            final LatLng startPos = new LatLng(0.0,0.0);
            final LatLng endPos = distance.offset(startPos,1000,0);

            expect(distance(startPos,endPos),1000);

            final Path path = new Path.from(<LatLng>[ startPos,endPos ]);
            expect(path.distance,1000);

            final Path steps = path.equalize(100,smoothPath: false);

            // _exportForGoogleEarth(steps);
            expect(steps.distance,1000);
            expect(steps.coordinates.length,11);

        }); // end of '10 intermediate steps in 1000m should have the same length' test

        test('> 10 smoothd out steps in total have approximatly!!! the same lenght '
                'as the base path', () {
            final Distance distance = new Distance();
            final LatLng startPos = new LatLng(0.0,0.0);
            final LatLng endPos = distance.offset(startPos,1000,0);

            expect(distance(startPos,endPos),1000);

            final Path path = new Path.from(<LatLng>[ startPos,endPos ]);
            expect(path.distance,1000);

            final Path steps = path.equalize(100,smoothPath: false);

            expect(steps.distance,inInclusiveRange(999,1001));
            expect(steps.coordinates.length,11);

            //_exportForGoogleEarth(steps);
            for(int index = 0;index < steps.nrOfCoordinates - 1;index++) {
                // 46?????
                expect(distance(steps[index],steps[index + 1]), inInclusiveRange(46,112));
            }

        }); // end of '10 intermediate steps in 1000m should have the same length' test

        test('> Path with 3 sections', () {

            final Distance distance = new Distance();
            final LatLng startPos = new LatLng(0.0,0.0);
            final LatLng pos1 = distance.offset(startPos,50,0);
            final LatLng pos2 = distance.offset(pos1,15,0);
            final LatLng pos3 = distance.offset(pos2,5,0);

            expect(distance(startPos,pos3),70);

            final Path path = new Path.from(<LatLng>[ startPos, pos1, pos2, pos3]);
            expect(path.distance,70);

            final Path steps = path.equalize(30,smoothPath: false);
            //_exportForGoogleEarth(steps);

            expect(steps.nrOfCoordinates,4);

        }); // end of 'Path with 3 sections' test

        test('> Reality Test - Westendorf, short, should 210m (same as Google Earth)', () {
            final Path path = new Path.from(westendorf);
            expect(path.distance,210);

            // first point to last point!
            final Distance distance = new Distance();
            expect(distance(westendorf.first,westendorf.last),209);

            final Path steps = path.equalize(5);
            expect(steps.nrOfCoordinates,44);

            _exportForGoogleEarth(steps,show: false);

        }); // end of 'Reality Test - Westendorf, short' test

        test('> ZigZag, according to Google-Earth - 282m,'
                'first to last point 190m (acc. movable-type.co.uk (Haversine)', () {

            final Path path = new Path.from(zigzag);
            expect(path.distance,282);

            // first point to last point!
            final Distance distance = new Distance();
            expect(distance(zigzag.first,zigzag.last),190);

            final Path steps = path.equalize(8,smoothPath: true);

            // 282 / 8 = 35,25 + first + last
            expect(steps.nrOfCoordinates,36);
            expect(steps.coordinates.length, inInclusiveRange(36,37));

            _exportForGoogleEarth(steps,show: false);

            // Distance check makes no sense - path is shorter than the original one!

            // double sumDist = 0.0;
            // for(int index = 0;index < steps.nrOfCoordinates - 1;index++) {
            //    sumDist += distance(steps[index],steps[index + 1]);
            // }
        }); // end of 'ZigZag' test

    }); // End of 'Intermediate steps' group

    group('PathLength', () {

        test('> Distance of empty path should be 0', () {
            final Path path = new Path();

            expect(path.distance,0);
        }); // end of 'Distance of empty path should be 0' test

        test('> Path length should be 3377m', () {
            final Path path = new Path.from(route);

            expect(path.distance,3377);

        }); // end of 'Path length should be 3377m' test

        test('> Path lenght should be 3.377km', () {
            final Path path = new Path.from(route);

            expect(round(
                LengthUnit.Meter.to(LengthUnit.Kilometer,path.distance),decimals:3)
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

/// Print CSV-date on the cmdline
void _exportForGoogleEarth(final Path steps, {final bool show: true }) {
    if(show) {
        final Distance distance = new Distance();

        print("latitude,longitude,distance");
        for(int index = 0;index < steps.nrOfCoordinates - 1;index++) {
            print("${steps[index].latitude}, ${steps[index].longitude}, ${distance(steps[index],steps[index+1])}");
        }

        print("${steps.last.latitude}, ${steps.last.longitude}, 0");
    }

}
