//
//  TB_Play_Teams.m
//  SportsPal
//
//  Created by Abhishek Singla on 19/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "TB_AddTeam.h"

@implementation TB_AddTeam

@synthesize btn_accept,btn_reject;

- (void)awakeFromNib {
    // Initialization code
    
    //btn accept
    btn_accept = [UIButton buttonWithType:UIButtonTypeCustom];
    float width = (self.frame.size.width/2)-10;
    btn_accept.frame = CGRectMake(self.frame.origin.x,5,width,35);
    btn_accept.tag = 111;
    [btn_accept setTitle:@"Accept" forState:UIControlStateNormal];
    btn_accept.backgroundColor = GreenColor;
    btn_reject.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:btn_accept];
    
    //btn reject
    btn_reject = [UIButton buttonWithType:UIButtonTypeCustom];
    float widthNew = btn_accept.frame.size.width;
    btn_reject.frame = CGRectMake(btn_accept.frame.size.width+20,5,widthNew,35);
    btn_reject.tag = 222;
    btn_reject.backgroundColor = RedColor;
    [btn_reject setTitle:@"Reject" forState:UIControlStateNormal];
    btn_reject.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:btn_reject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
