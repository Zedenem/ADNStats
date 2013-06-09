//
//  ADNTopPost.h
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopObject.h"

@interface ADNTopPost : ADNTopObject

#pragma mark Properties
@property (strong, nonatomic, readonly) NSNumber *identifier;
@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic, readonly) NSString *postDescription;

@end
