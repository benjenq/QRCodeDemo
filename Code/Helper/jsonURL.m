//
//  jsonURL.m
//  EmptyProject
//
//  Created by Administrator on 2016/12/9.
//
//

#import "jsonURL.h"

@implementation jsonURL

+(void)jsonFromURL:(NSString *)urlStr method:(httpMethod)method completion:(void(^)(BOOL success,NSString *errorStr, NSString *resultJsonString, NSDictionary *resultDic))completion{
    
    NSString *encodeUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *aUrl = [NSURL URLWithString:encodeUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    if (method == httpMethodIsGET) {
        [request setHTTPMethod:@"GET"];
    }
    else if (method == httpMethodIsPOST) {
        [request setHTTPMethod:@"POST"];
    }
    else if (method == httpMethodIsPUT) {
        [request setHTTPMethod:@"PUT"];
    }
    else{
        [request setHTTPMethod:@"GET"];
    }

    NSHTTPURLResponse *response = NULL;
    NSError *error = nil;
    NSData *htmlData= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (error !=  nil) {
        NSLog(@"error=%@",error);
        completion(NO,[error localizedDescription],@"",nil);
        return ;
    }
    
    if (htmlData == nil) {
        completion(NO,@"resposeData is NULL",@"",nil);
        return ;
    }
    
    //NSLog(@"response=%@",response);
    
    NSString *resultStr = [[[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"htmlString=%@",htmlString);
    
    NSDictionary *result = [self responseJsonToDictionary:htmlData];
    
    if (result != nil) {
        completion(YES,@"",resultStr,result);
        return;
    }
    
    
    
}

+(NSDictionary *)responseJsonToDictionary:(NSData *)responseData{
    NSError *error = nil;
    NSDictionary* jsondic = [NSJSONSerialization
                             JSONObjectWithData:responseData
                             options:kNilOptions
                             error:&error];
    
    if (error !=  nil) {
        NSLog(@"responseJsonToDictionary error=%@",error);
        return nil;
    }
    if ([jsondic isKindOfClass:[NSDictionary class]] ) {
        NSDictionary *Result = jsondic;
        
        return Result;
    }

    return nil;
}

@end
