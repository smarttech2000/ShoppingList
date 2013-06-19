//
//  SSDetailViewController.h
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

@interface SSDetailViewController : UITableViewController <NSFetchedResultsControllerDelegate>

// Properties
@property (nonatomic, retain) SSShoppingList *selectedShoppingList;

@end