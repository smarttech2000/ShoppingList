//
//  SSAddItemViewController.m
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSAddItemViewController.h"
#import "SSWebservice.h"

@interface SSAddItemViewController(SSAddItemViewControllerPrivate)
- (void)addShoppingListWithName:(NSString *)shoppingListName;
@end

#pragma mark -

@implementation SSAddItemViewController

#pragma mark -
#pragma mark Initialization

- (void)viewDidAppear:(BOOL)animated {
	[self.shoppingListNameTextField becomeFirstResponder];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.shoppingListNameTextField = nil;
	
	self.activityIndicator = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self addShoppingListWithName:textField.text];
	return YES;
}

#pragma mark -
#pragma mark Actions

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
	[self addShoppingListWithName:self.shoppingListNameTextField.text];
}

@end

#pragma mark -

@implementation SSAddItemViewController(SSAddItemViewControllerPrivate)

- (void)addShoppingListWithName:(NSString *)shoppingListName {
	if (shoppingListName.length == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill the name of the shopping list" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[self.view endEditing:YES];
	self.view.userInteractionEnabled = NO;
	[self.activityIndicator startAnimating];
	
	SSAddItemViewController *weakSelf = [self retain];
	[[SSWebservice sharedInstance] createShoppingListWithName:shoppingListName withCompletionBlock:^{
		weakSelf.view.userInteractionEnabled = YES;
		[weakSelf.activityIndicator stopAnimating];
		[weakSelf.navigationController popViewControllerAnimated:YES];
		[weakSelf release];
	} andFailBlock:^(NSError *error) {
		weakSelf.view.userInteractionEnabled = YES;
		[weakSelf.activityIndicator stopAnimating];
		[weakSelf release];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
		[alert release];
	}];
}

@end