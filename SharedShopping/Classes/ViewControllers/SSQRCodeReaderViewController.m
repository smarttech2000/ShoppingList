//
//  SSQRCodeReaderViewController.m
//  SharedShopping
//
//  Created by Zsolt Balint on 6/19/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSQRCodeReaderViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SSQRCodeReaderViewController ()

// Properties
@property (nonatomic, retain) ZXCapture *capture;

@end

#pragma mark -

@implementation SSQRCodeReaderViewController

#pragma mark -
#pragma mark Properties

- (void)viewDidAppear:(BOOL)animated {
	[super awakeFromNib];
	
	if (!self.capture) {
		self.capture = [[[ZXCapture alloc] init] autorelease];
		self.capture.delegate = self;
		self.capture.rotation = 90.0f;
		self.capture.camera = self.capture.back;
		self.capture.layer.frame = self.view.bounds;
		[self.view.layer addSublayer:self.capture.layer];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.capture.delegate = nil;
	
    self.capture = nil;
	
	self.delegate = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark ZXCaptureDelegate methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
	@synchronized (self) {
		if (result) {
			self.capture.delegate = nil;
			
			[self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:@YES waitUntilDone:NO];
			
			if ([self.delegate respondsToSelector:@selector(qrCodeReaderViewController:foundText:)]) {
				[self.delegate qrCodeReaderViewController:self foundText:result.text];
			}
			
			// Vibrate
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		}
	}
}

@end