//
//  ADNStatsSummary.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNStatsSummary.h"

// Model
#import "ADNStatsPanel.h"

@interface ADNStatsSummary ()

#pragma mark Properties
@property (strong, nonatomic, readwrite) ADNStatsPanel *lasthourStatsPanel;
@property (strong, nonatomic, readwrite) ADNStatsPanel *lastdayStatsPanel;

@end

@implementation ADNStatsSummary

#pragma mark Properties
- (NSString *)formattedLastUpdate {
	NSString *formattedLastUpdate = nil;
	
	NSDate *lastUpdateDate = [NSDate dateWithTimeIntervalSince1970:self.lastUpdate];
	if (lastUpdateDate) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		formattedLastUpdate = [dateFormatter stringFromDate:lastUpdateDate];
	}
	
	return formattedLastUpdate;
}

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary {
	self = [self init];
	if (self) {
		// Get the Updated timestamp
		NSNumber *lastUpdate = [jsonDictionary objectForKey:@"updated"];
		if (lastUpdate) {
			self.lastUpdate = [lastUpdate doubleValue];
		}
		
		// Get the Hour Stats Panel
		NSDictionary *lasthourStatsPanelDictionary = [jsonDictionary objectForKey:@"hour"];
		if (lasthourStatsPanelDictionary) {
			self.lasthourStatsPanel = [[ADNStatsPanel alloc] initWithJsonDictionary:lasthourStatsPanelDictionary timeInterval:60.0*60.0];
		}
		
		// Get the Day Stats Panel
		NSDictionary *lastdayStatsPanelDictionary = [jsonDictionary objectForKey:@"day"];
		if (lastdayStatsPanelDictionary) {
			self.lastdayStatsPanel = [[ADNStatsPanel alloc] initWithJsonDictionary:lastdayStatsPanelDictionary timeInterval:60.0*60.0*24.0];
		}
	}
	return self;
}

@end
