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

    $ curl -L https://github.com/Fingertips/ios-sim/zipball/{{VERSION}} -o ios-sim-{{VERSION}}.zip
    $ unzip ios-sim-{{VERSION}}.zip

Or from a git clone:

    $ git clone git://github.com/Fingertips/ios-sim.git

Then build and install from the source root:

    $ rake install prefix=/usr/local/

License
-------

Original author: Landon Fuller <landonf@plausiblelabs.com>
Copyright (c) 2008-2011 Plausible Labs Cooperative, Inc.
All rights reserved.

This project is available under the MIT license. See [LICENSE][license].

[license]: https://github.com/Fingertips/ios-sim/blob/master/LICENSE
