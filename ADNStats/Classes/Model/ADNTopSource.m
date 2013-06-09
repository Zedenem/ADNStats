//
//  ADNTopSource.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopSource.h"

@interface ADNTopObject ()

#pragma mark Properties
@property (strong, nonatomic, readwrite) NSString *title;
@property (assign, nonatomic, readwrite) NSUInteger number;

@end

@interface ADNTopSource ()

#pragma mark Properties
@property (strong, nonatomic, readwrite) NSNumber *identifier;

@end

@implementation ADNTopSource

#pragma mark Properties
@dynamic sourcename;
- (NSString *)sourcename {
	return self.title;
}
@dynamic numberOfPosts;
- (NSUInteger)numberOfPosts {
	return self.number;
}

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary {
	self = [super initWithJsonDictionary:jsonDictionary];
	if (self) {
		// Get the Identifier
		self.identifier = [jsonDictionary objectForKey:@"id"];
		// Get the label
		self.title = [jsonDictionary objectForKey:@"source"];
		// Get the number
		NSNumber *number = [jsonDictionary objectForKey:@"posts"];
		if (number) {
			self.number = [number integerValue];
		}
	}
	return self;
}
- (id)initWithSourcename:(NSString *)sourcename numberOfPosts:(NSUInteger)numberOfPosts {
	self = [super initWithTitle:sourcename number:numberOfPosts];
	if (self) {
	}
	return self;
}

@end
