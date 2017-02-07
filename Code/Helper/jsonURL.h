//
//  jsonURL.h
//  EmptyProject
//
//  Created by Administrator on 2016/12/9.
//
//

#import <Foundation/Foundation.h>

@interface jsonURL : NSObject

typedef NS_ENUM(NSUInteger,httpMethod)
{
    httpMethodIsPOST = 0,
    httpMethodIsGET = 1,
    httpMethodIsPUT = 2
};

+(void)jsonFromURL:(NSString *)urlStr method:(httpMethod)method completion:(void(^)(BOOL success,NSString *errorStr, NSString *resultJsonString, NSDictionary *resultDic))completion;

@end
