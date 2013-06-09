//
//  ADNStatsSummary.h
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADNStatsPanel;

@interface ADNStatsSummary : NSObject

#pragma mark Properties
@property (assign, nonatomic) NSTimeInterval lastUpdate;
@property (strong, nonatomic, readonly) NSString *formattedLastUpdate;
@property (strong, nonatomic, readonly) ADNStatsPanel *lasthourStatsPanel;
@property (strong, nonatomic, readonly) ADNStatsPanel *lastdayStatsPanel;

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary;

@end
