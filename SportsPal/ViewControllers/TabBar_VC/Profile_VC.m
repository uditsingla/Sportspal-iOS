//
//  Profile_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 13/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Profile_VC.h"
#import "Sport.h"

@interface Profile_VC ()
{
    __weak IBOutlet UIImageView *imageProfile;
    
    __weak IBOutlet UIImageView *imgRating;
    __weak IBOutlet UILabel *lblName;
    
    __weak IBOutlet UIButton *btnChallenge;
    __weak IBOutlet UIButton *btnChat;
    __weak IBOutlet UIButton *btnFav;
    
    
    __weak IBOutlet UILabel *lblAge;
    
    __weak IBOutlet UIView *contentView;
    
    BOOL isFavourite;
    
}
- (IBAction)clkFav:(id)sender;
- (IBAction)clkSlider:(id)sender;
- (IBAction)clkChallenge:(id)sender;
- (IBAction)clkChat:(id)sender;

@end

@implementation Profile_VC

@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    isFavourite = false;
    
    if(user==nil)
    {
        user = model_manager.profileManager.owner;
    }
    else
    {
        
    }
    
    lblName.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    lblAge.text = user.dob;
    
    
    NSString *strImageProfile = ((Sport*)[user.arrayPreferredSports objectAtIndex:0]).sportName;
    strImageProfile = [strImageProfile lowercaseString];
    
    imageProfile.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strImageProfile]];
    
    int dynamicY = lblAge.frame.origin.y;
    for(int i=0; i<user.arrayPreferredSports.count; i++)
    {
        
        
        UIView *viewSport = [[UIView alloc]init];
        
        float viewHeight = 25;
        
        
        
        
        //create image view and Lable
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 15, 15)];
        imageView.image = [UIImage imageNamed:@"sports.png"];
        imageView.contentMode =UIViewContentModeScaleAspectFit;
        [viewSport addSubview:imageView];
        
        
        //Uilable
        
        NSString *sportName = [[NSString stringWithFormat:@"%@",((Sport*)[user.arrayPreferredSports objectAtIndex:i]).sportName] uppercaseString];
        
        UILabel *lblSportName = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 95, 25)];
        lblSportName.font = [UIFont fontWithName:@"OpenSans" size:12];
        lblSportName.backgroundColor = [UIColor clearColor];
        lblSportName.text = sportName;
        lblSportName.textColor = [UIColor whiteColor];
        [viewSport addSubview:lblSportName];
        
        //------------
        
        
        if (i % 2)
        {
            dynamicY  += 40;
            viewSport.frame = CGRectMake(15, dynamicY, 120, viewHeight) ;
        }
        
        else
        {
            viewSport.frame = CGRectMake(self.view.frame.size.width- 140, dynamicY, 120, viewHeight) ;
        }

        viewSport.backgroundColor = [UIColor clearColor];
        [contentView addSubview:viewSport];
    }
    
    dynamicY +=30;
    
    UITextView *txtViewDescription = [[UITextView alloc]initWithFrame:CGRectMake(20, dynamicY, self.view.frame.size.width-40, 160)];
    txtViewDescription.textColor = [UIColor whiteColor];
    txtViewDescription.delegate = self;
    [contentView addSubview:txtViewDescription];
    txtViewDescription.font = [UIFont fontWithName:@"OpenSans" size:12];
    txtViewDescription.backgroundColor =[UIColor clearColor];
    txtViewDescription.text = user.bio;
    txtViewDescription.userInteractionEnabled = NO;
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

- (IBAction)clkFav:(id)sender {
    
    if (isFavourite)
    {
         [btnFav setImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
        isFavourite = false;
    }
    else
    {
         [btnFav setImage:[UIImage imageNamed:@"favOn.png"] forState:UIControlStateNormal];
        isFavourite = true;
    }
    
   
}

- (IBAction)clkSlider:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)clkChallenge:(id)sender {
}

- (IBAction)clkChat:(id)sender {
}
@end
