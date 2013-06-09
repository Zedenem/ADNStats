//
//  ADNStatsClient.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNStatsClient.h"

// Frameworks
#import <SBJson/SBJson.h>
#import <AppDotNet/AFJSONRequestOperation.h>

// Model
#import "ADNStatsSummary.h"

@implementation ADNStatsClient

#pragma mark Shared Instance
+ (instancetype)sharedClient {
    static ADNStatsClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ADNStatsClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://appnetstats.cerebralgardens.com/"]];
    });
    
    return _sharedClient;
}

#pragma mark Retrieving Stats
- (void)getStatsWithCompletionHandler:(void (^)(ADNStatsSummary *statsSummary, NSError *error))completionHandler {
	AFJSONRequestOperation *requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[self requestWithMethod:@"GET" path:@"demo.json" parameters:nil]
																							   success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
																								   self.statsSummary = [[ADNStatsSummary alloc] initWithJsonDictionary:JSON];
																								   [[NSNotificationCenter defaultCenter] postNotificationName:ADNStatsClientGetStatsNotification
																																					   object:nil
																																					 userInfo:[NSDictionary dictionaryWithObject:self.statsSummary
																																														  forKey:ADNStatsClientGetStatsNotification_userInfo_StatsSummary]];
																								   completionHandler(self.statsSummary, nil);
																							   }
																							   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
																								   completionHandler(nil, error);
																							   }];
	[requestOperation start];
}

@end
