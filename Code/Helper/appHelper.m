//
//  appHelper.m
//  EmptyProject
//
//  Created by Administrator on 2016/10/9.
//
//

#import "appHelper.h"
@implementation appHelper

+ (BOOL)fileisExist:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
        return YES;
    else
        return NO;
}

+ (BOOL)copyfile:(NSString *)source toPath:(NSString *)destination{
    if (![self fileisExist:source]) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = [fileManager copyItemAtPath:source toPath:destination error:&error];
    if (error != nil) {
        NSLog(@"copyfile error:%@",[error description]);
        
    }
    return success;
}

+ (BOOL)removefile:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = NO;
    if ([fileManager fileExistsAtPath:filePath]){
        success = [fileManager removeItemAtPath:filePath error:&error];
    }
    if (error != nil) {
        NSLog(@"removefile error:%@",[error description]);
    }
    return success;
}

+ (void)createDirectory:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"建立目錄:%@",path);
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

+ (void)removeDirectory:(NSString *)path{
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
}


#pragma mark - 數字文字轉換
+ (NSString *)numberToString:(NSNumber *)val{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,###,###,##0.#########"];
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:val];
    [numberFormatter release];
    return formattedNumberString;
}
+ (NSNumber *)stringToNumber:(NSString *)valStr{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,###,###,##0.#########"];
    
    NSNumber *formattedNumber = [numberFormatter numberFromString:valStr];
    [numberFormatter release];
    return formattedNumber;
}

#pragma mark - 日期文字轉換
+ (NSString *)dateToString:(NSDate *)inDate{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];//[NSTimeZone timeZoneWithName:@"GMT"]];
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormat stringFromDate:inDate];
    
    [dateFormat release];
    return dateStr;
}
+ (NSDate *)stringToDate:(NSString *)dtStr{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];//[NSTimeZone timeZoneWithName:@"GMT"]];
    // Convert NSString object to desired output format
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *rdate = [dateFormat dateFromString:dtStr];
    
    [dateFormat release];
    return rdate;
}

+ (NSString *)nullString:(id)inStr{
    if (inStr == nil) {
        return @"";
    }
    if (![inStr isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return (NSString *)inStr;
    
}

+ (NSInteger)nullValue:(id)inVal{
    if (inVal == nil) {
        return 0;
    }
    if ([inVal isKindOfClass:[NSString class]]) {
        return [(NSString *)inVal integerValue];
    }
    return (NSInteger)[inVal integerValue];
}

+ (BOOL)nullBOOL:(id)inBool{
    if (inBool == nil) {
        return NO;
    }

    return [inBool boolValue];
    
}

+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData{
    NSError *error = nil;
    NSDictionary* jsondic = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:kNilOptions
                             error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
    }
    if ([jsondic isKindOfClass:[NSDictionary class]] ) {
        NSDictionary *Result = jsondic;
        
        return Result;
    }
    return nil;
}

+ (NSArray *)jsonDataToArray:(NSData *)jsonData{
    if (jsonData == nil) {
        return nil;
    }
    NSError *error = nil;
    NSArray* jsonarray = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:kNilOptions
                             error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
    }
    if ([jsonarray isKindOfClass:[NSArray class]] ) {
        NSArray *Result = jsonarray;
        
        return Result;
    }
    return nil;
}

@end




