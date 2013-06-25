//
//  IPCoreDataController.m
//  InPosKit
//
//  Created by Zsolt Balint.
//  Copyright (c) 2013 InPos Soft. All rights reserved.
//

#import "IPCoreDataController.h"

@interface IPCoreDataController()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSString *databaseName;
@end

@interface IPCoreDataController(IPCoreDataControllerPrivate)
- (NSURL *)applicationDocumentsDirectory;
@end

#pragma mark -

@implementation IPCoreDataController

#pragma mark -
#pragma mark Properties

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark -
#pragma mark Initialization

- (id)initWithDatabaseName:(NSString *)databaseName {
	if (self = [self initWithDatabaseName:databaseName andInitialDatabaseName:nil]) {
	}
	return self;
}

- (id)initWithDatabaseName:(NSString *)databaseName andInitialDatabaseName:(NSString *)initialDatabaseName {
	if (self = [super init]) {
		self.databaseName = databaseName;
		
		NSURL *storeURL = nil;
		if (initialDatabaseName) {
			storeURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:initialDatabaseName] URLByAppendingPathExtension:@"sqlite"];
		} else {
			storeURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:databaseName]  URLByAppendingPathExtension:@"sqlite"];
		}
		
		if (initialDatabaseName && ![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
			NSString *initialDatabaseExtension = [initialDatabaseName pathExtension];
			NSString *initialDatabaseFileName = [initialDatabaseName stringByDeletingPathExtension];
			[[NSFileManager defaultManager] copyItemAtURL:[[NSBundle mainBundle] URLForResource:initialDatabaseFileName withExtension:initialDatabaseExtension] toURL:storeURL error:nil];
		}
	}
	return self;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [_managedObjectContext release];
	[_managedObjectModel release];
	[_persistentStoreCoordinator release];
	
	self.databaseName = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (NSManagedObject *)anObjectByEntityForName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

- (NSManagedObject *)anObjectByEntityForName:(NSString *)entityName withUserInfo:(NSDictionary *)userInfo {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
	
	__block NSMutableString *formatString = [NSMutableString string];
	__block NSMutableArray *anArray = [NSMutableArray arrayWithCapacity:userInfo.count];
	[userInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[formatString appendString:@"%K == %@ &&"];
		[anArray addObject:key];
		[anArray addObject:obj];
	}];
	[request setPredicate:[NSPredicate predicateWithFormat:[formatString substringToIndex:formatString.length - 3] argumentArray:anArray]];
	
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (!mutableFetchResults) {
		[request release];
		[mutableFetchResults release];
		return nil;
	}
	
	if ([mutableFetchResults count] == 0) {
		[request release];
		[mutableFetchResults release];
		return nil;
	}
	
	id anObject = [mutableFetchResults objectAtIndex:0];
	[request release];
	[mutableFetchResults release];
	
	return anObject;
}

- (NSFetchedResultsController *)frcForEntityName:(NSString *)entityName andSortDescriptors:(NSArray *)sortDescs andSectionNameKeyPath:(NSString *)keyPath andPredicate:(NSPredicate *)predicate {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	[fetchRequest setSortDescriptors:sortDescs];
	
	if (predicate) {
		[fetchRequest setPredicate:predicate];
	}
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *anFRC = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:keyPath cacheName:nil] autorelease];
	[fetchRequest release];
	
	return anFRC;
}

- (void)deleteObject:(NSManagedObject *)object {
	[self.managedObjectContext deleteObject:object];
}

- (void)save {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark Getters and setters

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.databaseName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.databaseName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

@end

#pragma mark -

@implementation IPCoreDataController(IPCoreDataControllerPrivate)

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end