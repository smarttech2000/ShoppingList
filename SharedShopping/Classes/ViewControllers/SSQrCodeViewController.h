//
//  SSQrCodeViewController.h
//  SharedShopping
//
//  Created by Zsolt Balint on 6/19/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

@interface SSQrCodeViewController : UIViewController

// Properties
@property (retain, nonatomic) SSShoppingList *shoppingList;
@property (retain, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end