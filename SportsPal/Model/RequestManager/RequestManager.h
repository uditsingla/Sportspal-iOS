//
//  RequestManager.h
//  Voice
//
//  Created by Kabir Chandoke on 7/8/14.
//  Copyright (c) 2014 Kabir Chandoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"


typedef enum
{
    RequestTypePOST     = 0,
    RequestTypeGET      = 1,
    RequestTypeDELETE   = 2,
    RequestTypePUT      = 3
} RequestType;

@interface RequestManager : NSObject

@property (nonatomic,assign) RequestType requestType;
@property (nonatomic,assign) BOOL        isInternetReachable;
typedef   void (^JSONResponseBlock)(long statusCode,NSDictionary* json);

+(void)asynchronousRequestWithPath:(NSString *)strPath
                       requestType:(RequestType)type
                            params:(NSDictionary *)dictParams
                           timeOut:(NSInteger)timeOut
                    includeHeaders:(BOOL)include
                      onCompletion:(JSONResponseBlock)completionBlock;

-(void)synchronousRequestWithPath:(NSString *)strPath
                      requestType:(RequestType)type
                           params:(NSDictionary *)dictParams
                          timeOut:(NSInteger)timeOut
                   includeHeaders:(BOOL)include
                     onCompletion:(JSONResponseBlock)completionBlock;

-(NSMutableURLRequest *) requestWithPath:(NSString *)strPath
                             requestType:(RequestType)type
                                 timeOut:(NSInteger)time
                           includeHeader:(BOOL)includeHeaders
                              paramsDict:(NSDictionary *)parameterDictionary;
@end
