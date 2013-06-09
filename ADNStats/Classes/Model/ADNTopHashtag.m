//
//  ADNTopHashtag.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopHashtag.h"

@implementation ADNTopHashtag

#pragma mark Properties
@dynamic hashtag;
- (NSString *)hashtag {
	return self.title;
}

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary {
	self = [super initWithJsonDictionary:jsonDictionary];
	if (self) {
		// Get the label
		self.title = [jsonDictionary objectForKey:@"hashtag"];
	}
	return self;
}

@end
