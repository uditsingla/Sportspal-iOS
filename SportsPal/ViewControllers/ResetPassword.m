//
//  ResetPassword.m
//  SportsPal
//
//  Created by Abhishek Singla on 16/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "ResetPassword.h"

@interface ResetPassword ()
{
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UIScrollView *scroll;

    __weak IBOutlet UIButton *btnReset;
}

- (IBAction)clkBack:(id)sender;

- (IBAction)clkReset:(id)sender;
@end

@implementation ResetPassword

- (void)viewDidLoad
{
    [CustomViewViewController customTextField:txtEmail placeholder:@"Email" rightView:nil];
    
    btnReset.backgroundColor = DullGreen;
    [[btnReset layer] setCornerRadius:3.0f];
    
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

- (IBAction)clkBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clkReset:(id)sender {
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
