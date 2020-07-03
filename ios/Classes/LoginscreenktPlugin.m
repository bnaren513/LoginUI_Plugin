#import "LoginscreenktPlugin.h"
#if __has_include(<loginscreenkt/loginscreenkt-Swift.h>)
#import <loginscreenkt/loginscreenkt-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "loginscreenkt-Swift.h"
#endif

@implementation LoginscreenktPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLoginscreenktPlugin registerWithRegistrar:registrar];
}
@end
