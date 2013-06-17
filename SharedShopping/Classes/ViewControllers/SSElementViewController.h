//
//  SSElementViewController.h
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSElementViewController : UIViewController

@property (retain, nonatomic) SSShoppingList* shoppingList;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *priceTextField;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;

@end
