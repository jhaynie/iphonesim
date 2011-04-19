/*
 * Author: Landon Fuller <landonf@plausiblelabs.com>
 * Copyright (c) 2008 Plausible Labs Cooperative, Inc.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

 /**
  * Modifications made by Appcelerator, Inc. licensed under the
  * same license as above.
  */

#import "iPhoneSimulator.h"
#import "nsprintf.h"

/**
 * A simple iPhoneSimulatorRemoteClient framework.
 */
@implementation iPhoneSimulator

/**
 * Print usage.
 */
- (void) printUsage {
    fprintf(stderr, "Usage: iphonesim <options> <command> ...\n");
    fprintf(stderr, "Commands:\n");
    fprintf(stderr, "  showsdks\n");
    fprintf(stderr, "  launch <application path> [-verbose] [-sdk <sdkversion>] [-family ipad] [-uuid <uuid>] [-env <environment file path>] [-stdout <path to stdout file>] [-stderr <path to stderr file>] [-args <remaining arguments passed through to launched application>]\n");
}


/**
 * List available SDK roots.
 */
- (int) showSDKs {
    NSArray *roots = [DTiPhoneSimulatorSystemRoot knownRoots];

    nsprintf(@"Simulator SDK Roots:");
    for (DTiPhoneSimulatorSystemRoot *root in roots) {
        nsfprintf(stderr, @"'%@' (%@)\n\t%@", [root sdkDisplayName], [root sdkVersion], [root sdkRootPath]);
    }

    return EXIT_SUCCESS;
}

- (void) session: (DTiPhoneSimulatorSession *) session didEndWithError: (NSError *) error {
	if (verbose) {
	    nsprintf(@"Session did end with error %@", error);	
	}
    
    if (error != nil)
        exit(EXIT_FAILURE);

    exit(EXIT_SUCCESS);
}


- (void) session: (DTiPhoneSimulatorSession *) session didStart: (BOOL) started withError: (NSError *) error {
    if (started) {
		if (verbose) {
			nsprintf(@"Session started");	
		}
    } else {
		NSMutableArray *errorLines = [NSMutableArray arrayWithObject:@"Session could not be started (errors below):"];
		for (NSError *innerError = error; innerError != nil; innerError = [[innerError userInfo] objectForKey:NSUnderlyingErrorKey]) {
			[errorLines addObject:[NSString stringWithFormat:
								   @"%@ %@ %@",
								   innerError,
								   [innerError localizedDescription],
								   [innerError userInfo]]];
		} 
		NSString *errorMessage = [errorLines componentsJoinedByString:@"\n"];
        nsprintf(errorMessage);
        exit(EXIT_FAILURE);
    }
}


/**
 * Launch the given Simulator binary.
 */
- (int) launchApp: (NSString *) path withFamily:(NSString*)family uuid:(NSString*)uuid environment:(NSDictionary *) environment stdoutPath: (NSString *) stdoutPath stderrPath: (NSString *) stderrPath args: (NSArray *) args{
    DTiPhoneSimulatorApplicationSpecifier *appSpec;
    DTiPhoneSimulatorSessionConfig *config;
    DTiPhoneSimulatorSession *session;
    NSError *error;

    /* Create the app specifier */
    appSpec = [DTiPhoneSimulatorApplicationSpecifier specifierWithApplicationPath: path];
    if (appSpec == nil) {
        nsprintf(@"Could not load application specification for %s", path);
        return EXIT_FAILURE;
    }
	if (verbose) {
		nsprintf(@"App Spec: %@", appSpec);
		
		/* Load the default SDK root */
		
		nsprintf(@"SDK Root: %@", sdkRoot);	
	}

    /* Set up the session configuration */
    config = [[[DTiPhoneSimulatorSessionConfig alloc] init] autorelease];
    [config setApplicationToSimulateOnStart: appSpec];
    [config setSimulatedSystemRoot: sdkRoot];
    [config setSimulatedApplicationShouldWaitForDebugger: NO];

    [config setSimulatedApplicationLaunchArgs: args];
    [config setSimulatedApplicationLaunchEnvironment: environment];
	
	if (stderrPath) {
		[config setSimulatedApplicationStdErrPath:stderrPath];	
	}
	
	if (stdoutPath) {
		[config setSimulatedApplicationStdOutPath:stdoutPath];	
	}

    [config setLocalizedClientName: @"TitaniumDeveloper"];

	// this was introduced in 3.2 of SDK
	if ([config respondsToSelector:@selector(setSimulatedDeviceFamily:)])
	{
		if (family == nil)
		{
			family = @"iphone";
		}

		if (verbose) {
			nsprintf(@"using device family %@",family);	
		}

		if ([family isEqualToString:@"ipad"])
		{
			[config setSimulatedDeviceFamily:[NSNumber numberWithInt:2]];
		}
		else
		{
			[config setSimulatedDeviceFamily:[NSNumber numberWithInt:1]];
		}
	}

    /* Start the session */
    session = [[[DTiPhoneSimulatorSession alloc] init] autorelease];
    [session setDelegate: self];
    [session setSimulatedApplicationPID: [NSNumber numberWithInt: 35]];
	if (uuid!=nil)
	{
		[session setUuid:uuid];
	}

    if (![session requestStartWithConfig: config timeout: 30 error: &error]) {
        nsprintf(@"Could not start simulator session: %@", error);
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}


/**
 * Execute 'main'
 */
- (void) runWithArgc: (int) argc argv: (char **) argv {
    /* Read the command */
    if (argc < 2) {
        [self printUsage];
        exit(EXIT_FAILURE);
    }

    if (strcmp(argv[1], "showsdks") == 0) {
        exit([self showSDKs]);
    }
    else if (strcmp(argv[1], "launch") == 0) {
        /* Requires an additional argument */
        if (argc < 3) {
            fprintf(stderr, "Missing application path argument\n");
            [self printUsage];
            exit(EXIT_FAILURE);
        }
		
		NSString *family = nil;
		NSString *uuid = nil;
		NSString *stdoutPath = nil;
		NSString *stderrPath = nil;
		NSDictionary *environment = [NSDictionary dictionary];
		int i = 3;
		for (; i < argc; i++) {
			if (strcmp(argv[i], "-verbose") ==0) {
				verbose = YES;
			}
			else if (strcmp(argv[i], "-sdk") == 0) {
				i++;
				NSString* ver = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
				NSArray *roots = [DTiPhoneSimulatorSystemRoot knownRoots];
				for (DTiPhoneSimulatorSystemRoot *root in roots) {
					NSString *v = [root sdkVersion];
					if ([v isEqualToString:ver])
					{
						sdkRoot = root;
						break;
					}
				}
				if (sdkRoot == nil)
				{
					fprintf(stderr,"Unknown or unsupported SDK version: %s\n",argv[i]);
					[self showSDKs];
					exit(EXIT_FAILURE);
				}
			} else if (strcmp(argv[i], "-family") == 0) {
				i++;
				family = [NSString stringWithUTF8String:argv[i]];
			} else if (strcmp(argv[i], "-uuid") == 0) {
				i++;
				uuid = [NSString stringWithUTF8String:argv[i]];
			} else if (strcmp(argv[i], "-env") == 0) {
				i++;
				environment = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:argv[i]]];
				if (!environment) {
					fprintf(stderr, "Could not read environment from file: %s\n", argv[i]);
					[self printUsage];
					exit(EXIT_FAILURE);
				}
			} else if (strcmp(argv[i], "-stdout") == 0) {
				i++;
				stdoutPath = [NSString stringWithUTF8String:argv[i]];
			} else if (strcmp(argv[i], "-stderr") == 0) {
				i++;
				stderrPath = [NSString stringWithUTF8String:argv[i]];
			} else if (strcmp(argv[i], "-args") == 0) {
				i++;
				break;
			} else {
				fprintf(stderr, "unrecognized argument:%s\n", argv[i]);
				[self printUsage];
				exit(EXIT_FAILURE);
			}
		}
		NSMutableArray *args = [NSMutableArray arrayWithCapacity:argc - i];
		for (; i < argc; i++) {
			[args addObject:[NSString stringWithUTF8String:argv[i]]];
		}
		
        if (sdkRoot == nil) {
            sdkRoot = [DTiPhoneSimulatorSystemRoot defaultRoot];
        }

        /* Don't exit, adds to runloop */
        [self launchApp: [NSString stringWithUTF8String: argv[2]] withFamily:family uuid:uuid environment:environment stdoutPath:stdoutPath stderrPath:stderrPath args:args];
    } else {
        fprintf(stderr, "Unknown command\n");
        [self printUsage];
        exit(EXIT_FAILURE);
    }
}

@end
