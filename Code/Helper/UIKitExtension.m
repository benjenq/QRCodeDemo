//
//  UIKitExtension.m
//  ScreenRecorder
//
//  Created by Administrator on 2016/12/14.
//
//

#import "UIKitExtension.h"

@implementation UIApplication (beExtensions)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#endif

+ (NSString *)GetBundlePath{
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSString *)GetDocumentPath{
    return [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]];
}
+ (NSString *)GetCachePath{
    return [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0]];
}
+ (NSString *)GettmpPath{
    return [NSString stringWithFormat:@"%@",NSTemporaryDirectory()];
}

@end

@implementation UIDevice (beExtensions)

+ (BOOL)isAboveiOS6{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"6.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 6.0
        return YES;
        
    }
    else {
        // OS version < 6.0
        return NO;
    }
}

+ (BOOL)isAboveiOS7{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 7.0
        return YES;
        
    }
    else {
        // OS version < 7.0
        return NO;
    }
}

+ (BOOL)isAboveiOS8{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 8.0
        return YES;
        
    }
    else {
        // OS version < 8.0
        return NO;
    }
}

+ (BOOL)isAboveiOS9{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"9.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 9.0
        return YES;
        
    }
    else {
        // OS version < 9.0
        return NO;
    }
}

+ (BOOL)isAboveiOS10{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"10.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 10.0
        return YES;
        
    }
    else {
        // OS version < 10.0
        return NO;
    }
}

+ (BOOL)deviceIsiPad{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) { //iPad
        return YES;
    }
    return NO;
}

+ (DeviceType)currentDeviceType{
    DeviceType result = DeviceTypeIsiPhone35;
    if (![[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]){
        return result;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) { //iPad
        if ([UIScreen mainScreen].scale >= 2.0) {
            if ([UIScreen mainScreen].bounds.size.width > 1024 || [UIScreen mainScreen].bounds.size.height > 1024) {
                result = DeviceTypeIsiPad12R;
            }
            else {
                result = DeviceTypeIsiPadR;
            }
            
        }
        else
        {
            result = DeviceTypeIsiPad;
        }
    }
    else //iPhone
    {
        if ([UIScreen mainScreen].scale >= 2.0) {
            if ([UIScreen mainScreen].bounds.size.width > 668 || [UIScreen mainScreen].bounds.size.height > 668) {
                result = DeviceTypeIsiPhone55in;
            }
            else if ([UIScreen mainScreen].bounds.size.width > 569 || [UIScreen mainScreen].bounds.size.height > 569) {
                result = DeviceTypeIsiPhone47in;
            }
            else if ([UIScreen mainScreen].bounds.size.width > 481 || [UIScreen mainScreen].bounds.size.height > 481) {
                result = DeviceTypeIsiPhone4in;
            }
            else{
                result = DeviceTypeIsiPhone35R;
            }
            
        }
        else // 最早的 iPhone
        {
            result = DeviceTypeIsiPhone35;
        }
        
    }
    return result;
}

+(NSString *)UDID{
    if ([UIDevice isAboveiOS6]) {
        return [[UIDevice currentDevice] identifierForVendor].UUIDString;
    }
    else
    {
        return @"512C27D3-AF04-4467-B405-9E2494DA31DC";
    }
}


@end

@implementation UIColor (extension)

+ (UIColor *)lifeViewBorderColor{
    return [UIColor colorWithRed:(CGFloat)236.0/255 green:(CGFloat)194.0/255.0 blue:(CGFloat)56.0/255.0 alpha:1.0];
}

@end
