//
//  Constants.h
//  SportsPal
//
//  Created by Abhishek Singla on 10/03/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/*Color schemes*/
#define kBaseUrlPath @"http://sportspal.in/api/"

#define kBaseUrl [NSURL URLWithString:kBaseUrlPath]

#define loginPath @"users/login"
#define registerPath @"users/add"
#define resetPasswordPath @"users/resetPassword"
#define logoutPath @"users/logout"

#define sportsPath @"sports"
#define gamesPath @"games"
#define searchGamesPath @"games/search"
#define teamsPath @"teams"
#define searchTeamsPath @"teams/search"
#define searchPlayersPath @"users/search"

//TextField
#define TF_BorderColor  [UIColor redColor];
#define TF_BGColor  [UIColor colorWithRed:16/255.00 green:124/255.00 blue:213/255.00 alpha:1];
#define TF_TextColor  [UIColor colorWithRed:16/255.00 green:124/255.00 blue:213/255.00 alpha:1];
#define TF_PlaceHolderTextColor  [UIColor colorWithRed:16/255.00 green:124/255.00 blue:213/255.00 alpha:1];
#define TF_FontSize ((UIFont *)[UIFont fontWithName:@"Roboto-Regular" size:@"16"])
//

//Button Colors

#define BTN_Font_TW ((UIFont *)[UIFont fontWithName:@"TwCenMT-Regular" size:@"16"])
#define DullGreen  [UIColor colorWithRed:56/255.00 green:142/255.00 blue:60/255.00 alpha:1];
#define BrightGreen  [UIColor colorWithRed:139/255.00 green:195/255.00 blue:74/255.00 alpha:1];
//

#define BlueColor  [UIColor colorWithRed:16/255.00 green:124/255.00 blue:213/255.00 alpha:1];

#define LightGreyColor  [UIColor colorWithRed:234/255.00 green:234/255.00 blue:234/255.00 alpha:1];

#define DarkGreyColor  [UIColor colorWithRed:0/255.00 green:0/255.00 blue:0/255.00 alpha:1];

#define RedColor  [UIColor colorWithRed:212/255.00 green:11/255.00 blue:01/255.00 alpha:1];

#define GreenColor  [UIColor colorWithRed:58/255.00 green:137/255.00 blue:1/255.00 alpha:1];

#define OrangeColor  [UIColor colorWithRed:248/255.00 green:123/255.00 blue:1/255.00 alpha:1];

#define kBlackColor  [UIColor colorWithRed:33/255.00 green:33/255.00 blue:33/255.00 alpha:1];

#define Other  [UIColor colorWithRed:34/255.00 green:36/255.00 blue:85/255.00 alpha:1];



#define kMainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle: nil]
#define kLoginStoryboard [UIStoryboard storyboardWithName:@"Login" bundle: nil]


#import "MFSideMenu.h"
#import "LabeledActivityIndicatorView.h"
#import "AppDelegate.h"
#import "ModelManager.h"

#import "CustomViewViewController.h"

#define model_manager ((ModelManager *)[ModelManager modelManager])
#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//Internet Message Constants
#define kInternetUnreachableMessage @"Your Internet connection is unavailable."


#endif /* Constants_h */
