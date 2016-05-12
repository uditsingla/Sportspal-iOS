//
//  News_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "News_VC.h"
#import "TB_News.h"

@interface News_VC ()
{
    
    __weak IBOutlet UITableView *tblNews;
    
    NSMutableArray *arrNews;
}
- (IBAction)clkSlider:(id)sender;

@end

@implementation News_VC

- (void)viewDidLoad {
    
    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    
    arrNews = [NSMutableArray arrayWithObjects:@"news 1 ",@"news 2",@"news 3",@"news 4", nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self callInitialServices];
}

-(void)callInitialServices
{
    [kAppDelegate.objLoader show];
    [model_manager.sportsManager getSports:^(NSDictionary *dictJson, NSError *error) {
        [kAppDelegate.objLoader hide];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
#pragma mark - Click Methods
- (IBAction)clkSlider:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

#pragma mark - Delegates and Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    TB_News *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TB_News alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //cell.contentView.backgroundColor = [UIColor yellowColor];
    cell.imgBackground.image = [UIImage imageNamed:@"cricket.png"];
    cell.lblName.text = [arrNews objectAtIndex:indexPath.row];
    cell.lblName.textColor = [UIColor blueColor];
    
    //tblNews.backgroundColor = [UIColor greenColor];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [arrNews count];
}


#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}
@end
