//
//  Add_VC.h
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Add_VC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) Game *selectedGame;

@end
