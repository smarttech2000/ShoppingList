//
//  SSModelController.m
//  SharedShopping
//
//  Created by Zsolt Balint on 6/15/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSModelController.h"
#import "SynthesizeSingleton.h"
#import "IPCoreDataController.h"
#import "SSShoppingList.h"

@interface SSModelController() {
	IPCoreDataController *_coreDataController;
}

@end

#pragma mark -

@implementation SSModelController

#pragma mark -
#pragma mark Singleton implementation

SYNTHESIZE_SINGLETON_FOR_CLASS(SSModelController);

#pragma mark -
#pragma mark Initialization

- (id)init {
	if (self = [super init]) {
		_coreDataController = [[IPCoreDataController alloc] initWithDatabaseName:@"SharedShopping"];
	}
	return self;
}

#pragma mark -
#pragma mark Getters and setters

- (NSFetchedResultsController *)shoppingList {
    if (_shoppingList) {
        return _shoppingList;
    }
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	_shoppingList = [[_coreDataController frcForEntityName:@"SSShoppingList" andSortDescriptors:sortDescriptors andSectionNameKeyPath:nil andPredicate:nil] retain];
	
	[sortDescriptor release];
	[sortDescriptors release];
	
	[_shoppingList performFetch:nil];
	
	return _shoppingList;
}

- (NSFetchedResultsController *)shoppingListElement {
    if (_shoppingListElement) {
        return _shoppingListElement;
    }
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	_shoppingListElement = [[_coreDataController frcForEntityName:@"SSShoppingListElement" andSortDescriptors:sortDescriptors andSectionNameKeyPath:nil andPredicate:nil] retain];
	
	[sortDescriptor release];
	[sortDescriptors release];
	
	[_shoppingListElement performFetch:nil];
	
	return _shoppingListElement;
}

- (NSFetchedResultsController*)getShoppingListElementForShoppingList:(SSShoppingList*)selectedList {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(shoppingList == %@)", selectedList];


	_shoppingListElement = [[_coreDataController frcForEntityName:@"SSShoppingListElement" andSortDescriptors:sortDescriptors andSectionNameKeyPath:nil andPredicate:predicate] retain];

	[sortDescriptor release];
	[sortDescriptors release];

	[_shoppingListElement performFetch:nil];

	return _shoppingListElement;

}


#pragma mark -
#pragma mark SSStorageControllerProtocol methods

- (SSShoppingList *)aShoppingList {
	return (SSShoppingList *)[_coreDataController anObjectByEntityForName:@"SSShoppingList"];
}

- (SSShoppingListElement *)aShoppingListElement {
	return (SSShoppingListElement *)[_coreDataController anObjectByEntityForName:@"SSShoppingListElement"];
}

- (SSShoppingList *)aShoppingListById:(NSString *)id {
	return (SSShoppingList *)[_coreDataController anObjectByEntityForName:@"SSShoppingList" withUserInfo:@{@"id" : id}];
}

- (SSShoppingListElement *)aShoppingListElementByName:(NSString *)name andShoppingList:(SSShoppingList *)shoppingList {
	return (SSShoppingListElement *)[_coreDataController anObjectByEntityForName:@"SSShoppingListElement" withUserInfo:@{@"name" : name, @"shoppingList.id" : shoppingList.id}];
}

- (void)deleteShoppingListElement:(SSShoppingListElement *)shoppingListElement {
	[_coreDataController deleteObject:(NSManagedObject *)shoppingListElement];
}

- (void)save {
	[_coreDataController save];
}

@end