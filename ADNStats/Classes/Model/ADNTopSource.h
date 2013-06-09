//
//  ADNTopSource.h
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopObject.h"

@interface ADNTopSource : ADNTopObject

#pragma mark Properties
@property (strong, nonatomic, readonly) NSNumber *identifier;
@property (strong, nonatomic, readonly) NSString *sourcename;
@property (assign, nonatomic, readonly) NSUInteger numberOfPosts;

#pragma mark Instantiation
- (id)initWithSourcename:(NSString *)sourcename numberOfPosts:(NSUInteger)numberOfPosts;

@end
