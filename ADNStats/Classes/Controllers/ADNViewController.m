//
//  ADNViewController.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNViewController.h"

// Frameworks
#import <AppDotNet/AppDotNet.h>

// Controllers
#import "ADNAuthenticationViewController.h"

// Model
#import "ADNStats.h"

// Constants
#define ADNAccessToken @"ADNAccessToken"

@interface ADNViewController () <ADNAuthenticationViewControllerDelegate>

#pragma mark Datas management
@property (strong, nonatomic) ADNStatsSummary *statsSummary;
- (IBAction)refreshStats;

#pragma mark Datas display UI
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPostsLastHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfUsersLastHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageMessageLengthLastHourLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *averageMessageLengthLastHourProgressView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPostsLastDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfUsersLastDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageMessageLengthLastDayLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *averageMessageLengthLastDayProgressView;

- (void)reloadData;

#pragma mark Loading & Errors UI
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *loginButton;


@end

@implementation ADNViewController

#pragma mark View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[ADNClient sharedClient] setAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:ADNAccessToken]];
	[self refreshStats];
}

#pragma mark Datas management
- (IBAction)refreshStats {
	if (!self.loadingView.superview) {
		[self.view addSubview:self.loadingView];
	}
	else {
		[self.loadingView.superview bringSubviewToFront:self.loadingView];
	}
	[self.loadingView setAlpha:1.0];
	if (![ADNClient sharedClient].accessToken) {
		[self.loginButton setAlpha:1.0];
		[self.loadingLabel setText:NSLocalizedString(@"You must be logged in", nil)];
	}
	else {
		[self.loginButton setAlpha:0.0];
		[self.loadingActivityIndicator startAnimating];
		[self.loadingLabel setText:NSLocalizedString(@"Loading App.Net stats...", nil)];
		[[ADNStatsClient sharedClient] getStatsWithCompletionHandler:^(ADNStatsSummary *statsSummary, NSError *error) {
			if (statsSummary) {
				[self setStatsSummary:statsSummary];
				[self reloadData];
				[UIView animateWithDuration:0.2
								 animations:^{
									 [self.loadingView setAlpha:0.0];
								 }
								 completion:^(BOOL finished) {
									 [self.loadingActivityIndicator stopAnimating];
									 [self.loadingView.superview sendSubviewToBack:self.loadingView];
								 }];
			}
			else {
				[self.loadingActivityIndicator stopAnimating];
				[self.loadingLabel setText:NSLocalizedString(@"An Error Occurred", nil)];
			}
		}];
	}
}

#pragma mark Datas display UI
- (void)reloadData {
	[self.lastUpdateLabel setText:self.statsSummary.formattedLastUpdate];
	
	[self.numberOfPostsLastHourLabel setText:[NSString stringWithFormat:@"%d", self.statsSummary.lasthourStatsPanel.numberOfPosts]];
	[self.numberOfUsersLastHourLabel setText:[NSString stringWithFormat:@"%d", self.statsSummary.lasthourStatsPanel.numberOfUniqueUsers]];
	[self.averageMessageLengthLastHourLabel setText:[NSString stringWithFormat:@"%.1f", self.statsSummary.lasthourStatsPanel.averageMessageLength]];
	[self.averageMessageLengthLastHourProgressView setProgress:self.statsSummary.lasthourStatsPanel.averageMessageLength/kMaximumMessageLength animated:YES];
	
	[self.numberOfPostsLastDayLabel setText:[NSString stringWithFormat:@"%d", self.statsSummary.lastdayStatsPanel.numberOfPosts]];
	[self.numberOfUsersLastDayLabel setText:[NSString stringWithFormat:@"%d", self.statsSummary.lastdayStatsPanel.numberOfUniqueUsers]];
	[self.averageMessageLengthLastDayLabel setText:[NSString stringWithFormat:@"%.1f", self.statsSummary.lastdayStatsPanel.averageMessageLength]];
	[self.averageMessageLengthLastDayProgressView setProgress:self.statsSummary.lastdayStatsPanel.averageMessageLength/kMaximumMessageLength animated:YES];
}

#pragma mark Segue Management
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showAuthenticationSegue"]) {
		UINavigationController *navigationController = segue.destinationViewController;
		ADNAuthenticationViewController *authenticationViewController = ((ADNAuthenticationViewController *)navigationController.visibleViewController);
		[authenticationViewController setDelegate:self];
	}
}

#pragma mark ADNAuthenticationViewControllerDelegate methods
- (void)authenticationViewController:(ADNAuthenticationViewController *)authenticationViewController didFail:(NSError *)error {
	if (error) {
		[[[UIAlertView alloc] initWithTitle:error.localizedFailureReason message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}
	[authenticationViewController dismissViewControllerAnimated:YES completion:^{}];
}
- (void)authenticationViewController:(ADNAuthenticationViewController *)authenticationViewController didAuthenticate:(NSString *)accessToken {
	[authenticationViewController dismissViewControllerAnimated:YES completion:^{}];
	[[ADNClient sharedClient] setAccessToken:accessToken];
	[[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:ADNAccessToken];
	[self refreshStats];
}

@end
