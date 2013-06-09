//
//  ADNAuthenticationViewController.h
//  AppDotNetExample
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADNAuthenticationViewController;
@protocol ADNAuthenticationViewControllerDelegate <NSObject>

- (void)authenticationViewController:(ADNAuthenticationViewController *)authenticationViewController didFail:(NSError *)error;
- (void)authenticationViewController:(ADNAuthenticationViewController *)authenticationViewController didAuthenticate:(NSString *)accessToken;

@end

@interface ADNAuthenticationViewController : UIViewController

@property (weak, nonatomic) id<ADNAuthenticationViewControllerDelegate> delegate;

@end
