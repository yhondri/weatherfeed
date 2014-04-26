//
//  WFMainViewController.h
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 15/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFMainViewController : UIViewController <UISearchBarDelegate>

@property NSUInteger pageIndex;

- (IBAction)addCity:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skyImageView;
@property (weak, nonatomic) IBOutlet UITableView *citiesTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCityButton;

@property (weak, nonatomic) IBOutlet UISearchBar *citySearchBar;

@end
