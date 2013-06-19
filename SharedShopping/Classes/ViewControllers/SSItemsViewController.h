//
//  SSItemsViewController.h
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSQRCodeReaderViewController.h"

@interface SSItemsViewController : UITableViewController <UIActionSheetDelegate, NSFetchedResultsControllerDelegate, SSQRCodeReaderViewControllerDelegate>

// Actions
- (IBAction)addButtonPushed:(UIBarButtonItem *)sender;

@end