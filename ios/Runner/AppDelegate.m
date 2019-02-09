#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "iOSPalette.h"

@implementation AppDelegate {
    NSMutableDictionary<NSString *, NSString *> *palettCache;
    UIImageView *imageView;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    palettCache = [NSMutableDictionary new];
    imageView = [UIImageView new];
    FlutterViewController *conteoller = (FlutterViewController *)self.window.rootViewController;
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"com.ciy.flutterkugou/imagePalette" binaryMessenger:conteoller];
    [channel setMethodCallHandler:^(FlutterMethodCall * call, FlutterResult result) {
        if ([@"getImagePalette" isEqualToString:call.method]) {
            NSString *url = call.arguments;
            if ([palettCache.allKeys containsObject:url]) {
                result(palettCache[url]);
                return;
            }
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [image getPaletteImageColorWithMode:ALL_MODE_PALETTE withCallBack:^(PaletteColorModel *recommendColor, NSDictionary *allModeColorDic, NSError *error) {
                    if (recommendColor) {
                        PaletteColorModel *colorModel = [allModeColorDic objectForKey:@"vibrant"];
                        if (![colorModel isKindOfClass:[PaletteColorModel class]]) {
                            colorModel = [allModeColorDic objectForKey:@"muted"];
                        }
                        if (![colorModel isKindOfClass:[PaletteColorModel class]]) {
                            colorModel = [allModeColorDic objectForKey:@"light_vibrant"];
                        }
                        if (![colorModel isKindOfClass:[PaletteColorModel class]]) {
                            colorModel = [allModeColorDic objectForKey:@"light_muted"];
                        }
                        if (![colorModel isKindOfClass:[PaletteColorModel class]]) {
                            colorModel = [allModeColorDic objectForKey:@"dark_vibrant"];
                        }
                        if (![colorModel isKindOfClass:[PaletteColorModel class]]) {
                            colorModel = [allModeColorDic objectForKey:@"dark_muted"];
                        }
                        if (colorModel && colorModel.imageColorString.length == 7) {
                            NSString *hexColor = [colorModel.imageColorString substringFromIndex:1];
                            NSRange range;
                            range.location = 0;
                            range.length = 2;
                            
                            NSString *red = [hexColor substringWithRange:range];
                            
                            range.location = 2;
                            NSString *green = [hexColor substringWithRange:range];
                            
                            range.location = 4;
                            NSString *blue = [hexColor substringWithRange:range];
                            
                            unsigned int r,g,b;
                            [[NSScanner scannerWithString:red] scanHexInt:&r];
                            [[NSScanner scannerWithString:green] scanHexInt:&g];
                            [[NSScanner scannerWithString:blue] scanHexInt:&b];
                            
                            NSString *resultColor = [NSString stringWithFormat:@"255,%d,%d,%d", r, g, b];
                            palettCache[url] = resultColor;
                            result(resultColor);
                            return ;
                        }
                    }
                    result(@"");
                }];
            }];
        }
    }];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
