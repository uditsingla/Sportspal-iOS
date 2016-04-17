//
//  CustomViewViewController.m
//  SportsPal
//
//  Created by Abhishek Singla on 16/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "CustomViewViewController.h"

@interface CustomViewViewController ()

@end

@implementation CustomViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)customTextField:(UITextField*)textField placeholder:(NSString*)placeHolder rightView:(NSString*)rightViewImageName;
{
    textField.backgroundColor = [UIColor grayColor];
    textField.alpha = .5;
    textField.layer.cornerRadius = 3.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    textField.layer.borderWidth= 1.0f;
    textField.attributedPlaceholder = [[NSAttributedString alloc]
                                  initWithString:placeHolder
                                  attributes:@{NSForegroundColorAttributeName:
                                                   [UIColor whiteColor]}];
    

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 41)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    if (rightViewImageName)
    {
        //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 41)];
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:rightViewImageName]];
        textField.rightView = rightImageView; // Set right view as image view
        
        //textField.rightView = paddingView;
        textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    }

    
}


+(void)customButton:(UIButton*)btn
{
    [[btn layer] setCornerRadius:3.0f];
    [[btn layer] setBorderWidth:1.0f];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
