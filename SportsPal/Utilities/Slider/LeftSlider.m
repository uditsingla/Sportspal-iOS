//
//  LeftSlider.m
//  ApiTap
//
//  Created by Abhishek Singla on 16/03/16.
//  Copyright © 2016 ApiTap. All rights reserved.
//

#import "LeftSlider.h"
#import "LeftSliderCell.h"
#import "NotificationsViewController.h"


//#import "Appointments.h"
//#import "History.h"

#define klblMenuItem 10
#define kimgMenuItem 2


@interface LeftSlider ()
{
    NSArray *arrMenuItems, *arrMenuItemsImages;
}
@end

@implementation LeftSlider

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrMenuItems = [NSArray arrayWithObjects:@"Home",@"Share",@"Notifications",@"Settings",
                    @"Logout",nil];
    
    
    arrMenuItemsImages = [NSArray arrayWithObjects:@"left_menu_home_icon.png",
                          @"left_menu_share_icon.png",
                          @"left_menu_notification.png",
                          @"left_menu_setting_icon.png",
                          @"left_menu_logout_icon.png",
                          nil];

    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_signup.png"]];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [arrMenuItems count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *_simpleTableIdentifier = @"CellIdentifier";
    
    //LeftSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:_simpleTableIdentifier forIndexPath:indexPath];
    
    LeftSliderCell *cell = (LeftSliderCell*)[tableView dequeueReusableCellWithIdentifier:_simpleTableIdentifier];
    
    
    // Configure the cell...
    if(cell==nil)
    {
        cell = [[LeftSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_simpleTableIdentifier];
        
        
    }
    
    //Menu lable
    //UILabel *lblMenu = (UILabel*)[cell.contentView viewWithTag:klblMenuItem];
    // NSLog(@"lbl text : %@",[arrMenuItems objectAtIndex:indexPath.row]);
    cell.lblMenuItem.backgroundColor = [UIColor clearColor];
    cell.lblMenuItem.textColor = [UIColor whiteColor];
    cell.lblMenuItem.text = [arrMenuItems objectAtIndex:indexPath.row] ;
    cell.imgMenuItem.contentMode = UIViewContentModeCenter;
    
    
    //Menu Image
    //UIImageView *imgMenuItem = (UIImageView*)[cell.contentView viewWithTag:kimgMenuItem];
    
    //NSString *imgBundlePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[]];
    cell.imgMenuItem.image = [UIImage imageNamed:[arrMenuItemsImages objectAtIndex:indexPath.row]];
    
//    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - TableView delegate

-(UIViewController *)goToController:(NSString*)identifier
{
    UIViewController *viewcontroller = [kMainStoryboard instantiateViewControllerWithIdentifier: identifier];
    return viewcontroller;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"isLocation"];
    }
    
    
    NSString *keyName = arrMenuItems[indexPath.row];
    
    //NSLog(@"Left Menu key : %@",keyName);
    
    if([keyName caseInsensitiveCompare:@"Home"] == NSOrderedSame){
        NSLog(@"Home");
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>2)
        {
            [controllers removeLastObject];
        }
        navigationController.viewControllers = controllers;
        
        //[kAppDelegate.container.centerViewController pushViewController:[self goToController:@"home"] animated:NO];
    }
    else if ([keyName caseInsensitiveCompare:@"Share"] == NSOrderedSame)
    {   
        //[appdelegate.container.centerViewController pushViewController:[self goToController:@"appointments"] animated:NO];
        
        // grab an item we want to share
        //UIImage *image = [UIImage imageNamed:@"xyz"];
        NSString *message = @"Check out our new app SportsPal";
        NSArray *items = @[message];
        
        // build an activity view controller
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
        
        // access the completion handler
        controller.completionWithItemsHandler = ^(NSString *activityType,
                                                  BOOL completed,
                                                  NSArray *returnedItems,
                                                  NSError *error){
            // react to the completion
            if (completed) {
                
                // user shared an item
                NSLog(@"We used activity type%@", activityType);
                
            } else {
                
                // user cancelled
                NSLog(@"We didn't want to share anything after all.");
            }
            
            if (error) {
                NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
            }
        };
        
        // and present it
        [self presentViewController:controller animated:YES completion:^{
            // executes after the user selects something
        }];
    }
    else if ([keyName caseInsensitiveCompare:@"Notifications"] == NSOrderedSame)
    {
        
        //TabBar Controller in storyboard
        [kAppDelegate.container.centerViewController pushViewController:[self goToController:@"notification"] animated:NO];
        
        //[kAppDelegate.container.centerViewController pushViewController:[self goToController:@"notification_vc"] animated:NO];
        
    }

    else if ([keyName caseInsensitiveCompare:@"Settings"] == NSOrderedSame)
    {
        [kAppDelegate.container.centerViewController pushViewController:[self goToController:@"settings"] animated:NO];
        
    }
    else if ([keyName caseInsensitiveCompare:@"Logout"] == NSOrderedSame)
    {
        NSLog(@"Logout");
        //[appdelegate.container.centerViewController popToRootViewControllerAnimated:YES];
        [kAppDelegate.objLoader show];
        [model_manager.loginManager logout:^(NSDictionary *dictJson, NSError *error) {
            [kAppDelegate.objLoader hide];
            if(!error)
            {
                if([[dictJson valueForKey:@"success"] boolValue])
                {
                    [kAppDelegate.container.centerViewController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    [self showAlert:[dictJson valueForKey:@"message"]];
                }
            }
        }];

    }
    else {
        NSLog(@"Logout clicked");
        
    }
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    
    
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
