//
//  Profile_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 13/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Profile_VC.h"

@interface Profile_VC ()
{
    __weak IBOutlet UIImageView *imageProfile;
    
    __weak IBOutlet UIImageView *imgRating;
    __weak IBOutlet UILabel *lblName;
    
    __weak IBOutlet UIButton *btnChallenge;
    __weak IBOutlet UIButton *btnChat;
    __weak IBOutlet UIButton *btnFav;
    
    
    __weak IBOutlet UITextView *txtDescription;
    __weak IBOutlet UILabel *lblAge;
    
}
- (IBAction)clkFav:(id)sender;
- (IBAction)clkSlider:(id)sender;
- (IBAction)clkChallenge:(id)sender;
- (IBAction)clkChat:(id)sender;

@end

@implementation Profile_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)clkFav:(id)sender {
    
    [btnFav setImage:[UIImage imageNamed:@"favOn.png"] forState:UIControlStateNormal];
}

- (IBAction)clkSlider:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)clkChallenge:(id)sender {
}

- (IBAction)clkChat:(id)sender {
}
@end
