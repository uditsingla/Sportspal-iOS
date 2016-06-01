//
//  NotificationsViewController.m
//  SportsPal
//
//  Created by Amit Yadav on 22/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "NotificationsViewController.h"
#import "Team.h"
#import "AddTeam.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NotificationsViewController ()
{
    UIImageView *topNavBar;
    UILabel *topHeader;
    UIButton *menuBtn;
    UITableView *tblNotifications;
}

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"controller array : %@",self.navigationController.viewControllers);
    
    
    topNavBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topNavBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topNavBar];
    
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn addTarget:self action:@selector(menuBtnPressed) forControlEvents:UIControlEventTouchDown];
    menuBtn.backgroundColor=[UIColor clearColor];
    menuBtn.frame = CGRectMake(0, 0, 40 , 60);
    [menuBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [self.view addSubview:menuBtn];
    
    UILabel *header= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    header.text=@"NOTIFICATIONS";
    header.backgroundColor=[UIColor clearColor];
    header.numberOfLines=1;
    header.textAlignment=NSTextAlignmentCenter;
    header.textColor=[UIColor whiteColor];
    header.adjustsFontSizeToFitWidth=YES;
    header.font= [UIFont fontWithName:@"TwCenMT-Regular" size:17];
    [self.view addSubview:header];
    
    tblNotifications=[[UITableView alloc]initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, self.view.frame.size.height - 75)];
    //TableView Delegates
    tblNotifications.dataSource = self;
    tblNotifications.delegate = self;
    tblNotifications.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tblNotifications];
    
    
    self.view.backgroundColor = kBlackColor;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [model_manager.teamManager getTeamInvitation:^(NSDictionary *dictJson, NSError *error) {
        [tblNotifications reloadData];
    }];
}

-(void)viewDidLayoutSubviews
{
    
    NSArray *arrControllers = self.navigationController.viewControllers;
    UITabBarController *tabController = [arrControllers lastObject];
    
    tabController.tabBar.frame = CGRectMake(0, 44, self.view.frame.size.width, 40);
    
    CGRect viewFrame = tabController.tabBar.frame;
    //change these parameters according to you.
    viewFrame.origin.y = 44;
    viewFrame.origin.x = 0;
    viewFrame.size.height = 30;
    viewFrame.size.width = self.view.frame.size.width;
    
    tabController.tabBar.frame = viewFrame;
    tabController.tabBar.tintColor = [UIColor redColor];
    //tabController.tabBar.superview.backgroundColor = [UIColor whiteColor];
    //[[UITabBar appearance] setBarTintColor:[UIColor redColor]];

}

#pragma mark tableview delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return model_manager.teamManager.arrayTeamInvites.count;
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
    UIImageView *imgView;
    if (cellnew == nil)
    {
        cellnew = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_simpleTableIdentifier];
        cellnew.backgroundColor=[UIColor clearColor];
        cellnew.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        lbl_heading= [[UILabel alloc]initWithFrame:CGRectMake(46, 0, self.view.frame.size.width-50, 35)];
        lbl_heading.tag=2;
        lbl_heading.backgroundColor=[UIColor clearColor];
        [lbl_heading setTextColor:[UIColor whiteColor]];
        lbl_heading.font = [UIFont fontWithName:@"TwCenMT-Regular" size:17];
        [cellnew.contentView addSubview:lbl_heading];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
        imgView.tag = 3;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.layer.cornerRadius = 5;
        imgView.layer.masksToBounds = YES;
        [cellnew.contentView addSubview:imgView];
        
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
    imgView = (UIImageView *)[cellnew.contentView viewWithTag:3];
    lbl_date = (UILabel *)[cellnew.contentView viewWithTag:4];
    
    Team *team = ((Team*)[model_manager.teamManager.arrayTeamInvites objectAtIndex:indexPath.row]);
    
    lbl_heading.text = [NSString stringWithFormat:@"%@ added you in team %@.",[team.creator.firstName capitalizedString], team.teamName];
    
    lbl_date.text = [self getDateFromServerTime:team.createdTime];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrlPath,team.creator.profilePic]] placeholderImage:[UIImage imageNamed:@"members.png"]];
    
    return cellnew;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddTeam *viewcontroller = [kMainStoryboard instantiateViewControllerWithIdentifier:@"addteam"];
    viewcontroller.selectedTeam = ((Team*)[model_manager.teamManager.arrayTeamInvites objectAtIndex:indexPath.row]);
    [kAppDelegate.container.centerViewController pushViewController:viewcontroller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString*)getDateFromTimestamp:(double)timestamp
{
    NSLog(@"timestamp : %f",timestamp);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MMM dd, h:mm a"];
    return [dateFormatter stringFromDate:date];
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
