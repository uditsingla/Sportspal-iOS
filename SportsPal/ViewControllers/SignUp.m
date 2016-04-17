//
//  SignUp.m
//  SportsPal
//
//  Created by Abhishek Singla on 12/03/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "SignUp.h"
#import "Home.h"

@interface SignUp ()

{
    __weak IBOutlet UIScrollView *scroll;
    
    __weak IBOutlet UITextField *txtFirstName;
    __weak IBOutlet UITextField *txtLastName;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UITextField *txtRePassword;
    
    __weak IBOutlet UIButton *btnFemale;
    
    __weak IBOutlet UIButton *btnMale;
    
    __weak IBOutlet UIButton *bntBirthdate;
    
    
    __weak IBOutlet UIButton *btnSignUp;
}

- (IBAction)clkGender:(id)sender;


@end

@implementation SignUp


- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [CustomViewViewController customTextField:txtFirstName placeholder:@"First Name" rightView:nil];
    [CustomViewViewController customTextField:txtLastName placeholder:@"Last Name" rightView:nil];
    [CustomViewViewController customTextField:txtEmail placeholder:@"Email" rightView:nil];
    [CustomViewViewController customTextField:txtPassword placeholder:@"Password" rightView:nil];
    [CustomViewViewController customTextField:txtRePassword placeholder:@"Re-Password" rightView:nil];
    
    //UIButton Birthday
    bntBirthdate.alpha = .5;
    bntBirthdate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bntBirthdate.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);

    [bntBirthdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bntBirthdate.backgroundColor = [UIColor grayColor];
    [[bntBirthdate layer] setCornerRadius:3.0f];
    [[bntBirthdate layer] setBorderWidth:1.0f];
    [[bntBirthdate layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    //Btn SignUp
    btnSignUp.backgroundColor = BrightGreen;
    [[btnSignUp layer] setCornerRadius:3.0f];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clkBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clkSignUp:(id)sender {
}

#pragma mark - UItextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scroll setContentOffset:CGPointMake(0.0, 256) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [scroll setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
}



- (IBAction)clkGender:(id)sender
{
    
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 1)
    {
        [btnFemale setImage:[UIImage imageNamed:@"female_green.png"] forState:UIControlStateNormal];
        [btnMale setImage:[UIImage imageNamed:@"male_white.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnMale setImage:[UIImage imageNamed:@"male_green.png"] forState:UIControlStateNormal];
        [btnFemale setImage:[UIImage imageNamed:@"female_white.png"] forState:UIControlStateNormal];
    }
}
@end
