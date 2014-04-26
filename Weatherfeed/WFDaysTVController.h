//
//  WFDailyTableViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 14/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFCity;

@interface WFDaysTVController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (id)initWithCity:(WFCity*)city;

@end
