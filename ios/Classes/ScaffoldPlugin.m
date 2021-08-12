#import "ScaffoldPlugin.h"
#if __has_include(<scaffold/scaffold-Swift.h>)
#import <scaffold/scaffold-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "scaffold-Swift.h"
#endif

@implementation ScaffoldPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScaffoldPlugin registerWithRegistrar:registrar];
}
@end
