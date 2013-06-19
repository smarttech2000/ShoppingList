//
//  SSQrCodeViewController.m
//  SharedShopping
//
//  Created by Zsolt Balint on 6/19/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSQrCodeViewController.h"
#import "QREncoder.h"

@implementation SSQrCodeViewController

- (void)viewWillAppear:(BOOL)animated {
	DataMatrix *dataMatrix = [QREncoder encodeWithECLevel:0 version:0 string:self.shoppingList.id];
	self.qrCodeImageView.image = [QREncoder renderDataMatrix:dataMatrix imageDimension:self.view.bounds.size.width];
	[self.qrCodeImageView sizeToFit];
	self.qrCodeImageView.center = self.view.center;
	
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