//
//  SSAppDelegate.m
//  SharedShopping
//
//  Created by Zsolt Balint on 6/14/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSAppDelegate.h"

@implementation SSAppDelegate

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_window release];
	
    [super dealloc];
}

@end