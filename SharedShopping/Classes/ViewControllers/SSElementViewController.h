//
//  SSElementViewController.h
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

@interface SSElementViewController : UIViewController <UITextFieldDelegate>

// Properties
@property (retain, nonatomic) SSShoppingList *shoppingList;
@property (retain, nonatomic) SSShoppingListElement *shoppingListElement;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *priceTextField;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;

// Actions
- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender;

@end