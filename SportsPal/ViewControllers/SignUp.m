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
    
    NSString *selectedGender;
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

    selectedGender = @"";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clkBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clkSignUp:(id)sender {
    
    if([[txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [self showAlert:@"Please enter firstname"];
    }
    else if([[txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [self showAlert:@"Please enter lastname"];
    }
    else if([[txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [self showAlert:@"Please enter email"];
    }
    else if(![self validateEmailWithString:txtEmail.text])
    {
        [self showAlert:@"Please enter valid email"];
    }
    else if([[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [self showAlert:@"Please enter password"];
    }
    else if([[txtRePassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [self showAlert:@"Please enter password again"];
    }
    else if(![txtPassword.text isEqualToString:txtRePassword.text])
    {
        [self showAlert:@"Please enter same password"];
    }
    else if([[bntBirthdate.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [self showAlert:@"Please enter date of birth"];
    }
    else if([[selectedGender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        [self showAlert:@"Please select gender"];
    }
    else
    {
        [kAppDelegate.objLoader show];
        
        double latitude,longitude;
        if(kAppDelegate.myLocation)
        {
            latitude = kAppDelegate.myLocation.coordinate.latitude;
            longitude = kAppDelegate.myLocation.coordinate.longitude;
        }
        else
        {
            latitude = 0;
            longitude = 0;
        }
        
        NSString *deviceToken=@"";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceToken"])
        {
            deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceToken"];
        }
        
        NSDictionary *signUpInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtFirstName.text,@"first_name", txtLastName.text,@"last_name", txtEmail.text, @"email", txtPassword.text, @"password",bntBirthdate.titleLabel.text,@"dob", selectedGender,@"gender",[NSNumber numberWithDouble:latitude],@"latitude", [NSNumber numberWithDouble:longitude],@"longitude", @"ios", @"device_type", deviceToken, @"device_token", nil];
        
        [model_manager.loginManager userSignUp:signUpInfo completion:^(NSDictionary *dictJson, NSError *error) {
            [kAppDelegate.objLoader hide];
            if(!error)
            {
                if([[dictJson valueForKey:@"message"] isEqualToString:@"User registered successfully "])
                {
                    //user registered successfully
                    UIViewController *homeVC = [kMainStoryboard instantiateInitialViewController];
                    [self.navigationController pushViewController:homeVC animated:YES];
                }
                else
                {
                    [self showAlert:[dictJson valueForKey:@"message"]];
                }
            }
        }];
    }
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
        selectedGender = @"female";
        [btnFemale setImage:[UIImage imageNamed:@"female_green.png"] forState:UIControlStateNormal];
        [btnMale setImage:[UIImage imageNamed:@"male_white.png"] forState:UIControlStateNormal];
    }
    else
    {
        selectedGender = @"male";
        [btnMale setImage:[UIImage imageNamed:@"male_green.png"] forState:UIControlStateNormal];
        [btnFemale setImage:[UIImage imageNamed:@"female_white.png"] forState:UIControlStateNormal];
    }
}
@end
