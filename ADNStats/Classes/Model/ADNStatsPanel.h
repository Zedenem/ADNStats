//
//  ADNStatsPanel.h
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADNTopObject;
@class ADNTopPost;
@class ADNTopSource;

@interface ADNStatsPanel : NSObject

#pragma mark Properties
@property (assign, nonatomic, readonly) NSTimeInterval timeInterval;
@property (assign, nonatomic, readonly) NSUInteger numberOfPosts;
@property (assign, nonatomic, readonly) NSUInteger numberOfUniqueUsers;
@property (assign, nonatomic, readonly) double averageMessageLength;

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary timeInterval:(NSTimeInterval)timeInterval;

#pragma mark Access Tops
- (NSUInteger)numberOfTopTalkers;
- (ADNTopObject *)topTalkerAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfTopMentions;
- (ADNTopObject *)topMentionAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfTopHashtags;
- (ADNTopObject *)topHashtagAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfTopPosts;
- (ADNTopPost *)topPostAtIndex:(NSUInteger)index;

#pragma mark Access Sources
- (NSUInteger)numberOfSources;
- (ADNTopSource *)sourceAtIndex:(NSUInteger)index;

@end
