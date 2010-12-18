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

    $ curl -L https://github.com/Fingertips/ios-sim/zipball/1.1 -o ios-sim-1.1.zip
    $ unzip ios-sim-1.1.zip

Or from a git clone:

    $ git clone git://github.com/Fingertips/ios-sim.git

Then build and install from the source root:

    $ rake install prefix=/usr/local/bin/

License
-------

This project is available under the MIT license. See [LICENSE][license].

[license]: https://github.com/Fingertips/iphonesim/blob/master/LICENSE
