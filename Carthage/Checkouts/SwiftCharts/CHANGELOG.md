# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.5] - 2016.11.23
- Add multi-chart tracker layer
- Add dashed line support
- Migrate to Swift 2.3
- Migrate to Swift 3.0
- Fix division by 0 in axis layer
- Fix not being able to use reversed axis values

## [0.4] - 2016.05.29
- Fix tracker showing NaN on constant coordinate
- Pass tension values to cubic line to be able to modify curviness
- Add tvOS target
- Fix value of ChartAxisValue does not update in subsequent calls to copy
- Fix axis stroke width setting has no effect
- Add public init so to ChartLayerBase to allow it to be subclassed
- Update examples to use ChartAxisValueDouble instead of ChartAxisValueFloat (deprecated)
- Make ChartPoint, ChartAxisValue and subclasses conform to CustomStringConvertible
- Use closure to map dates instead of date formatter for more flexibility
- Improve inline documentation
- Allow to change text alignment of y axis labels
- Make ChartPointsScatterLayer class along with its' properties and methods public for subclassing outside swift module
- Use flatMap instead of reduce to improve performance
- Don't sort axis values in axis layer
- Move labels in y axis if they overlap
- Fix dividers not showing in upper x axis
- Fix line layer blocking touch
- Fix memory leak in CoordExample (issue #101)
- Add top right coord space initialisation helper

## [0.3] - 2015.09.28
- Merge swift2.0 in master

## [0.2.5] - 2015.08.31
- Fix stacked bar frames displaying incorrectly when start is not 0
- Improve project organization
- Make usage of ChartAxisValue clearer, improve docs
- Use only Double instead of CGFloat for axis values, deprecate ChartAxisValueFloat and ChartAxisValueFloatScreenLoc

## [0.2.4] - 2015.08.09
- Automatic generation of trendlines
- Add Carthage support

## [0.2.3]
- Allow rotating y axis title label
- Add LineChart to create (multi)line chart with few lines
- Add BarChart to create bar chart with few lines
- Change axis value's scalar type to Double to fix inaccuracies when using dates

## [0.2.2]
- Refactor circle and bubble views, now ChartPointEllipseView
- Rename BubbleView in InfoBubble and move it to example project

## [0.2.1] - 2015-05-24
- Improve performance drawing guidelines
- Generate calculation intensive coordinates spaces in the background (examples)
- Performance improvements calculating axis labels size

## [0.2] - 2015-05-22

### Added
- iOS7 support
- Bars example with variable axes
- Stacked bars layer and example
- Bubble chart layer and example, example includes functionality to map model values to colors from gradient bar
- Scatter chart layer and example
- Bars layer, +/- bars with dynamic gradient example 
- Grouped bars layer and example

### Removed
- Bars example with horizontal axis - now included in variable axes example

## [0.1] - 2015-05-10
First import, pods settings
