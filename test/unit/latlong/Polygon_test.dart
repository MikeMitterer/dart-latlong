//@TestOn("content-shell")
import 'package:test/test.dart';

import 'package:latlong/latlong.dart';
// import 'package:logging/logging.dart';

import '../config.dart';

final Map<String,LatLng> cities = <String,LatLng> {
    "berlin" : new LatLng(52.518611,13.408056),
    "moscow" : new LatLng(55.751667,37.617778),
};

main() {
    // final Logger _logger = new Logger("test.Utils");
    
    configLogging();

    group('Polygon', () {

        test('> Center between Berlin and Moscow should be near Minsk '
            '(54.743683,25.033239)', () {

            final Polygon polygon = new Polygon.from([
                cities['berlin'], cities['moscow']
            ]);

            expect(polygon.center.latitude, 54.743683);
            expect(polygon.center.longitude, 25.033239);
        }); // end of 'Center' test

    }); // End of 'Polygon' group

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
