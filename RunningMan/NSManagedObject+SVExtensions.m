//
//  NSManagedObject+SVExtensions.m
//  smartVIEW_v3
//
//  Created by Valentin Strazdin on 5/8/13.
//  Copyright (c) 2013 Arcadia, ZAO. All rights reserved.
//

#import "NSManagedObject+SVExtensions.h"

@implementation NSManagedObject (SVExtensions)

+ (id)createNew {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:APP_DELEGATE.managedObjectContext];
}

+ (id)cachedObjectWithPredicate:(NSPredicate *)thePredicate
            createNewIfNotFound:(BOOL)createNewIfNotFound {
    NSArray *fetchedResults = [[self class] cachedObjectsWithPredicate:thePredicate sortDescriptors:nil];
    NSManagedObject *cachedObject = nil;
    
    if (fetchedResults != nil && [fetchedResults count] > 0) {
        cachedObject = [fetchedResults objectAtIndex:0];
    }
    
    if (!cachedObject && createNewIfNotFound) {
//        NSLog(@"New object created");
        cachedObject = [[self class] createNew];
    }
    return cachedObject;
}

+ (NSArray *)cachedObjectsWithPredicate:(NSPredicate *)thePredicate
                        sortDescriptors:(NSArray *)theSortDescriptors {
    NSFetchRequest *fetchRequest = [[self class] fetchedRequestWithPredicate:thePredicate
                                                             sortDescriptors:theSortDescriptors];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *fetchedResults = [APP_DELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (error) {
        NSLog(@"Get Cached Objects failed! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
        return nil;
    }
    else {
        return fetchedResults;
    }
}

+ (void)deleteCachedObjectsWithPredicate:(NSPredicate *)thePredicate {
    NSArray *fetchedResults = [[self class] cachedObjectsWithPredicate:thePredicate sortDescriptors:nil];
    if (fetchedResults != nil && [fetchedResults count] > 0) {
        for (int i = 0; i < [fetchedResults count]; i++) {
            NSManagedObject *object = (NSManagedObject *)fetchedResults[i];
            [APP_DELEGATE.managedObjectContext deleteObject:object];
        }
        [APP_DELEGATE saveContext];
    }
}

+ (NSFetchRequest *)fetchedRequestWithPredicate:(NSPredicate *)thePredicate
                                sortDescriptors:(NSArray *)theSortDescriptors {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                              inManagedObjectContext:APP_DELEGATE.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (thePredicate) {
        [fetchRequest setPredicate:thePredicate];
    }
    if (theSortDescriptors) {
        [fetchRequest setSortDescriptors:theSortDescriptors];
    }
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    return fetchRequest;
}

- (instancetype)objectInCurrentThread {

    NSLog(@"objectInCurrentThread: %@", NSStringFromClass( self.class));
    
    NSManagedObject* obj = nil;
    NSError * err;;

        obj = [APP_DELEGATE.managedObjectContext existingObjectWithID:self.objectID error:&err];
        if (!obj) {
            NSLog(@"!!! Get object in current thread error: %@ %@", err, [err userInfo]);
                    abort();
        }
    return obj;
}

- (void)deleteAllObjects:(NSArray *)array {
    for (NSManagedObject *object in array) {
        [self.managedObjectContext deleteObject:object];
    }
}


+ (NSArray *)objectsInCurrentThread:(NSArray *)objects {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:objects.count];
    for (NSManagedObject *object in objects) {
        [result addObject:[object objectInCurrentThread]];
    }

    return result;
}

@end
