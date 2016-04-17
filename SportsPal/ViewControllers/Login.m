//
//  Login.m
//  SportsPal
//
//  Created by Abhishek Singla on 12/03/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Login.h"

@interface Login ()
{
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet UITextField *txtEmail;
    
    __weak IBOutlet UITextField *txtPassword;
    
    __weak IBOutlet UIButton *btnLogin;
    
}
@end

@implementation Login


#pragma mark - Click Methods

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [CustomViewViewController customTextField:txtEmail placeholder:@"Email" rightView:nil];
    [CustomViewViewController customTextField:txtPassword placeholder:@"Password" rightView:nil];
    
    btnLogin.backgroundColor = BrightGreen;
    [[btnLogin layer] setCornerRadius:3.0f];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clk_Login:(id)sender {
    
//    UIViewController *homeVC = [kLoginStoryboard instantiateInitialViewController];
//    [kLoginStoryboard instantiateViewControllerWithIdentifier:@"login"];
//    [self.navigationController pushViewController:[self goToController:@"history"] animated:NO];
//    
//    [self.navigationController pushViewController:homeVC animated:YES];
}
- (IBAction)clk_ForgotPassword:(id)sender {
}
- (IBAction)clk_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
@end
