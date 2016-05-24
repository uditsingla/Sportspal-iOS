//
//  People_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Setting_VC.h"
#import "Prefrences.h"
#import "SetLocationScreen.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Base64.h"

@interface Setting_VC ()
{
    NSString *StrEncoded; // for base64 image data
    
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
    
    __weak IBOutlet UIView *contentView;
    
    NSString *selectedGender;
    NSString *strDOB;
    NSString *strEmail,*strFirstName,*strLastName;
    
    UIToolbar *toolBar;
    
    __weak IBOutlet UIImageView *bgImage;

    
    __weak IBOutlet UIButton *btnCurrentLoction;
    
    __weak IBOutlet UITextView *txtViewDescription;
    __weak IBOutlet UIView *toolBarSuperView;
    
    UIImagePickerController *imgPicker;

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

@implementation Setting_VC

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
    
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    toolBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(selectDateTime:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    [toolBarSuperView addSubview:toolBar];
    
    pickerDate.datePickerMode = UIDatePickerModeDate;
    
    [pickerDate addTarget:self action:@selector(dateChanged:)               forControlEvents:UIControlEventValueChanged];
    
    pickerDate.backgroundColor = [UIColor whiteColor];
    
    [self hideAllPickers];
    
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    
    
    [profilePic sd_setImageWithURL:[NSURL URLWithString:model_manager.profileManager.owner.profilePic] placeholderImage:[UIImage imageNamed:@"members.png"]];
    profilePic.backgroundColor = [UIColor clearColor];
    profilePic.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.view.backgroundColor = kBlackColor;
    contentView.backgroundColor = kBlackColor;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    txtEmail.text = model_manager.profileManager.owner.email;
    txtFirstName.text = model_manager.profileManager.owner.firstName;
    txtLastName.text = model_manager.profileManager.owner.lastName;
    txtViewDescription.text = model_manager.profileManager.owner.bio;
    
    if(model_manager.profileManager.svp_LocationInfo)
        [btnLocation setTitle:model_manager.profileManager.svp_LocationInfo.formattedAddress forState:UIControlStateNormal];
    [btnDOB setTitle:model_manager.profileManager.owner.dob forState:UIControlStateNormal];
    if([model_manager.profileManager.owner.gender isEqualToString:@"male"])
        [self clkGender:btnMale];
    else
        [self clkGender:btnFemale];
    
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
    toolBarSuperView.hidden = YES;
    
    [scrollview setContentOffset:CGPointMake(0, 0)];
}

- (IBAction)clkLeftSlider:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)clkupdate:(id)sender {
    
    [txtViewDescription resignFirstResponder];
    
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
        
//        NSString *deviceToken=@"";
//        if([[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceToken"])
//        {
//            deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceToken"];
//        }
        
        NSString *strBio = [NSString stringWithFormat:@"%@", txtViewDescription.text];

        NSString *strAddress = model_manager.profileManager.svp_LocationInfo.formattedAddress;
        
        
        NSDictionary *signUpInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtFirstName.text,@"first_name",
                                         txtLastName.text,@"last_name",
                                         txtEmail.text, @"email",
                                         btnDOB.titleLabel.text,@"dob",
                                         selectedGender,@"gender",
                                         strBio,@"bio",
                                         [NSNumber numberWithDouble:latitude],@"latitude",
                                         [NSNumber numberWithDouble:longitude],@"longitude",
                                         strAddress,@"address",
                                         StrEncoded,@"image", nil];
        
        [model_manager.profileManager.owner updateUserDetails:signUpInfo completion:^(NSDictionary *dictJson, NSError *error) {
            [kAppDelegate.objLoader hide];
            if(!error)
            {
                if([[dictJson valueForKey:@"success"] boolValue])
                {
                    //updated successfully
                    [self showAlert:[dictJson valueForKey:@"message"]];
                    
                    [model_manager.playerManager getNearByUsers:nil];
                    [model_manager.sportsManager getAvailableGames:nil];
                    [model_manager.teamManager getAvailableTeams:nil];
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
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Upload Profile Pic"
                                 message:@"Choose your preffernce"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* camera = [UIAlertAction
                         actionWithTitle:@"Camera"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                             
                             //[self presentedViewController:imgPicker animation:YES];


                             [self presentViewController:imgPicker animated:YES completion:NULL];

                             
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* gallery = [UIAlertAction
                         actionWithTitle:@"Gallery"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             
                             imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             
                             //[self presentImagePickerWithCamera:YES];
                             [self presentViewController:imgPicker animated:YES completion:NULL];

                             
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];

    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:camera];
    [view addAction:gallery];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (IBAction)clkDOB:(id)sender
{
    [txtViewDescription resignFirstResponder];
    pickerDate.hidden = NO;
    toolBarSuperView.hidden = NO;
    
    
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
    Prefrences *homeVC = [kLoginStoryboard instantiateViewControllerWithIdentifier:@"prefrences"];
    homeVC.isFromProfileView = YES;
    [self.navigationController pushViewController:homeVC animated:YES];
}

- (IBAction)clkLocation:(id)sender {
    
    SetLocationScreen *obj = [SetLocationScreen new];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)clkCurrentLocation:(id)sender {
    
    [SVGeocoder reverseGeocode:kAppDelegate.tempLocation.coordinate
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        
                        if(error)
                        {
                            
                        }
                        else if([placemarks count]>0)
                        {
                            model_manager.profileManager.svp_LocationInfo = [placemarks firstObject];
                            NSLog(@"Dictonary for google location = %@", [placemarks firstObject]);
                            kAppDelegate.myLocation = kAppDelegate.tempLocation;
                            [btnLocation setTitle:model_manager.profileManager.svp_LocationInfo.formattedAddress forState:UIControlStateNormal];
                        }
                        
                    }];
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
                                  alertControllerWithTitle:@"Alert"
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

#pragma mark - UItextview Delegates

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
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

#pragma mark image picker delegates


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    profilePic.image = chosenImage;
    
    if(chosenImage.size.width>300 || chosenImage.size.height>300)
        chosenImage = [self scaleImage:chosenImage toSize:CGSizeMake(300, 300)];
    
    NSData *data = UIImageJPEGRepresentation(chosenImage, 0.25f);
    [Base64 initialize];
    StrEncoded = [Base64 encode:data];
    data=nil;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//    
////    profilePic.image = image;
////    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    sprofilePic.image = chosenImage;
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    
//    
//    NSLog(@"Came into imagepicker ");
//}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Cancel");
}

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
