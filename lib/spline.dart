/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Splines are most commonly used to draw a curve
/// line when a set of given points exists, which needs to be joined smoothly.
///
/// More about the [algorithm](http://www.dxstudio.com/guide_content.aspx?id=70a2b2cf-193e-4019-859c-28210b1da81f)
/// and [here](http://www.mvps.org/directx/articles/catmull/).
///
/// Java way: [A Catmull Rom Spline (curve) Implementation in Java](http://hawkesy.blogspot.co.at/2010/05/catmull-rom-spline-curve-implementation.html)
///
library spline;

import 'dart:async';
import 'dart:collection';

import 'dart:math' as math;

import 'package:validate/validate.dart';
//import 'package:logging/logging.dart';

part 'spline/CatmullRomSpline.dart';