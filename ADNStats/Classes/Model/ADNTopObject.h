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
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger number;

#pragma mark Instantiation
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary;
- (id)initWithTitle:(NSString *)title number:(NSUInteger)number;

@end
