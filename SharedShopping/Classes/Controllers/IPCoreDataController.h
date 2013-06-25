//
//  IPCoreDataController.h
//  InPosKit
//
//  Created by Zsolt Balint.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface IPCoreDataController : NSObject

// Initialization
- (id)initWithDatabaseName:(NSString *)databaseName;
- (id)initWithDatabaseName:(NSString *)databaseName andInitialDatabaseName:(NSString *)initialDatabaseName;

// Public methods
- (NSManagedObject *)anObjectByEntityForName:(NSString *)entityName;
- (NSManagedObject *)anObjectByEntityForName:(NSString *)entityName withUserInfo:(NSDictionary *)userInfo;
- (NSFetchedResultsController *)frcForEntityName:(NSString *)entityName andSortDescriptors:(NSArray *)sortDescs andSectionNameKeyPath:(NSString *)keyPath andPredicate:(NSPredicate *)predicate;
- (void)deleteObject:(NSManagedObject *)object;
- (void)save;

@end