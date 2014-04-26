//
//  WFAppDelegate.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 27/01/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface WFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (WFAppDelegate*)sharedAppDelegate;

@end
