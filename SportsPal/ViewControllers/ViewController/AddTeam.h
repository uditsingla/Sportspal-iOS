//
//  AddTeam.h
//  SportsPal
//
//  Created by Abhishek Singla on 01/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTeam : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) Team *selectedTeam;
@end
