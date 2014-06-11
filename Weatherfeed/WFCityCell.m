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
    
   // [[NSUserDefaults standardUserDefaults] setValue:false forKey:@"unidadTemormetrica"];
    

    WFCurrentWeather *currentWeather = city.currentWeather;
    
    self.cityNameLabel.text = city.name;
    
    //True Celsius - False Fahrenheit
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"unidadTemormetrica"]) {
        self.tempLabel.text =  [NSString stringWithFormat:@"%.0fº", [currentWeather.temp floatValue]];
    }else{
        self.tempLabel.text =  [NSString stringWithFormat:@"%.0fº", [self getCorrectTemp:[currentWeather.temp floatValue]]];
    }
    
    self.weatherImageView.image = [UIImage imageNamed:currentWeather.icon];
}

- (void)setSearchResult:(WFSearchResult*)result
{
    self.cityNameLabel.text = [NSString stringWithFormat:@"%@, %@", result.name, result.country];
    self.tempLabel.text = [NSString stringWithFormat:@"%.0fº", [result.temp floatValue]];
    self.weatherImageView.image = [UIImage imageNamed:result.icon];
}

- (float)getCorrectTemp:(float)temp{
    
    
    temp *= 9;
    temp /= 5;
    
    temp += 32;
    
    return temp;
}


@end
