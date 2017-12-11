//
//  NSManagedObject+SVExtensions.h
//  smartVIEW_v3
//
//  Created by Valentin Strazdin on 5/8/13.
//  Copyright (c) 2013 Arcadia, ZAO. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#define APP_DELEGATE		((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface NSManagedObject (SVExtensions)
// We insert new Managed Object
+ (id)createNew;
// We can specify predicate for fetch request and return first object from fetched Results array
// If corresponding object was not found and parameter createNewIfNotFound = YES then we insert new Managed Object
+ (id)cachedObjectWithPredicate:(NSPredicate *)predicate
            createNewIfNotFound:(BOOL)createNewIfNotFound;
// We can specify predicate, sortDescriptor for fetch request and return fetched Results array
+ (NSArray *)cachedObjectsWithPredicate:(NSPredicate *)predicate
                        sortDescriptors:(NSArray *)sortDescriptors;
// We can specify predicate for fetch request and delete all matching objects
+ (void)deleteCachedObjectsWithPredicate:(NSPredicate *)predicate;

+ (NSFetchRequest *)fetchedRequestWithPredicate:(NSPredicate *)predicate
                                sortDescriptors:(NSArray *)sortDescriptors;

// Return objects for managed object context in current thread
+ (NSArray *)objectsInCurrentThread:(NSArray *)objects;

- (instancetype)objectInCurrentThread;

- (void)deleteAllObjects:(NSArray *)array;

@end
