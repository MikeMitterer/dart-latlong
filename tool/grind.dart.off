import 'package:grinder/grinder.dart';

main(final List<String> args) => grind(args);

@DefaultTask()
@Depends(test)
build() {
}

@Task()
@Depends(analyze, testUnit)
test() {
}

@Task()
testUnit() {
    new TestRunner().testAsync(files: "test/unit");

    // All tests with @TestOn("content-shell") in header
    // new TestRunner().test(files: "test/unit",platformSelector: "content-shell");
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/latlong.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));
    Analyzer.analyze("test");
}

@Task()
clean() => defaultClean();
