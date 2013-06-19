//
//  SSAppDelegate.m
//  SharedShopping
//
//  Created by Zsolt Balint on 6/14/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSWebservice.h"
#import "SSModelController.h"

@implementation SSAppDelegate

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_window release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[SSWebservice sharedInstance].storageController = [SSModelController sharedInstance];
	
	return YES;
}

@end