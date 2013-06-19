//
//  SSQRCodeReaderViewController.h
//  SharedShopping
//
//  Created by Zsolt Balint on 6/19/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "ZXingObjC.h"

@protocol SSQRCodeReaderViewControllerDelegate;

@interface SSQRCodeReaderViewController : UIViewController <ZXCaptureDelegate>

// Properties
@property (nonatomic, assign) id<SSQRCodeReaderViewControllerDelegate> delegate;

@end

@protocol SSQRCodeReaderViewControllerDelegate <NSObject>
@optional
- (void)qrCodeReaderViewController:(SSQRCodeReaderViewController *)qrCodeReaderViewController foundText:(NSString *)text;
@end