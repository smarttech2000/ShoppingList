//
//  SSShoppingListElement.h
//  SharedShopping
//
//  Created by Zsolt Balint on 6/16/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SSShoppingList;

@interface SSShoppingListElement : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) SSShoppingList *shoppingList;

@end
