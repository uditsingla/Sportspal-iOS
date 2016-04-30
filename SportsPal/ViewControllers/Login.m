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
    
    if ([[txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0 && [[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0 )
    {
        if(![self validateEmailWithString:txtEmail.text])
        {
            [self showAlert:@"Please enter valid email"];
            return;
        }
        
        [kAppDelegate.objLoader show];
        
        NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtEmail.text, @"email", txtPassword.text, @"password", @"ios", @"device_type", @"1234hsdgfdf4", @"device_token", nil];
        
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
    else if([[txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        [self showAlert:@"Please enter email"];
    else if([[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        [self showAlert:@"Please enter password"];

    
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
