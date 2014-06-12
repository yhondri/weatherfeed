//
//  WFSettingsTVController.m
//  Weatherfeed
//
//  Created by Guillermo Cique Fernández on 12/06/14.
//  Copyright (c) 2014 Codegy. All rights reserved.
//

#import "WFSettingsTVController.h"

#import "WFAppDelegate.h"

NSString * const WFSettingsTVControllerChangedCelsius = @"WFSettingsTVControllerChangedCelsius";

@interface WFSettingsTVController ()

@property (strong, nonatomic) IBOutlet UITableViewCell *celsiusCell;
@property (weak, nonatomic) IBOutlet UISwitch *celciusSwitch;

@property (strong, nonatomic) IBOutlet UITableViewCell *eraseCitiesCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *sendFeedbackCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *rateAppCell;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@end

@implementation WFSettingsTVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:self.footerView];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:27/255.0 green:155/255.0 blue:251/255.0 alpha:1]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.title = NSLocalizedString(@"Settings", nil);
    
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                target:self
                                                                                action:@selector(exit)];
    self.navigationItem.leftBarButtonItem = exitButton;
    
    [self.celciusSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"UseCelsius"]];
}

- (void)exit
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 2;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
            return self.celsiusCell;
        case 1:
            return self.eraseCitiesCell;
        case 2:
            switch (indexPath.row) {
                case 0:
                    return self.sendFeedbackCell;
                case 1:
                    return self.rateAppCell;
            }
    }
    
    return cell;
}


- (IBAction)temperatureMeasurementChanged:(UISwitch *)sender
{
#warning set default
    [[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:@"UseCelsius"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WFSettingsTVControllerChangedCelsius object:nil];
}

- (IBAction)goToCodegy:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://Codegy.com"]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 1:
            [self eraseCities];
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    [self sendFeedback];
                    break;
                    
                case 1:
                    [self rateThisApp];
                    break;
            }
            break;
    }
}

- (void)eraseCities
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erase cities", nil)
                                                    message:NSLocalizedString(@"Are you sure you want to erase every city?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteAllObjectsWithEntityName:@"Teacher"];
        [self deleteAllObjectsWithEntityName:@"Subject"];
        [self deleteAllObjectsWithEntityName:@"Holyday"];
    }
}

- (void)deleteAllObjectsWithEntityName:(NSString*)entity
{
    NSManagedObjectContext *context = [[WFAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *movement in fetchedObjects) {
        [context deleteObject:movement];
    }
    
    [context save:nil];
}

- (void)rateThisApp
{
#warning EGWRGWRH
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id"]];
}

- (void)sendFeedback
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        vc.mailComposeDelegate = self;
        
        [vc setToRecipients:@[@"contact@Codegy.com"]];
        [vc setSubject:@"Feedback Weatherfeed"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                        message:NSLocalizedString(@"Not available", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if (section == 2) {
        title = [NSString stringWithFormat:@"Weatherfeed %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    }
    
    return title;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title = nil;
    
    if (section == 2) {
        title = NSLocalizedString(@"Send us suggestions, questions or any information regarding any problem you may have encountered.", nil);
    }
    
    return title;
}

@end
