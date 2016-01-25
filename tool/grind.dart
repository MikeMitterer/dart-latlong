import 'package:grinder/grinder.dart';

main(args) => grind(args);

@DefaultTask()
@Depends(test)
build() {
}

@Task()
@Depends(analyze)
test() {
    new TestRunner().testAsync(files: "test/unit");

    // All tests with @TestOn("content-shell") in header
    // new TestRunner().test(files: "test/unit",platformSelector: "content-shell");
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/LatLong.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));
    Analyzer.analyze("test");
}

@Task()
clean() => defaultClean();
