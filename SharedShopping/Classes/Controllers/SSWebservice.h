//
//  SSWebservice.h
//  SharedShopping
//
//  Created by Zsolt Balint on 6/15/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "SSStorageControllerProtocol.h"
#import "SSShoppingList.h"

@interface SSWebservice : NSObject

// Properties
@property (nonatomic, retain) id<SSStorageControllerProtocol> storageController;

// Convenience methods
+ (SSWebservice *)sharedInstance;

// Public methods
- (void)refreshShoppingListElementsInShoppingList:(SSShoppingList *)shoppingList withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;
- (void)refreshShoppingListWithId:(NSString *)shoppingListId withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;
- (void)createShoppingListWithName:(NSString *)shoppingListName withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;
- (void)addShoppingListElementWithUserInfo:(NSDictionary *)userInfo toShoppingList:(SSShoppingList *)shoppingList withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;
- (void)updateShoppingListElement:(SSShoppingListElement *)shoppingListElement withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;
- (void)deleteShoppingListElement:(SSShoppingListElement *)shoppingListElement withCompletionBlock:(void (^)(void))completionBlock andFailBlock:(void (^)(NSError *error))failBlock;

@end