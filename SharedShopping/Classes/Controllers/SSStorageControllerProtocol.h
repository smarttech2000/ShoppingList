//
//  SSStorageControllerProtocol.h
//  SharedShopping
//
//  Created by Zsolt Balint on 6/15/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

@class SSShoppingList;
@class SSShoppingListElement;

@protocol SSStorageControllerProtocol <NSObject>

- (SSShoppingList *)aShoppingList;
- (SSShoppingListElement *)aShoppingListElement;
- (SSShoppingList *)aShoppingListById:(NSString *)id;
- (SSShoppingListElement *)aShoppingListElementByName:(NSString *)name andShoppingList:(SSShoppingList *)shoppingList;
- (void)deleteShoppingListElement:(SSShoppingListElement *)shoppingListElement;
- (void)save;

@end