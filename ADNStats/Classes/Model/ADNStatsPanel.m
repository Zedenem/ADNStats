//
//  ADNStatsPanel.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNStatsPanel.h"

// Model
#import "ADNTopObject.h"
#import "ADNTopPost.h"

@interface ADNStatsPanel ()

#pragma mark Overview Properties
@property (assign, nonatomic, readwrite) NSTimeInterval timeInterval;
@property (assign, nonatomic, readwrite) NSUInteger numberOfPosts;
@property (assign, nonatomic, readwrite) NSUInteger numberOfUniqueUsers;
@property (assign, nonatomic, readwrite) double averageMessageLength;

#pragma mark Tops Properties
@property (strong, nonatomic) NSArray *topTalkers;
@property (strong, nonatomic) NSArray *topMentions;
@property (strong, nonatomic) NSArray *topHashtags;
@property (strong, nonatomic) NSArray *topPosts;

#pragma mark Sources Properties
@property (strong, nonatomic) NSArray *sources;

@end

@implementation ADNStatsPanel

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary timeInterval:(NSTimeInterval)timeInterval {
	self = [self init];
	if (self) {
		// Get the number of posts
		NSNumber *numberOfPosts = [jsonDictionary objectForKey:@"post_count"];
		if (numberOfPosts) {
			self.numberOfPosts = [numberOfPosts integerValue];
		}
		
		// Get the number of unique users
		NSNumber *numberOfUniqueUsers = [jsonDictionary objectForKey:@"unique_users"];
		if (numberOfUniqueUsers) {
			self.numberOfUniqueUsers = [numberOfUniqueUsers integerValue];
		}
		
		// Get the average message length
		NSNumber *averageMessageLength = [jsonDictionary objectForKey:@"post_length"];
		if (averageMessageLength) {
			self.averageMessageLength = [averageMessageLength doubleValue];
		}
		
		// Get the tops
		NSArray *topTalkers = [jsonDictionary objectForKey:@"top_talkers"];
		if (topTalkers) {
			NSMutableArray *mutableTopTalkers = [NSMutableArray arrayWithCapacity:[topTalkers count]];
			for (NSDictionary *topTalker in topTalkers) {
				[mutableTopTalkers addObject:[[ADNTopObject alloc] initWithJsonDictionary:topTalker]];
			}
			self.topTalkers = [NSArray arrayWithArray:mutableTopTalkers];
		}
		
		NSArray *topMentions = [jsonDictionary objectForKey:@"top_mentions"];
		if (topMentions) {
			NSMutableArray *mutableTopMentions = [NSMutableArray arrayWithCapacity:[topMentions count]];
			for (NSDictionary *topMention in topMentions) {
				[mutableTopMentions addObject:[[ADNTopObject alloc] initWithJsonDictionary:topMention]];
			}
			self.topMentions = [NSArray arrayWithArray:mutableTopMentions];
		}
		
		NSArray *topHashtags = [jsonDictionary objectForKey:@"top_hashtags"];
		if (topHashtags) {
			NSMutableArray *mutableTopHashtags = [NSMutableArray arrayWithCapacity:[topHashtags count]];
			for (NSDictionary *topHashtag in topHashtags) {
				[mutableTopHashtags addObject:[[ADNTopObject alloc] initWithJsonDictionary:topHashtag]];
			}
			self.topHashtags = [NSArray arrayWithArray:mutableTopHashtags];
		}
		
		NSArray *topPosts = [jsonDictionary objectForKey:@"top_posts"];
		if (topPosts) {
			NSMutableArray *mutableTopPosts = [NSMutableArray arrayWithCapacity:[topPosts count]];
			for (NSDictionary *topPost in topPosts) {
				[mutableTopPosts addObject:[[ADNTopPost alloc] initWithJsonDictionary:topPost]];
			}
			self.topPosts = [NSArray arrayWithArray:mutableTopPosts];
		}
	}
	return self;
}

#pragma mark Access Tops
- (NSUInteger)numberOfTopTalkers {
	return [self.topTalkers count];
}
- (ADNTopObject *)topTalkerAtIndex:(NSUInteger)index {
	return [self.topTalkers objectAtIndex:index];
}
- (NSUInteger)numberOfTopMentions {
	return [self.topMentions count];
}
- (ADNTopObject *)topMentionAtIndex:(NSUInteger)index {
	return [self.topMentions objectAtIndex:index];
}
- (NSUInteger)numberOfTopHashtags {
	return [self.topHashtags count];
}
- (ADNTopObject *)topHashtagAtIndex:(NSUInteger)index {
	return [self.topHashtags objectAtIndex:index];
}
- (NSUInteger)numberOfTopPosts {
	return [self.topPosts count];
}
- (ADNTopPost *)topPostAtIndex:(NSUInteger)index {
	return [self.topPosts objectAtIndex:index];
}

@end
