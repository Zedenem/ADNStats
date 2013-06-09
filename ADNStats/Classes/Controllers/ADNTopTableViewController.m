//
//  ADNTopTableViewController.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNTopTableViewController.h"

// Frameworks
#import <AppDotNet/AppDotNet.h>

// Views
#import "ADNTopTableViewCell.h"
#import "ADNTopPostTableViewCell.h"
#import "XYPieChart.h"

// Constants
#define kTopTalkersSection 0
#define kTopMentionsSection 1
#define kTopHashtagsSection 2
#define kTopPostsSection 3

// Utilities

#define RGBColor(x, y, z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

@interface ADNTopTableViewController () <XYPieChartDataSource, XYPieChartDelegate>

@property (weak, nonatomic) IBOutlet XYPieChart *sourcesPieChart;
@property (weak, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) NSArray *sliceColors;


@end

@implementation ADNTopTableViewController

#pragma mark View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStats:) name:ADNStatsClientGetStatsNotification object:nil];
	
	// Ugly setting depending on view controller index in tabbar...
	if ([self.tabBarController.viewControllers indexOfObject:self] == 1) {
		[self setStatsPanel:[ADNStatsClient sharedClient].statsSummary.lasthourStatsPanel];
	}
	else {
		[self setStatsPanel:[ADNStatsClient sharedClient].statsSummary.lastdayStatsPanel];
	}
	
	[self refreshAvatars];
	
    [self.sourcesPieChart setDataSource:self];
	[self.sourcesPieChart setDelegate:self];
    [self.sourcesPieChart setStartPieAngle:M_PI_2];
    [self.sourcesPieChart setAnimationSpeed:1.0];
    [self.sourcesPieChart setLabelFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.sourcesPieChart setLabelRadius:100.0];
    [self.sourcesPieChart setPieBackgroundColor:[UIColor blackColor]];
    [self.sourcesPieChart setLabelShadowColor:[UIColor blackColor]];
	[self.sourcesPieChart setShowPercentage:NO];
	[self.sourcesPieChart setShowLabel:YES];
	
    self.sliceColors = [NSArray arrayWithObjects:
						RGBColor(173.0, 217.0, 230.0),
						RGBColor(89.0, 189.0, 231.0),
						RGBColor(0.0, 165.0, 224.0),
						RGBColor(2.0, 123.0, 206.0),
						RGBColor(2.0, 101.0, 153.0),
						RGBColor(0.0, 74.0, 106.0),
						nil];
	
	[self.sourcesPieChart reloadData];
}
- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ADNStatsClientGetStatsNotification object:nil];
	[super viewDidUnload];
}

- (void)updateStats:(NSNotification *)notification {
	ADNStatsSummary *statsSummary = [notification.userInfo objectForKey:ADNStatsClientGetStatsNotification_userInfo_StatsSummary];
	
	// Ugly setting depending on view controller index in tabbar...
	if ([self.tabBarController.viewControllers indexOfObject:self] == 1) {
		[self setStatsPanel:statsSummary.lasthourStatsPanel];
	}
	else {
		[self setStatsPanel:statsSummary.lastdayStatsPanel];
	}
	[self.tableView reloadData];
	[self.sourcesPieChart reloadData];
	[self refreshAvatars];
}
- (void)refreshAvatars {
	if (self.statsPanel && [ADNClient sharedClient].accessToken) {
		for (int i = 0; i < [self.statsPanel numberOfTopPosts]; i++) {
			[[ADNClient sharedClient] getAvatarImageForUser:[NSString stringWithFormat:@"@%@", [self.statsPanel topPostAtIndex:i].username]
									  withCompletionHandler:^(UIImage *image, ADNMetadata *meta, NSError *error) {
										  [[self.statsPanel topPostAtIndex:i] setAvatarImage:image];
										  [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:kTopPostsSection]] withRowAnimation:UITableViewRowAnimationAutomatic];
									  }];
		}
	}
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionHeaderTitle = nil;
	switch (section) {
		case kTopTalkersSection:
			sectionHeaderTitle = NSLocalizedString(@"Top Talkers", nil);
			break;
		case kTopMentionsSection:
			sectionHeaderTitle = NSLocalizedString(@"Top Mentions", nil);
			break;
		case kTopHashtagsSection:
			sectionHeaderTitle = NSLocalizedString(@"Top Hashtags", nil);
			break;
		case kTopPostsSection:
			sectionHeaderTitle = NSLocalizedString(@"Top Posts", nil);
			break;
	}
	return sectionHeaderTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = 0;
	switch (section) {
		case kTopTalkersSection:
			numberOfRows = [self.statsPanel numberOfTopTalkers];
			break;
		case kTopMentionsSection:
			numberOfRows = [self.statsPanel numberOfTopMentions];
			break;
		case kTopHashtagsSection:
			numberOfRows = [self.statsPanel numberOfTopHashtags];
			break;
		case kTopPostsSection:
			numberOfRows = [self.statsPanel numberOfTopPosts];
			break;
	}
	return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = tableView.rowHeight;
	if (indexPath.section == kTopPostsSection) {
		rowHeight = 64.0;
	}
	return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id cell = nil;
	if (indexPath.section != kTopPostsSection) {
		static NSString *CellIdentifier = @"TopCellIdentifier";
		ADNTopTableViewCell *topTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
		
		ADNTopObject *topObject = nil;
		switch (indexPath.section) {
			case kTopTalkersSection:
				topObject = [self.statsPanel topTalkerAtIndex:indexPath.row];
				break;
			case kTopMentionsSection:
				topObject = [self.statsPanel topMentionAtIndex:indexPath.row];
				break;
			case kTopHashtagsSection:
				topObject = [self.statsPanel topHashtagAtIndex:indexPath.row];
				break;
		}
		
		[topTableViewCell.titleLabel setText:topObject.title];
		[topTableViewCell.numberLabel setText:[NSString stringWithFormat:@"%d", topObject.number]];
		
		cell = topTableViewCell;
	}
	else {
		static NSString *CellIdentifier = @"TopPostCellIdentifier";
		ADNTopPostTableViewCell *topPostTableViewCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
		
		ADNTopPost *topPost = [self.statsPanel topPostAtIndex:indexPath.row];
		
		[topPostTableViewCell.usernameLabel setText:topPost.username];
		[topPostTableViewCell.postLabel setText:topPost.postDescription];
		if (topPost.avatarImage) {
			[topPostTableViewCell.avatarImageView setImage:topPost.avatarImage];
		}
		else {
			[topPostTableViewCell.avatarImageView setImage:[UIImage imageNamed:@"avatar.png"]];
		}
		
		cell = topPostTableViewCell;
	}
	
    return cell;
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
	[headerView setBackgroundColor:[UIColor whiteColor]];
	
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, headerView.frame.size.width - 20.0, headerView.frame.size.height)];
	[headerView addSubview:headerLabel];
	[headerLabel setText:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
	[headerLabel setBackgroundColor:[UIColor clearColor]];
	[headerLabel setTextColor:[UIColor blackColor]];
	[headerLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
	
	return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark Pie chart data source
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return [self.statsPanel numberOfSources];
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return ((CGFloat)[self.statsPanel sourceAtIndex:index].numberOfPosts) / ((CGFloat)self.statsPanel.numberOfPosts);
}
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%@ (%d)", [self.statsPanel sourceAtIndex:index].sourcename, [self.statsPanel sourceAtIndex:index].numberOfPosts];
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark Pie chart delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
	[self.selectedSliceLabel setText:[pieChart.dataSource pieChart:pieChart textForSliceAtIndex:index]];
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index {
	[self.selectedSliceLabel setText:nil];
}

@end
