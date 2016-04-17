//
//  CustomViewViewController.h
//  SportsPal
//
//  Created by Abhishek Singla on 16/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewViewController : UIViewController
+(void)customTextField:(UITextField*)textField placeholder:(NSString*)placeHolder rightView:(NSString*)rightViewImageName;

+(void)customButton:(UIButton*)btn;
@end
