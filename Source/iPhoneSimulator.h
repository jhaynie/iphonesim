/*
 * See the LICENSE file for the license on the source code in this file.
 */

#import <Foundation/Foundation.h>
#import <iPhoneSimulatorRemoteClient/iPhoneSimulatorRemoteClient.h>

#define IOS_SIM_VERSION "1.0"

@interface iPhoneSimulator : NSObject <DTiPhoneSimulatorSessionDelegate> {
@private
  DTiPhoneSimulatorSystemRoot *sdkRoot;
  NSFileHandle *stdoutFileHandle;
  NSFileHandle *stderrFileHandle;
  BOOL verbose;
}

- (void)runWithArgc:(int)argc argv:(char **)argv;

- (void)createStdioFIFO:(NSFileHandle **)fileHandle ofType:(NSString *)type atPath:(NSString **)path;
- (void)removeStdioFIFO:(NSFileHandle *)fileHandle atPath:(NSString *)path;

@end
