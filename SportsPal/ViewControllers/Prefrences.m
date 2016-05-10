//
//  Prefrences.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Prefrences.h"
#import "Sport.h"

@interface Prefrences ()
{
    
    __weak IBOutlet UITableView *tblPrefrences;
    NSMutableArray *arrSelectedPrefrences;
    
}
- (IBAction)clkBack:(id)sender;
- (IBAction)clkDone:(id)sender;

@end

@implementation Prefrences

@synthesize isFromProfileView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    arrSelectedPrefrences = [NSMutableArray new];
    
    if(model_manager.profileManager.owner.arrayPreferredSports.count>0)
        [arrSelectedPrefrences addObjectsFromArray:model_manager.profileManager.owner.arrayPreferredSports];
    
    tblPrefrences.backgroundColor = [UIColor clearColor];
    
    [kAppDelegate.objLoader show];
    [model_manager.sportsManager getSports:^(NSDictionary *dictJson, NSError *error) {
        [kAppDelegate.objLoader hide];
        [tblPrefrences reloadData];
    }];
    
    [tblPrefrences reloadData];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clkBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clkDone:(id)sender
{
    NSLog(@"done");
    if(arrSelectedPrefrences.count>0)
    {
        [kAppDelegate.objLoader show];
        [model_manager.profileManager.owner addPreferredSports:arrSelectedPrefrences :^(NSDictionary *dictJson, NSError *error) {
            [kAppDelegate.objLoader hide];
            if(!error)
            {
                if([[dictJson valueForKey:@"success"] boolValue])
                {
                    if(isFromProfileView)
                    {
                        //go back
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        //goto home screen
                        UIViewController *homeVC = [kMainStoryboard instantiateInitialViewController];
                        [self.navigationController pushViewController:homeVC animated:YES];
                    }
                }
                else
                {
                    [self showAlert:[dictJson valueForKey:@"message"]];
                }
            }

        }];
    }
}

-(void)showAlert:(NSString *)errorMsg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:errorMsg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             //   [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
}

#pragma mark - Delegates and Tatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = ((Sport*)[model_manager.sportsManager.arraySports objectAtIndex:indexPath.row]).sportName;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"sportID == %@", ((Sport*)[model_manager.sportsManager.arraySports objectAtIndex:indexPath.row]).sportID];
    NSArray *filteredRecords = [arrSelectedPrefrences filteredArrayUsingPredicate:_predicate];
    
    if(filteredRecords.count>0)
    {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    else
        cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [model_manager.sportsManager.arraySports count];
}


#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %d row", indexPath.row);
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"sportID == %@", ((Sport*)[model_manager.sportsManager.arraySports objectAtIndex:indexPath.row]).sportID];
    NSArray *filteredRecords = [arrSelectedPrefrences filteredArrayUsingPredicate:_predicate];
    
    if(filteredRecords.count>0)
    {
        [arrSelectedPrefrences removeObject:[filteredRecords objectAtIndex:0]];
    }
    else
    {
        [arrSelectedPrefrences addObject:[model_manager.sportsManager.arraySports objectAtIndex:indexPath.row]];
    }
    
    [tblPrefrences reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"sportID == %@", ((Sport*)[model_manager.sportsManager.arraySports objectAtIndex:indexPath.row]).sportID];
    NSArray *filteredRecords = [arrSelectedPrefrences filteredArrayUsingPredicate:_predicate];
    
    if(filteredRecords.count>0)
    {
        [arrSelectedPrefrences removeObject:[filteredRecords objectAtIndex:0]];
    }
    
    [tblPrefrences reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
