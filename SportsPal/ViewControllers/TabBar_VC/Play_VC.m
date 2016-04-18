//
//  Play_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Play_VC.h"

@interface Play_VC ()
{
    NSMutableArray *arrPlayers,*arrSports,*arrTeams,*arrSearchResult,*arrTempSearch;
    
    __weak IBOutlet UITableView *tblPlayers;
    __weak IBOutlet UITableView *tblSports;
    __weak IBOutlet UITableView *tblTeams;
    __weak IBOutlet UITableView *tblSearch;
    
    __weak IBOutlet UISegmentedControl *segmentedcontrol;
    __weak IBOutlet UISearchBar *searchbar;
    
    
    __weak IBOutlet UIButton *btnSearch;
}
- (IBAction)clkSearch:(id)sender;
- (IBAction)clkSegment:(UISegmentedControl*)sender;
- (IBAction)clkNotifications:(id)sender;
- (IBAction)clkSlider:(id)sender;

@end

@implementation Play_VC

- (void)viewDidLoad
{
    //Segmented Controll
    
    
    [segmentedcontrol addTarget:self
                         action:@selector(clkSegment:)
               forControlEvents:UIControlEventValueChanged];
    
    arrPlayers = [NSMutableArray arrayWithObjects:@"Player 1 ",@"Player 2",@"Player 3",@"Player 4", nil];
    
    arrSports = [NSMutableArray arrayWithObjects:@"Sports 1 ",@"Sports 2",@"Sports 3",@"Sports 4", nil];
    arrTeams =[NSMutableArray arrayWithObjects:@"Team 1 ",@"Team 2",@"Team 3",@"Team 4", nil];
    
    
    arrSearchResult = [NSMutableArray new];
    arrTempSearch = [NSMutableArray new];
    
    
    tblSearch.hidden = YES;
    searchbar.hidden = YES;
    tblTeams.hidden = YES;
    tblSports.hidden = YES;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods
- (IBAction)clkSearch:(id)sender {
    
    searchbar.hidden = NO;
    btnSearch.hidden = YES;
}

- (IBAction)clkSegment:(UISegmentedControl*)sender {
    
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        tblSports.hidden = NO;
        tblPlayers.hidden = YES;
        tblTeams.hidden = YES;
        tblSearch.hidden = YES;
    }
    else if (selectedSegment == 1)
    {
        tblSports.hidden = YES;
        tblPlayers.hidden = NO;
        tblTeams.hidden = YES;
        tblSearch.hidden = YES;
    }
    else
    {
        tblSports.hidden = YES;
        tblPlayers.hidden = YES;
        tblTeams.hidden = NO;
        tblSearch.hidden = YES;
    }
}

- (IBAction)clkNotifications:(id)sender
{
    
}

- (IBAction)clkSlider:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Delegates and Tatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tblSports) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.contentView.backgroundColor = [UIColor redColor];
        cell.textLabel.text = [arrSports objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;

    }
    
    else if (tableView == tblPlayers) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.contentView.backgroundColor = [UIColor blueColor];
        cell.textLabel.text = [arrPlayers objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;

    }
    
    else if (tableView == tblTeams) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.contentView.backgroundColor = [UIColor greenColor];
        cell.textLabel.text = [arrTeams objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;

    }
    
    else if (tableView == tblSearch) {
        
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.textLabel.text = [arrSearchResult objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        tblSearch.backgroundColor = [UIColor blackColor];
        return cell;

    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if (theTableView == tblPlayers)
    {
        return [arrPlayers count];
    }
    else if (theTableView == tblTeams)
    {
        return [arrTeams count];
    }
    else if (theTableView == tblSports)
    {
        return [arrSports count];
    }
    else if (theTableView == tblSearch)
    {
        return [arrSearchResult count];
    }
    
    return [arrPlayers count];
    
}




#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
    if (theTableView == tblPlayers)
    {
        
    }
    else if (theTableView == tblTeams)
    {
        
    }
    else if (theTableView == tblSports)
    {
        
    }
    else if (theTableView == tblSearch)
    {
        
    }
}


#pragma mark - Searchbar Delegates

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        tblSearch.hidden = NO;
        [tblSearch reloadData];
        [searchBar resignFirstResponder];
        return NO;
    }
    return YES;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    tblSearch.hidden = YES;
    searchbar.text = @"";
    searchbar.hidden = YES;
    btnSearch.hidden = NO;
    [searchbar resignFirstResponder];
}


@end
