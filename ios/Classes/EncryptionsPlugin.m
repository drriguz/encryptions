#import "EncryptionsPlugin.h"
#import <encryptions/encryptions-Swift.h>

@implementation EncryptionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEncryptionsPlugin registerWithRegistrar:registrar];
}
@end
