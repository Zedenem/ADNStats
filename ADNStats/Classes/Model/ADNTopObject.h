//
//  ADNTopObject.h
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNTopObject : NSObject

#pragma mark Properties
@property (strong, nonatomic, readonly) NSString *title;
@property (assign, nonatomic, readonly) NSUInteger number;

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary;

@end
