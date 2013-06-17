//
//  SSElementViewController.m
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSElementViewController.h"

@interface SSElementViewController ()

@end

@implementation SSElementViewController

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

    // TODO propper validation of textfields
    if ([self.nameTextField.text length] &&
        [self.priceTextField.text length] &&
        [self.amountTextField.text length])
    {

        SSShoppingListElement* newShoppingListElement = [[SSModelController sharedInstance] aShoppingListElement];
        // set parrent
        newShoppingListElement.shoppingList = self.shoppingList;
        newShoppingListElement.name = self.nameTextField.text;
        newShoppingListElement.price = [NSNumber numberWithInt:[self.priceTextField.text intValue]];
        newShoppingListElement.amount = [NSNumber numberWithInt:[self.amountTextField.text intValue]];


        [[SSModelController sharedInstance] save];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please fill all the required fields"
                                   delegate:nil cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

-(IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_nameTextField release];
    [_priceTextField release];
    [_amountTextField release];
    [super dealloc];
}
@end
