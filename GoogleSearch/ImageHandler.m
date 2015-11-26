//
//  ImageHandler.m
//  GoogleSearch
//
//  Created by Harald Rohan on 11/15/15.
//  Copyright (c) 2015 Harald Rohan. All rights reserved.
//

#import "ImageHandler.h"

@implementation ImageHandler


/**
 * Sends a data task request to the given url and calls the given completion handler
 */

+ (void)getImagesWithUrlString:(NSString *)urlString completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:completionHandler];
    [dataTask resume];
}


@end
