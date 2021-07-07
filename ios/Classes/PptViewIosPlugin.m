#import "PptViewIosPlugin.h"
#if __has_include(<ppt_view_ios/ppt_view_ios-Swift.h>)
#import <ppt_view_ios/ppt_view_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ppt_view_ios-Swift.h"
#endif

@implementation PptViewIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPptViewIosPlugin registerWithRegistrar:registrar];
}
@end
