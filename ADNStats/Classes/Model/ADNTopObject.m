//
//  ADNTopObject.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopObject.h"

@interface ADNTopObject ()

#pragma mark Properties
@property (strong, nonatomic, readwrite) NSString *title;
@property (assign, nonatomic, readwrite) NSUInteger number;

@end

@implementation ADNTopObject

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary {
	self = [self init];
	if (self) {
		// Get the label
		self.title = [jsonDictionary objectForKey:@"username"];
		// Get the number
		NSNumber *number = [jsonDictionary objectForKey:@"posts"];
		if (number) {
			self.number = [number integerValue];
		}
	}
	return self;
}

@end
