//@TestOn("content-shell")
import 'package:test/test.dart';

import 'package:latlong/latlong.dart';
// import 'package:logging/logging.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.LengthUnit");
    
    configLogging();
    //await saveDefaultCredentials();


    group('LengthUnit', () {
        setUp(() { });

        test('> Millimeter', () {
            expect(LengthUnit.Millimeter.to(LengthUnit.Millimeter, 1.0), 1.0);
            expect(LengthUnit.Millimeter.to(LengthUnit.Centimeter, 1.0), 0.1);
            expect(LengthUnit.Millimeter.to(LengthUnit.Meter, 1000.0), 1.0);
            expect(LengthUnit.Millimeter.to(LengthUnit.Kilometer, 1000000.0), 1);
        }); // end of 'Millimeter' test

        test('> Centimeter', () {
            expect(LengthUnit.Centimeter.to(LengthUnit.Centimeter, 1.0), 1.0);
            expect(LengthUnit.Centimeter.to(LengthUnit.Millimeter, 1.0), 10.0);
        }); // end of 'Centimeter' test

        test('> Meter', () {
            expect(LengthUnit.Meter.to(LengthUnit.Meter, 100.0), 100.0);
            expect(LengthUnit.Meter.to(LengthUnit.Kilometer, 1.0), 0.001);
        }); // end of 'Meter' test

        test('> Kilometer', () {
            expect(LengthUnit.Kilometer.to(LengthUnit.Kilometer, 1.0), 1.0);
            expect(LengthUnit.Kilometer.to(LengthUnit.Meter, 1.0), 1000.0);
        }); // end of 'Kilometer' test

        test('> Mike', () {
            expect((LengthUnit.Mile.to(LengthUnit.Meter, 1.0) * 100).round() / 100, 1609.34);
        }); // end of 'Mike' test

    });
    // End of 'LengthUnit' group
}

// - Helper --------------------------------------------------------------------------------------
