//
//  SSAddItemViewController.h
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

@interface SSAddItemViewController : UIViewController <UITextFieldDelegate>

// Properties
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UITextField *shoppingListNameTextField;

// Actions
- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender;

@end