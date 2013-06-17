//
//  SSShoppingList.h
//  SharedShopping
//
//  Created by Zsolt Balint on 6/16/13.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SSShoppingListElement;

@interface SSShoppingList : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *elements;
@end

@interface SSShoppingList (CoreDataGeneratedAccessors)

- (void)addElementsObject:(SSShoppingListElement *)value;
- (void)removeElementsObject:(SSShoppingListElement *)value;
- (void)addElements:(NSSet *)values;
- (void)removeElements:(NSSet *)values;

@end
