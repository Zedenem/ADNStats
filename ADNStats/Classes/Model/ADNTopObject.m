//
//  ADNTopObject.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopObject.h"

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
- (id)initWithTitle:(NSString *)title number:(NSUInteger)number {
	self = [self init];
	if (self) {
		self.title = title;
		self.number = number;
	}
	return self;
}

@end
