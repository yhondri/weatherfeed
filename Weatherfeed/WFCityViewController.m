//
//  WFCityViewController.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 07/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFCityViewController.h"
#import "WFAppDelegate.h"
#import "WFWeatherEngine.h"
#import "WFHoursTVController.h"
#import "WFDaysTVController.h"

#import "WFCity.h"
#import "WFCurrentWeather.h"
#import "WFHour.h"
#import "WFDay.h"


@interface WFCityViewController ()

@property(strong,nonatomic) WFCity *city;

@property (strong, nonatomic) WFHoursTVController *hourlyTVC;
@property (strong, nonatomic) WFDaysTVController *dailyTVC;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIView *currentWeatherView;
@property (weak, nonatomic) IBOutlet UIImageView *currentWeatherIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UITableView *hoursTableView;
@property (weak, nonatomic) IBOutlet UITableView *daysTableView;

@end

@implementation WFCityViewController

- (id)initWithCity:(WFCity*)city
{
    if (self = [super init]) {
        
        self.city = city;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadCurrentWeatherData)
                                                name:WFWeatherEngineDidUpdateNotification
                                              object:nil];
    
    self.hourlyTVC = [[WFHoursTVController alloc] initWithCity:self.city];
    self.hourlyTVC.tableView = self.hoursTableView;
    [self.hoursTableView registerNib:[UINib nibWithNibName:@"WFHourCell" bundle:[NSBundle mainBundle]]
              forCellReuseIdentifier:@"HourCell"];
    
    self.dailyTVC = [[WFDaysTVController alloc] initWithCity:self.city];
    self.dailyTVC.tableView = self.daysTableView;
    [self.daysTableView registerNib:[UINib nibWithNibName:@"WFDayCell" bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"DayCell"];
    
    self.hoursTableView.contentInset = UIEdgeInsetsMake(130, 0, 44, 0);
    self.hoursTableView.scrollIndicatorInsets = UIEdgeInsetsMake(130, 0, 44, 0);
    self.daysTableView.contentInset = UIEdgeInsetsMake(130, 0, 44, 0);
    self.daysTableView.scrollIndicatorInsets = UIEdgeInsetsMake(130, 0, 44, 0);
    
    self.hoursTableView.scrollsToTop = YES;
    self.daysTableView.scrollsToTop = NO;
    
    [self reloadCurrentWeatherData];
}


- (void)reloadCurrentWeatherData
{
    NSLog(@"CURRENT WEATHER DATA HAS BEEN UPDATED");
    
    WFCurrentWeather *currentWeather = self.city.currentWeather;
    
    self.currentTemp.text = [NSString stringWithFormat:@"%.1fº", [currentWeather.temp floatValue]];
    self.cityName.text = self.city.name;
    
    self.currentWeatherIconImageView.image = [UIImage imageNamed:currentWeather.icon];
}

- (IBAction)periodSegmentControlChanged:(UISegmentedControl*)sender {
    BOOL showHours = sender.selectedSegmentIndex == 0;
    
    self.hoursTableView.scrollsToTop = showHours;
    self.daysTableView.scrollsToTop = !showHours;
    
    if (showHours) {
        [self.hoursTableView setHidden:NO];
    }
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.hoursTableView.alpha = showHours? 1: 0;
                     }
                     completion:^(BOOL finished) {
                         if (!showHours) {
                             [self.hoursTableView setHidden:YES];
                         }
                     }];
}


@end
