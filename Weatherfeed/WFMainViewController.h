//
//  WFMainViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 15/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import "WFViewController.h"

@class WFMainViewController;

@interface WFMainViewController : WFViewController <UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skyImageView;
@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;


- (IBAction)addCity:(id)sender;

@end
