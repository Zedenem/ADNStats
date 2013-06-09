//
//  ADNAuthenticationViewController.m
//  AppDotNetExample
//
//  Created by Zouhair on 08/06/13.
//  Copyright (c) 2013 Zedenem. All rights reserved.
//

#import "ADNAuthenticationViewController.h"

// Frameworks
#import <AppDotNet/AppDotNet.h>

@interface ADNAuthenticationViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)cancelAuthentication:(id)sender;

@end

@implementation ADNAuthenticationViewController

#pragma mark View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self requestAuthentication];
}

#pragma mark Initiate Authentication
- (void)requestAuthentication {
	ADNAuthenticationRequest *authRequest = [ADNAuthenticationRequest new];
	authRequest.clientId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADNClientId"];
	authRequest.responseType = ADNAuthenticationResponseTypeToken;
	authRequest.redirectURI = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADNRedirectURL"];
	authRequest.scopes = ADNScopeBasic | ADNScopeFiles;
	authRequest.appStoreCompliant = YES;
	
	NSURL *authURL = authRequest.URL;
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
}

- (IBAction)cancelAuthentication:(id)sender {
	[self.delegate authenticationViewController:self didFail:nil];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	BOOL shouldStartLoad = YES;
	if ([request.URL.absoluteString hasPrefix:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADNRedirectURL"]]) {
		shouldStartLoad = NO;
		NSDictionary *fragments = [self.class fragmentsFromURL:request.URL];
		
		if ([fragments objectForKey:@"access_token"]) {
			[self.delegate authenticationViewController:self didAuthenticate:[fragments objectForKey:@"access_token"]];
		}
		else {
			NSString *errorType = [[[fragments objectForKey:@"error"] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
			NSString *errorDescription = [[fragments objectForKey:@"error_description"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
			
			NSError *authenticationError = [NSError errorWithDomain:[fragments objectForKey:@"error"]
															   code:0
														   userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorType, NSLocalizedFailureReasonErrorKey, errorDescription, NSLocalizedDescriptionKey, nil]];
			
			[self.delegate authenticationViewController:self didFail:authenticationError];
		}
	}
	
	return shouldStartLoad;
}


#pragma mark Utility
+ (NSDictionary *)fragmentsFromURL:(NSURL *)url {
	NSMutableDictionary *fragmentDictionary = [NSMutableDictionary dictionary];
    NSArray *fragmentComponents = [url.fragment componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in fragmentComponents) {
        NSArray *keyValueComponents = [keyValuePair componentsSeparatedByString:@"="];
        
        NSString *key   = [keyValueComponents objectAtIndex:0];
        NSString *value = [keyValueComponents objectAtIndex:1];
        
        [fragmentDictionary setObject:value forKey:key];
    }
    
    return fragmentDictionary;
}
@end
