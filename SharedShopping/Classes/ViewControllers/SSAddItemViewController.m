//
//  SSAddItemViewController.m
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSAddItemViewController.h"

@interface SSAddItemViewController ()

@end

@implementation SSAddItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonTapped:(id)sender {
    //TODO save the shopping list if textfield not empty
    // alert if textfield empty

    if ([self.newShoppingListNameTextField.text length]) {
        SSShoppingList* newShoppingList = [[SSModelController sharedInstance] aShoppingList];
        newShoppingList.name = self.newShoppingListNameTextField.text;

        [[SSModelController sharedInstance] save];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please fill the name of the shopping list"
                                   delegate:nil cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

- (void)dealloc {
    [_newShoppingListNameTextField release];
    [super dealloc];
}
@end
