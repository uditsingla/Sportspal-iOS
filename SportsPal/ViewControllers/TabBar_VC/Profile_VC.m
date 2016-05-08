//
//  People_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Profile_VC.h"

@interface Profile_VC ()
{
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtFirstName;

    __weak IBOutlet UITextField *txtLastName;

    __weak IBOutlet UIImageView *profilePic;
    __weak IBOutlet UIScrollView *scrollview;
    
    __weak IBOutlet UIButton *btnMale;
    
    __weak IBOutlet UIButton *btnFemale;
    
    __weak IBOutlet UIButton *btnLocation;
    
    __weak IBOutlet UIButton *btnDOB;
    __weak IBOutlet UIButton *btnPrefrence;
    
    __weak IBOutlet UIDatePicker *pickerDate;
    
    
    NSString *selectedGender;
    NSString *strDOB;
    NSString *strEmail,*strFirstName,*strLastName;
    
    UIToolbar *toolBar;
    
    __weak IBOutlet UIImageView *bgImage;

    
    __weak IBOutlet UIButton *btnCurrentLoction;
}
- (IBAction)clkLeftSlider:(id)sender;
- (IBAction)clkupdate:(id)sender;
- (IBAction)clkProfilePic:(id)sender;
- (IBAction)clkDOB:(id)sender;
- (IBAction)clkGender:(id)sender;
- (IBAction)clkPrefrencess:(id)sender;
- (IBAction)clkLocation:(id)sender;
- (IBAction)clkCurrentLocation:(id)sender;

@end

@implementation Profile_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    bgImage.backgroundColor = [UIColor blackColor];
    [CustomViewViewController customTextField:txtEmail placeholder:@"Email" rightView:nil];
    [CustomViewViewController customTextField:txtFirstName placeholder:@"First Name" rightView:nil];
    [CustomViewViewController customTextField:txtLastName placeholder:@"Last Name" rightView:nil];

    
    
    //UIButton Birthday
    btnDOB.alpha = .5;
    btnDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnDOB.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    [btnDOB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDOB.backgroundColor = [UIColor grayColor];
    [[btnDOB layer] setCornerRadius:3.0f];
    [[btnDOB layer] setBorderWidth:1.0f];
    [[btnDOB layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    //
    
//    //
//    btnPrefrence.alpha = .5;
//    btnPrefrence.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    btnPrefrence.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
//    
//    [btnPrefrence setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnPrefrence.backgroundColor = [UIColor grayColor];
//    [[btnPrefrence layer] setCornerRadius:3.0f];
//    [[btnPrefrence layer] setBorderWidth:1.0f];
//    [[btnPrefrence layer] setBorderColor:[UIColor lightGrayColor].CGColor];
//    //
    
    btnPrefrence.backgroundColor = GreenColor;
    btnLocation.backgroundColor = GreenColor ;
    btnCurrentLoction.backgroundColor = GreenColor;
    
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,pickerDate.frame.origin.y-44,pickerDate.frame.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    toolBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(selectDateTime:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    [self.view addSubview:toolBar];
    
    [pickerDate addTarget:self action:@selector(dateChanged:)               forControlEvents:UIControlEventValueChanged];
    
    pickerDate.backgroundColor = [UIColor whiteColor];
    
    [self hideAllPickers];

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

-(void)hideAllPickers
{
    pickerDate.hidden = YES;
    toolBar.hidden = YES;
    
    [scrollview setContentOffset:CGPointMake(0, 0)];
}

- (IBAction)clkLeftSlider:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)clkupdate:(id)sender {
    
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
    else if([[btnDOB.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
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
        
        NSDictionary *signUpInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtFirstName.text,@"first_name", txtLastName.text,@"last_name", txtEmail.text, @"email",btnDOB.titleLabel.text,@"dob", selectedGender,@"gender",[NSNumber numberWithDouble:latitude],@"latitude", [NSNumber numberWithDouble:longitude],@"longitude", @"ios", @"device_type", deviceToken, @"device_token", nil];
        
        [model_manager.loginManager userSignUp:signUpInfo completion:^(NSDictionary *dictJson, NSError *error) {
            [kAppDelegate.objLoader hide];
            if(!error)
            {
                if([[dictJson valueForKey:@"success"] boolValue])
                {
                    //user registered successfully
                    
                    //login now
                    [kAppDelegate.objLoader show];
                    
                    NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtEmail.text, @"email", @"ios", @"device_type", deviceToken, @"device_token", nil];
                    
                    [model_manager.loginManager userLogin:loginInfo completion:^(NSDictionary *dictJson, NSError *error) {
                        [kAppDelegate.objLoader hide];
                        if(!error)
                        {
                            if([[dictJson valueForKey:@"success"] boolValue])
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
                else
                {
                    [self showAlert:[dictJson valueForKey:@"message"]];
                }
            }
        }];
    }
}

- (IBAction)clkProfilePic:(id)sender {
}

- (IBAction)clkDOB:(id)sender
{
    pickerDate.hidden = NO;
    toolBar.hidden = NO;
    
    
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

- (IBAction)clkPrefrencess:(id)sender {
}

- (IBAction)clkLocation:(id)sender {
}

- (IBAction)clkCurrentLocation:(id)sender {
}

-(void)selectDateTime:(id)sender
{
    [btnDOB setTitle:strDOB forState:UIControlStateNormal];
    
    [self hideAllPickers];
}

- (void)dateChanged:(UIDatePicker *)datePicker
{
    NSLog(@"value: %@",[NSDate date]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    strDOB = [dateFormatter stringFromDate:datePicker.date];
    
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
    [scrollview setContentOffset:CGPointMake(0.0, 80) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
}



@end
