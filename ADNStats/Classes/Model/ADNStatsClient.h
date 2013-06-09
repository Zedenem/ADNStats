//
//  ADNStatsClient.h
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notifications
#define ADNStatsClientGetStatsNotification @"ADNStatsClientGetStatsNotification"
#define ADNStatsClientGetStatsNotification_userInfo_StatsSummary @"ADNStatsClientGetStatsNotification_userInfo_StatsSummary"

@class ADNStatsSummary;

@interface ADNStatsClient : NSObject

#pragma mark Properties
@property (strong, nonatomic) ADNStatsSummary *statsSummary;

#pragma mark Shared Instance
+ (instancetype)sharedClient;

#pragma mark Retrieving Stats
- (void)getStatsWithCompletionHandler:(void (^)(ADNStatsSummary *statsSummary, NSError *error))completionHandler;

@end
