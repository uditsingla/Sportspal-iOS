//
//  TB_Add_VC.m
//  SportsPal
//
//  Created by Amit Yadav on 29/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "TB_Add_VC.h"

@implementation TB_Add_VC

@synthesize imgProfile,lblName;//,btn_accept,btn_reject;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    imgProfile = [UIImageView new];
    imgProfile.frame = CGRectMake(8, 9, 32, 32);
    imgProfile.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imgProfile];
    
    lblName= [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.frame.size.width-40, 20)];
    lblName.backgroundColor=[UIColor clearColor];
    [lblName setTextColor:[UIColor whiteColor]];
    lblName.font = [UIFont fontWithName:@"TwCenMT-Regular" size:17];
    [self.contentView addSubview:lblName];
    
//    //btn accept
//    btn_accept = [UIButton buttonWithType:UIButtonTypeCustom];
//    float width = (self.frame.size.width/2)-10;
//    btn_accept.frame = CGRectMake(self.frame.origin.x,20,width,25);
//    [btn_accept setTitle:@"Accept" forState:UIControlStateNormal];
//    btn_accept.backgroundColor = GreenColor;
//    btn_reject.titleLabel.textColor = [UIColor whiteColor];
//    [self.contentView addSubview:btn_accept];
//    
//    //btn reject
//    btn_reject = [UIButton buttonWithType:UIButtonTypeCustom];
//    float widthNew = btn_accept.frame.size.width;
//    btn_reject.frame = CGRectMake(btn_accept.frame.size.width+20,20,widthNew,25);
//    btn_reject.backgroundColor = RedColor;
//    [btn_reject setTitle:@"Reject" forState:UIControlStateNormal];
//    btn_reject.titleLabel.textColor = [UIColor whiteColor];
//    [self.contentView addSubview:btn_reject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
