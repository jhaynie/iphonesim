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

With node.js (at least 0.10.20):

    $ sudo npm install ios-sim -g

Download an archive:

    $ curl -L https://github.com/phonegap/ios-sim/zipball/{{VERSION}} -o ios-sim-{{VERSION}}.zip
    $ unzip ios-sim-{{VERSION}}.zip

Or from a git clone:

    $ git clone git://github.com/phonegap/ios-sim.git

Then build and install from the source root:

    $ rake install prefix=/usr/local/

Troubleshooting
------------

Make sure you enable Developer Mode on your machine:
    
    $ DevToolsSecurity -enable

Make sure multiple instances of launchd_sim are not running:
    
    $ killall launchd_sim
    
Development
-----------

When you want to release a version, do:

    $ rake version:bump v=NEW_VERSION
    $ rake release
    $ npm version NEW_VERSION -m "Updated to npm version %s"
    
tmux
-----

To get ios-sim to launch correctly within tmux use the reattach-to-user-namespace wrapper.

```
reattach-to-user-namespace ios-sim launch ./build/MyTestApp.app
```
*source:* https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard

*brew:*  ```brew install reattach-to-user-namespace```

License
-------

Original author: Landon Fuller <landonf@plausiblelabs.com>
Copyright (c) 2008-2011 Plausible Labs Cooperative, Inc.
All rights reserved.

This project is available under the MIT license. See [LICENSE][license].

[license]: https://github.com/phonegap/ios-sim/blob/master/LICENSE
