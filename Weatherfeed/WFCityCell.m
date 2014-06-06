//
//  WFCityCell.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 17/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFCityCell.h"
#import "WFCity.h"
#import "WFCurrentWeather.h"
#import "WFSearchResult.h"

@interface WFCityCell ()

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@end

@implementation WFCityCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)setCity:(WFCity*)city
{
    WFCurrentWeather *currentWeather = city.currentWeather;
    
    self.cityNameLabel.text = city.name;
    self.tempLabel.text =  [NSString stringWithFormat:@"%.0fº", [currentWeather.temp floatValue]];
    self.weatherImageView.image = [UIImage imageNamed:currentWeather.icon];
}

- (void)setSearchResult:(WFSearchResult*)result
{
    self.cityNameLabel.text = [NSString stringWithFormat:@"%@, %@", result.name, result.country];
    self.tempLabel.text = [NSString stringWithFormat:@"%.0fº", [result.temp floatValue]];
    self.weatherImageView.image = [UIImage imageNamed:result.icon];
}

@end
