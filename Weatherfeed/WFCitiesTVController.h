//
//  WFCitiesTVController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 17/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WFWeatherEngineDidRemoveCityNotification;

@interface WFCitiesTVController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
