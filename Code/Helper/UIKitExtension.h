//
//  UIKitExtension.h
//  ScreenRecorder
//
//  Created by Administrator on 2016/12/14.
//
//

#import <Foundation/Foundation.h>

@interface UIApplication (beExtensions)
+ (NSString *)GetBundlePath;
+ (NSString *)GetDocumentPath;
+ (NSString *)GetCachePath;
+ (NSString *)GettmpPath;

@end

@interface UIDevice (beExtensions)

typedef NS_ENUM(NSUInteger,DeviceType)
{
    DeviceTypeIsUnknow = 0,
    DeviceTypeIsiPhone35 = 11,
    DeviceTypeIsiPhone35R = 12,
    DeviceTypeIsiPhone4in = 13,
    DeviceTypeIsiPhone47in = 14,
    DeviceTypeIsiPhone55in = 15,
    DeviceTypeIsiPad = 21,
    DeviceTypeIsiPadR = 22,
    DeviceTypeIsiPad12R = 23
};

+ (BOOL)isAboveiOS6;

+ (BOOL)isAboveiOS7;

+ (BOOL)isAboveiOS8;

+ (BOOL)isAboveiOS9;

+ (BOOL)isAboveiOS10;

+ (BOOL)deviceIsiPad;

+ (DeviceType)currentDeviceType;


+ (NSString *)UDID;

@end

@interface UIColor (extension)

+ (UIColor *)lifeViewBorderColor;

@end


