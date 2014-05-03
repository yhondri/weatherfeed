//
//  WFSearchCityViewController.m
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 01/05/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFSearchCityViewController.h"
#import "WFCitySearcher.h"

@interface WFSearchCityViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *citiesFound;

@end

@implementation WFSearchCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ResultCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)search:(id)sender
{
    [WFCitySearcher searchForCity:self.searchTextField.text
                     onCompletion:^(NSArray *citiesFound) {
                         self.citiesFound = citiesFound;
                         [self.tableView reloadData];
                     }];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.citiesFound count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ResultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    WFSearchResult *city = self.citiesFound[indexPath.row];
    
    cell.textLabel.text = city.description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WFSearchResult *result = self.citiesFound[indexPath.row];
    
    [WFCitySearcher saveResult:result];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
