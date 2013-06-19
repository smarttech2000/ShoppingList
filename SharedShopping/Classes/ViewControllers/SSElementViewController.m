//
//  SSElementViewController.m
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSElementViewController.h"
#import "SSWebservice.h"

@interface SSElementViewController(SSElementViewControllerPrivate)
- (void)addShoppingListElementWithName:(NSString *)name andPrice:(NSString *)price andAmount:(NSString *)amount;
- (void)updateShoppingElementWithName:(NSString *)name andPrice:(NSString *)price andAmount:(NSString *)amount;
@end

@implementation SSElementViewController

#pragma mark -
#pragma mark Initialization

- (void)viewWillAppear:(BOOL)animated {
	if (self.shoppingListElement) {
		self.nameTextField.text = self.shoppingListElement.name;
		self.nameTextField.enabled = NO;
		self.nameTextField.borderStyle = UITextBorderStyleNone;

		self.priceTextField.text = [self.shoppingListElement.price stringValue];
		[self.priceTextField becomeFirstResponder];
		
		self.amountTextField.text = [self.shoppingListElement.amount stringValue];
	} else {
		self.nameTextField.enabled = YES;
		self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
		[self.nameTextField becomeFirstResponder];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_nameTextField release];
	[_priceTextField release];
	[_amountTextField release];
	[_activityIndicator release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.priceTextField becomeFirstResponder];
	
	return YES;
}

#pragma mark -
#pragma mark Actions

- (IBAction)doneButtonTapped:(id)sender {
	if (self.shoppingListElement) {
		[self updateShoppingElementWithName:self.nameTextField.text andPrice:self.priceTextField.text andAmount:self.amountTextField.text];
		return;
	}
	
	[self addShoppingListElementWithName:self.nameTextField.text andPrice:self.priceTextField.text andAmount:self.amountTextField.text];
}

@end

#pragma mark -

@implementation  SSElementViewController(SSElementViewControllerPrivate)

- (void)addShoppingListElementWithName:(NSString *)name andPrice:(NSString *)price andAmount:(NSString *)amount {
	if (name.length == 0 || price.length == 0 || amount.length == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill all the required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[self.view endEditing:YES];
	self.view.userInteractionEnabled = NO;
	[self.activityIndicator startAnimating];
	
	SSElementViewController *weakSelf = [self retain];
	NSDictionary *userInfo = @{@"name" : name, @"price" : @([price doubleValue]), @"amount" : @([amount integerValue])};
	[[SSWebservice sharedInstance] addShoppingListElementWithUserInfo:userInfo toShoppingList:self.shoppingList withCompletionBlock:^{
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

- (void)updateShoppingElementWithName:(NSString *)name andPrice:(NSString *)price andAmount:(NSString *)amount {
	if (name.length == 0 || price.length == 0 || amount.length == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill all the required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	self.shoppingListElement.name = name;
	self.shoppingListElement.price = @([price doubleValue]);
	self.shoppingListElement.amount = @([amount integerValue]);
	
	[self.view endEditing:YES];
	self.view.userInteractionEnabled = NO;
	[self.activityIndicator startAnimating];
	
	SSElementViewController *weakSelf = [self retain];
	[[SSWebservice sharedInstance] updateShoppingListElement:self.shoppingListElement withCompletionBlock:^{
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