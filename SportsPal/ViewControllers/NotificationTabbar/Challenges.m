//
//  Challenges.m
//  SportsPal
//
//  Created by Abhishek Singla on 27/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Challenges.h"
#import "Game.h"
#import "Add_VC.h"

@interface Challenges ()
{
    UIImageView *topNavBar;
    UILabel *topHeader;
    UIButton *menuBtn;
    UITableView *tblNotifications;
}
@end

@implementation Challenges

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"controller array : %@",self.navigationController.viewControllers);
    
    
    
    topNavBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    topNavBar.backgroundColor = kBlackColor;
    [self.view addSubview:topNavBar];
    
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn addTarget:self action:@selector(menuBtnPressed) forControlEvents:UIControlEventTouchDown];
    menuBtn.backgroundColor=[UIColor clearColor];
    menuBtn.frame = CGRectMake(0, 20, 44 , 44);
    [menuBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [self.view addSubview:menuBtn];
    
    UILabel *header= [[UILabel alloc]initWithFrame:CGRectMake(0, 11, self.view.frame.size.width, 60)];
    header.text=@"NOTIFICATIONS";
    header.backgroundColor=[UIColor clearColor];
    header.numberOfLines=1;
    header.textAlignment=NSTextAlignmentCenter;
    header.textColor=[UIColor whiteColor];
    header.adjustsFontSizeToFitWidth=YES;
    header.font= [UIFont fontWithName:@"TwCenMT-Regular" size:17];
    [self.view addSubview:header];
    
    tblNotifications=[[UITableView alloc]initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104)];
    //TableView Delegates
    tblNotifications.dataSource = self;
    tblNotifications.delegate = self;
    tblNotifications.backgroundColor=[UIColor clearColor];
    // This will remove extra separators from tableview
    tblNotifications.tableFooterView = [UIView new];

    [self.view addSubview:tblNotifications];
    
    
    self.view.backgroundColor = kBlackColor;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [model_manager.sportsManager getAllGameChallenges:^(NSDictionary *dictJson, NSError *error) {
        [tblNotifications reloadData];
    }];
}


-(void)viewDidLayoutSubviews
{
    
    NSArray *arrControllers = self.navigationController.viewControllers;
    UITabBarController *tabController = [arrControllers lastObject];
    
    tabController.tabBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 40);
    
    CGRect viewFrame = tabController.tabBar.frame;
    //change these parameters according to you.
    viewFrame.origin.y = 64;
    viewFrame.origin.x = 0;
    viewFrame.size.height = 40;
    viewFrame.size.width = self.view.frame.size.width;
    
    tabController.tabBar.frame = viewFrame;
    tabController.tabBar.tintColor = DullGreen;
    //tabController.tabBar.superview.backgroundColor = [UIColor whiteColor];
    //[[UITabBar appearance] setBarTintColor:[UIColor redColor]];
    
}

#pragma mark tableview delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return model_manager.sportsManager.arrayGameChallenges.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 50;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *_simpleTableIdentifier = @"CellIdentifier";
    
    
    
    UITableViewCell *cellnew = [tableView dequeueReusableCellWithIdentifier:_simpleTableIdentifier];
    UILabel *lbl_heading,*lbl_date;
    if (cellnew == nil)
    {
        cellnew = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_simpleTableIdentifier];
        cellnew.backgroundColor=[UIColor clearColor];
        cellnew.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        lbl_heading= [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 35)];
        lbl_heading.tag=2;
        lbl_heading.backgroundColor=[UIColor clearColor];
        [lbl_heading setTextColor:[UIColor whiteColor]];
        lbl_heading.font = [UIFont fontWithName:@"TwCenMT-Regular" size:17];
        [cellnew.contentView addSubview:lbl_heading];
        
        lbl_date= [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 205, 26, 192, 20)];
        lbl_date.tag=4;
        lbl_date.backgroundColor=[UIColor clearColor];
        [lbl_date setTextColor:[UIColor whiteColor]];
        lbl_date.textAlignment = NSTextAlignmentRight;
        lbl_date.font = [UIFont fontWithName:@"TwCenMT-Regular" size:13];
        [cellnew.contentView addSubview:lbl_date];
        
    }
    [cellnew setSelectionStyle:UITableViewCellSelectionStyleGray];
    lbl_heading = (UILabel *)[cellnew.contentView viewWithTag:2];
    lbl_date = (UILabel *)[cellnew.contentView viewWithTag:4];

    Game *game = ((Game*)[model_manager.sportsManager.arrayGameChallenges objectAtIndex:indexPath.row]);
    
    lbl_heading.text = [NSString stringWithFormat:@"Challenge received for %@ game.",[game.gameName capitalizedString]];
    
    lbl_date.text = [self getDateFromServerTime:game.createdTime];

    
    return cellnew;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Add_VC *viewcontroller = [kMainStoryboard instantiateViewControllerWithIdentifier:@"add_vc"];
    viewcontroller.selectedGame = (Game*)[model_manager.sportsManager.arrayGameChallenges objectAtIndex:indexPath.row];
    [kAppDelegate.container.centerViewController pushViewController:viewcontroller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString*)getDateFromServerTime:(NSString*)serverTime
{
    // create dateFormatter with UTC time format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:serverTime]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"EEE, MMM d @ hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    return timestamp;
}

-(void)menuBtnPressed
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
