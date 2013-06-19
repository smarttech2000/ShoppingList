//
//  SSWebservice.m
//  SharedShopping
//
//  Created by Zsolt Balint on 6/15/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import <northpole/NPStorage.h>
#import "SSWebservice.h"
#import "SynthesizeSingleton.h"
#import "SSShoppingList.h"
#import "SSShoppingListElement.h"

@implementation SSWebservice

#pragma mark -
#pragma mark Singleton implementation

SYNTHESIZE_SINGLETON_FOR_CLASS(SSWebservice);

#pragma mark -
#pragma mark Public methods

- (void)refreshShoppingListElementsInShoppingList:(SSShoppingList *)shoppingList withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock {
	NSDictionary *params = @{@"api_key": @"guest@northpole.ro", @"secret": @"guest", @"id" : shoppingList.id};
	NPStorage *storage = [[[NPStorage alloc] initWithParams:params] autorelease];
	__block SSShoppingList *weakShoppingList = [shoppingList retain];
	[storage findWithCompletionBlock:^(id responseObject) {
		NSDictionary *response = responseObject[0];
		weakShoppingList.name = response[@"namespace"];
		__block NSMutableSet *existingElements = [NSMutableSet set];
		[(NSArray *)response[@"storage"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
			SSShoppingListElement *element = [self.storageController aShoppingListElementByName:obj[@"name"] andShoppingList:weakShoppingList];
			if (!element) {
				element = [self.storageController aShoppingListElement];
				element.name = obj[@"name"];
				element.shoppingList = weakShoppingList;
			}
			element.price = obj[@"price"];
			element.amount = obj[@"amount"];
			[existingElements addObject:element];
		}];
		
		NSMutableSet *deleteSet = [NSMutableSet setWithSet:weakShoppingList.elements];
		[deleteSet minusSet:existingElements];
		[deleteSet enumerateObjectsUsingBlock:^(SSShoppingListElement *obj, BOOL *stop) {
			[self.storageController deleteShoppingListElement:obj];
		}];
		
		[self.storageController save];
		
		[weakShoppingList release];
		completionBlock();
	} andFailBlock:^(NSError *error) {
		failBlock(error);
		[weakShoppingList release];
	}];
}

- (void)createShoppingListWithName:(NSString *)shoppingListName withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock {
	NSDictionary *params = @{@"api_key": @"guest@northpole.ro", @"secret": @"guest", @"namespace" : shoppingListName, @"storage": @[]};
	NPStorage *storage = [[[NPStorage alloc] initWithParams:params] autorelease];
	__block NSString *weakListName = [shoppingListName retain];
	[storage createWithCompletionBlock:^(id responseObject) {
		SSShoppingList *shoppingList = [self.storageController aShoppingList];
		shoppingList.name = weakListName;
		shoppingList.id = responseObject[@"id"];
		[self.storageController save];
		[weakListName release];
		completionBlock();
	} andFailBlock:^(NSError *error) {
		failBlock(error);
		[weakListName release];
	}];
}

- (void)addShoppingListElementWithUserInfo:(NSDictionary *)userInfo toShoppingList:(SSShoppingList *)shoppingList withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock {
	SSShoppingListElement *shoppingListElement = [self.storageController aShoppingListElementByName:userInfo[@"name"] andShoppingList:shoppingList];
	if (shoppingListElement) {
		shoppingListElement.price = @([userInfo[@"price"] doubleValue]);
		shoppingListElement.amount = @([userInfo[@"amount"] doubleValue] + [shoppingListElement.amount doubleValue]);
		[self updateShoppingListElement:shoppingListElement withCompletionBlock:^{
			completionBlock();
		} andFailBlock:^(NSError *error) {
			failBlock(error);
		}];
		return;
	}
	
	__block NSMutableArray *storageArray = [NSMutableArray array];
	[shoppingList.elements enumerateObjectsUsingBlock:^(SSShoppingListElement *element, BOOL *stop) {
		[storageArray addObject:@{@"name" : element.name, @"price" : element.price, @"amount" : element.amount}];
	}];
	[storageArray addObject:userInfo];
	NSDictionary *params = @{@"api_key": @"guest@northpole.ro", @"secret": @"guest", @"id" : shoppingList.id, @"namespace" : shoppingList.name, @"storage" : [NSArray arrayWithArray:storageArray]};
	NPStorage *storage = [[[NPStorage alloc] initWithParams:params] autorelease];
	
	__block SSShoppingList *weakShoppingList = [shoppingList retain];
	[storage updateWithCompletionBlock:^(id responseObject) {
		[self refreshShoppingListElementsInShoppingList:weakShoppingList withCompletionBlock:^{
			completionBlock();
			[weakShoppingList release];
		} andFailBlock:^(NSError *error) {
			failBlock(error);
			[weakShoppingList release];
		}];
	} andFailBlock:^(NSError *error) {
		failBlock(error);
		[weakShoppingList release];
	}];
}

- (void)updateShoppingListElement:(SSShoppingListElement *)shoppingListElement withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock {
	__block NSMutableArray *storageArray = [NSMutableArray array];
	[shoppingListElement.shoppingList.elements enumerateObjectsUsingBlock:^(SSShoppingListElement *element, BOOL *stop) {
		[storageArray addObject:@{@"name" : element.name, @"price" : element.price, @"amount" : element.amount}];
	}];
	NSDictionary *params = @{@"api_key": @"guest@northpole.ro", @"secret": @"guest", @"id" : shoppingListElement.shoppingList.id, @"namespace" : shoppingListElement.shoppingList.name, @"storage" : [NSArray arrayWithArray:storageArray]};
	NPStorage *storage = [[[NPStorage alloc] initWithParams:params] autorelease];
	
	__block SSShoppingList *weakShoppingList = [shoppingListElement.shoppingList retain];
	[storage updateWithCompletionBlock:^(id responseObject) {
		[self refreshShoppingListElementsInShoppingList:weakShoppingList withCompletionBlock:^{
			completionBlock();
			[weakShoppingList release];
		} andFailBlock:^(NSError *error) {
			failBlock(error);
			[weakShoppingList release];
		}];
	} andFailBlock:^(NSError *error) {
		failBlock(error);
		[weakShoppingList release];
	}];
}

- (void)deleteShoppingListElement:(SSShoppingListElement *)shoppingListElement withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock {
	__block NSMutableArray *storageArray = [NSMutableArray array];
	__block SSShoppingListElement *weakShoppingListElement = shoppingListElement;
	[shoppingListElement.shoppingList.elements enumerateObjectsUsingBlock:^(SSShoppingListElement *element, BOOL *stop) {
		if (element != weakShoppingListElement) {
			[storageArray addObject:@{@"name" : element.name, @"price" : element.price, @"amount" : element.amount}];
		}
	}];
	NSDictionary *params = @{@"api_key": @"guest@northpole.ro", @"secret": @"guest", @"id" : shoppingListElement.shoppingList.id, @"namespace" : shoppingListElement.shoppingList.name, @"storage" : [NSArray arrayWithArray:storageArray]};
	NPStorage *storage = [[[NPStorage alloc] initWithParams:params] autorelease];
	
	__block SSShoppingList *weakShoppingList = [shoppingListElement.shoppingList retain];
	[storage updateWithCompletionBlock:^(id responseObject) {
		[self refreshShoppingListElementsInShoppingList:weakShoppingList withCompletionBlock:^{
			completionBlock();
			[weakShoppingList release];
		} andFailBlock:^(NSError *error) {
			failBlock(error);
			[weakShoppingList release];
		}];
	} andFailBlock:^(NSError *error) {
		failBlock(error);
		[weakShoppingList release];
	}];
}

@end