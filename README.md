ios-sim
=======

The ios-sim tool is a command-line utility that launches an iOS application on
the iOS Simulator. This allows for niceties such as automated testing without
having to open XCode.

Features
--------

* Choose the device family to simulate, i.e. iPhone or iPad.
* Setup environment variables.
* Pass arguments to the application.
* See the stdout and stderr, or redirect them to files.

Installation
------------

TODO: make this all work!

Through homebrew:

  $ brew install ios-sim

Or from a git clone:

  $ git clone git://github.com/Fingertips/ios-sim.git
  $ xcodebuild -project ios-sim.xcodeproj -configuration Release
  $ ./build/Release/ios-sim

License
-------

This project is available under the MIT license. See [LICENSE][license].

[license]: https://github.com/Fingertips/iphonesim/blob/master/LICENSE
