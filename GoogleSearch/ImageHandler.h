//
//  ImageHandler.h
//  GoogleSearch
//
//  Created by Harald Rohan on 11/15/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ImageHandler : NSObject

+ (void)getImagesWithUrlString:(NSString *)urlString completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;
+ (void)getImageWithUrlString:(NSString *)urlString success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
