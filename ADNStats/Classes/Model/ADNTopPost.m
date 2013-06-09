//
//  ADNTopPost.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopPost.h"

@interface ADNTopPost ()

#pragma mark Properties
@property (strong, nonatomic, readwrite) NSNumber *identifier;
@property (strong, nonatomic, readwrite) NSString *postDescription;

@end

@implementation ADNTopPost

#pragma mark Properties
@dynamic username;
- (NSString *)username {
	return self.title;
}

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary {
	self = [super initWithJsonDictionary:jsonDictionary];
	if (self) {
		// Get the Identifier
		self.identifier = [jsonDictionary objectForKey:@"id"];
		// Get the Post Description
		self.postDescription = [jsonDictionary objectForKey:@"post"];
	}
	return self;
}

@end
