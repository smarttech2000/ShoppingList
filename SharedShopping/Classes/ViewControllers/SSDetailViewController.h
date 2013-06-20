//
//  SSDetailViewController.h
//  SharedShopping
//
//  Created by Ilea Cristian on 6/17/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"

@interface SSDetailViewController : UITableViewController <EGORefreshTableHeaderDelegate, NSFetchedResultsControllerDelegate>

// Properties
@property (nonatomic, retain) SSShoppingList *selectedShoppingList;

@end