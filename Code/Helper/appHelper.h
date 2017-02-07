//
//  appHelper.m
//  EmptyProject
//
//  Created by Administrator on 2016/10/9.
//
//

#import <Foundation/Foundation.h>

@interface appHelper : NSObject

+ (BOOL)fileisExist:(NSString *)filePath;
+ (BOOL)copyfile:(NSString *)source toPath:(NSString *)destination;
+ (BOOL)removefile:(NSString *)filePath;

+ (void)createDirectory:(NSString *)path;
+ (void)removeDirectory:(NSString *)path;

#pragma mark - 數字文字轉換
+ (NSString *)numberToString:(NSNumber *)val;
+ (NSNumber *)stringToNumber:(NSString *)valStr;

#pragma mark - 日期文字轉換
+ (NSString *)dateToString:(NSDate *)inDate;
+ (NSDate *)stringToDate:(NSString *)dtStr;

//空字串處理
+ (NSString *)nullString:(id)inStr;
+ (NSInteger)nullValue:(id)inVal;
+ (BOOL)nullBOOL:(id)inBool;

+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData;
+ (NSArray *)jsonDataToArray:(NSData *)jsonData;

@end

