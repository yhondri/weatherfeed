//
//  WFDailyTableViewCell.m
//  Weatherfeed
//
//  Created by Yhondri Josue Acosta Novas on 14/04/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFDayCell.h"
#import "WFDay.h"

@interface WFDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;

@property (weak, nonatomic) IBOutlet UIImageView *morningImageView;
@property (weak, nonatomic) IBOutlet UILabel *morningTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *afternoonImageView;
@property (weak, nonatomic) IBOutlet UILabel *afternoonTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eveningImageView;
@property (weak, nonatomic) IBOutlet UILabel *eveningTempLabel;

@property (weak, nonatomic) IBOutlet UIImageView *windImageView;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;

@end

@implementation WFDayCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDay:(WFDay *)day
{
    _day = day;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, dd 'de' MMMM"];
    
    NSString *dateString = [dateFormatter stringFromDate:day.date];
    NSString *firstCapChar = [[dateString substringToIndex:1] capitalizedString];
    self.dateLabel.text = [dateString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    
    UIImage *image = [UIImage imageNamed:day.icon];
    [self.morningImageView setImage:image];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"unidadTemormetrica"]) {
        
        self.maxTempLabel.text = [NSString stringWithFormat:@"%.0fº", [day.maxTemp floatValue]];
        self.minTempLabel.text = [NSString stringWithFormat:@"%.0fº", [day.minTemp floatValue]];
        
    }else{
        
        self.maxTempLabel.text = [NSString stringWithFormat:@"%.0fº", [self getCorrectTemp:[day.maxTemp floatValue]]];
        self.minTempLabel.text = [NSString stringWithFormat:@"%.0fº", [self getCorrectTemp:[day.minTemp floatValue]]];
    }
    
    
    self.precipitationLabel.text = [NSString stringWithFormat:@"%.1f mm", [day.precipitation floatValue]];
    
    //    [self.windImageView setImageWithURL:[NSURL URLWithString:hour.windImage]];
    self.windLabel.text = [NSString stringWithFormat:@"%@ km/h", day.windSpeed];
    
    self.afternoonTempLabel.text = [NSString stringWithFormat:@"%.0fº", [day.morningTemp floatValue]];
    self.eveningTempLabel.text = [NSString stringWithFormat:@"%.0fº", [day.eveningTemp floatValue]];
}

- (float)getCorrectTemp:(float)temp{
    
    temp *= 9;
    temp /= 5;
    
    temp += 32;
    
    return temp;
}


@end
