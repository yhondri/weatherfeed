//
//  WFHourlyTableViewCell.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 09/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFHourCell.h"
#import "WFHour.h"

@interface WFHourCell ()

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UIImageView *windImageView;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;

@end

@implementation WFHourCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setHour:(WFHour *)hour
{
    _hour = hour;
    
    if ([hour.date compare:[NSDate date]] == NSOrderedDescending) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        
        self.hourLabel.text = [dateFormatter stringFromDate:hour.date];
    }
    else {
        self.hourLabel.text = @"Ahora";
    }
    
    UIImage *image = [UIImage imageNamed:hour.icon];
    [self.weatherImageView setImage:image];
    
    self.tempLabel.text = [NSString stringWithFormat:@"%.1fº", [hour.temp floatValue]];
    self.precipitationLabel.text = [NSString stringWithFormat:@"%.1f mm", [hour.precipitation floatValue]];
    
//    [self.windImageView setImageWithURL:[NSURL URLWithString:hour.windImage]];
    self.windLabel.text = [NSString stringWithFormat:@"%@ km/h", hour.windSpeed];
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%@ %%", hour.humidity];
    self.pressureLabel.text = [NSString stringWithFormat:@"%@ pas", hour.pressure];
}

@end
