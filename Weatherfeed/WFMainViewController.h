//
//  WFMainViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 15/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@class WFMainViewController;

@protocol WFMainViewControllerDelegate <NSObject>
- (void)mainViewController:(WFMainViewController*)mainViewController didSelectCityAtIndex:(NSInteger)index;
@end


@interface WFMainViewController : UIViewController <UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) id<WFMainViewControllerDelegate> delegate;

@property NSUInteger pageIndex;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skyImageView;
@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCityButton;

@property (weak, nonatomic) IBOutlet UISearchBar *citySearchBar;


- (IBAction)addCity:(id)sender;

@end
