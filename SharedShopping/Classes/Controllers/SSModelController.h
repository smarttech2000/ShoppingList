//
//  SSModelController.h
//  SharedShopping
//
//  Created by Zsolt Balint on 6/15/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SSStorageControllerProtocol.h"
#import "SSShoppingList.h"

@interface SSModelController : NSObject <SSStorageControllerProtocol>

// Properties
@property (nonatomic, retain) NSFetchedResultsController *shoppingList;
@property (nonatomic, retain) NSFetchedResultsController *shoppingListElement;

// Convenience methods
+ (SSModelController *)sharedInstance;
- (NSFetchedResultsController*)getShoppingListElementForShoppingList:(SSShoppingList*)selectedList;

@end