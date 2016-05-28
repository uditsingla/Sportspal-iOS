//
//  News_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "News_VC.h"
#import "TB_News.h"
#import "Login.h"

@interface News_VC ()
{
    
    __weak IBOutlet UITableView *tblNews;
    
    NSMutableArray *arrNews;
    NSMutableArray * arrLinks;
    
    NSMutableArray *arrTempImages;
    
}
- (IBAction)clkSlider:(id)sender;

@end

@implementation News_VC

- (void)viewDidLoad {
    
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeDefault];

    //remove Login Controller
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    
    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
    
    
    for (int i = 0; i <= [controllers count] - 2; i++)
    {
        UIViewController *vc = [controllers objectAtIndex:1];
        if (![vc isKindOfClass:[UITabBarController class]])
        {
            [controllers removeObjectAtIndex:1];
        }
    }
    
    navigationController.viewControllers = controllers;
    //
    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    
    arrTempImages = [NSMutableArray arrayWithObjects:@"yoga.png",@"rockclimbing.png",@"golf.png", nil];
    
    arrNews = [NSMutableArray arrayWithObjects:@"Six lessons that Patanjali teaches India's FMCG sector",@"DECATHLON City Square Mall Opening",@"NIKE HYPERADAPT 1.0 MANIFESTS THE UNIMAGINABLE", nil];
    
    arrLinks = [NSMutableArray arrayWithObjects:
                @"http://economictimes.indiatimes.com/slideshows/biz-entrepreneurship/six-lessons-that-patanjali-teaches-indias-fmcg-sector/6-lessons-that-patanjali-teaches-indias-fmcg-sector/slideshow/51874418.cms",
                @"https://www.youtube.com/watch?v=Nyu3380Id64",
                @"http://news.nike.com/news/hyperadapt-adaptive-lacing",
                 nil];
    
    self.view.backgroundColor = kBlackColor;
    tblNews.backgroundColor = kBlackColor;
    
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
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"isLocation"];

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
    cell.imgBackground.image = [UIImage imageNamed:[arrTempImages objectAtIndex:indexPath.row]];
    cell.lblName.text = [arrNews objectAtIndex:indexPath.row];
    //cell.lblName.textColor = [UIColor blueColor];
    
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
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[arrLinks objectAtIndex:indexPath.row]]];
    
}



@end
