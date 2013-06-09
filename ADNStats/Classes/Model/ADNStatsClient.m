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

// Model
#import "ADNStatsSummary.h"

@implementation ADNStatsClient

#pragma mark Shared Instance
+ (instancetype)sharedClient {
    static ADNStatsClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ADNStatsClient alloc] initWithBaseURL:nil];
    });
    
    return _sharedClient;
}

#pragma mark Retrieving Stats
- (void)getStatsWithCompletionHandler:(void (^)(ADNStatsSummary *statsSummary, NSError *error))completionHandler {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
		NSDictionary *statsDictionary = nil;
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			statsDictionary = [parser objectWithData:[NSData dataWithContentsOfFile:path]];
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			self.statsSummary = [[ADNStatsSummary alloc] initWithJsonDictionary:statsDictionary];
			[[NSNotificationCenter defaultCenter] postNotificationName:ADNStatsClientGetStatsNotification
																object:nil
															  userInfo:[NSDictionary dictionaryWithObject:self.statsSummary
																								   forKey:ADNStatsClientGetStatsNotification_userInfo_StatsSummary]];
			completionHandler(self.statsSummary, nil);
		});
	});
}

@end
