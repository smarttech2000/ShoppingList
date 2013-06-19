//
//  SSQrCodeViewController.m
//  SharedShopping
//
//  Created by Zsolt Balint on 6/19/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSQrCodeViewController.h"
#import "ZXingObjC.h"

@implementation SSQrCodeViewController

#pragma mark -
#pragma mark Initialization

- (void)viewWillAppear:(BOOL)animated {
	NSError *error = nil;
	ZXBitMatrix *result = [[ZXMultiFormatWriter writer] encode:self.shoppingList.id format:kBarcodeFormatQRCode width:self.view.bounds.size.width height:self.view.bounds.size.width error:&error];
	if (result) {
		CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
		self.qrCodeImageView.image = [UIImage imageWithCGImage:image];
		[self.qrCodeImageView sizeToFit];
		self.qrCodeImageView.center = self.view.center;
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	self.navigationItem.title = self.shoppingList.name;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.shoppingList = nil;
	
	self.qrCodeImageView = nil;
	
    [super dealloc];
}

@end