//
//  ADNViewController.m
//  ADNStats
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNViewController.h"

// Frameworks
#import <SBJson/SBJson.h>

@interface ADNViewController ()

@end

@implementation ADNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"json"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *statsDictionary = [parser objectWithData:[NSData dataWithContentsOfFile:path]];
		NSLog(@"statsDictionary : %@", statsDictionary);
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
