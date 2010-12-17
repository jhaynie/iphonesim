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

See the `--help` option for more info.

Installation
------------

Through homebrew:

    $ brew install ios-sim

Download an archive:

    $ curl -O http://cloud.github.com/downloads/Fingertips/ios-sim/ios-sim-1.0.zip
    $ unzip ios-sim-1.0.zip
    $ mv ios-sim-1.0/ios-sim /usr/local/bin/

Or from a git clone:

    $ git clone git://github.com/Fingertips/ios-sim.git
    $ xcodebuild
    $ mv build/Release/ios-sim /usr/local/bin/

License
-------

This project is available under the MIT license. See [LICENSE][license].

[license]: https://github.com/Fingertips/iphonesim/blob/master/LICENSE
