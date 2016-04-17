//
//  LeftSlider.m
//  ApiTap
//
//  Created by Abhishek Singla on 16/03/16.
//  Copyright © 2016 ApiTap. All rights reserved.
//

#import "LeftSlider.h"
#import "LeftSliderCell.h"

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
    
    arrMenuItems = [NSArray arrayWithObjects:@"Home",
                    @"Appointments",
                    @"History",
                    @"Logout",nil];
    
    arrMenuItemsImages = [NSArray arrayWithObjects:@"home.png",
                          @"ads.png",
                          @"special.png",
                          @"item.png",
                          nil];
    
    
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
//    cell.lblMenuItem.backgroundColor = GreenColor;
//    cell.lblMenuItem.textColor = LightGreyColor;
    cell.lblMenuItem.text = [arrMenuItems objectAtIndex:indexPath.row] ;
    
    
    //Menu Image
    //UIImageView *imgMenuItem = (UIImageView*)[cell.contentView viewWithTag:kimgMenuItem];
    
    //NSString *imgBundlePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[]];
    cell.imgMenuItem.image = [UIImage imageNamed:[arrMenuItemsImages objectAtIndex:indexPath.row]];
    
    //cell.backgroundColor = BlackBackground;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - TableView delegate

-(UIViewController *)goToController:(NSString*)identifier
{
//    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//    
//    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//    while (controllers.count>1)
//    {
//        [controllers removeLastObject];
//    }
//    navigationController.viewControllers = controllers;
//
//    
//    UIViewController *viewcontroller = [mainstoryboard instantiateViewControllerWithIdentifier: identifier];
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *keyName = arrMenuItems[indexPath.row];
    
    //NSLog(@"Left Menu key : %@",keyName);
    
    if([keyName caseInsensitiveCompare:@"Home"] == NSOrderedSame){
        NSLog(@"Home");
        
        //[appdelegate.container.centerViewController pushViewController:[self goToController:@"home"] animated:NO];
    }
    else if ([keyName caseInsensitiveCompare:@"Appointments"] == NSOrderedSame)
    {   
        //[appdelegate.container.centerViewController pushViewController:[self goToController:@"appointments"] animated:NO];
    }
    
    else if ([keyName caseInsensitiveCompare:@"History"] == NSOrderedSame){
        NSLog(@"History");
        
         //[appdelegate.container.centerViewController pushViewController:[self goToController:@"history"] animated:NO];
        
    }
    
    else if ([keyName caseInsensitiveCompare:@"Logout"] == NSOrderedSame)
    {
        NSLog(@"Logout");
        //[appdelegate.container.centerViewController popToRootViewControllerAnimated:YES];

    }
    else {
        NSLog(@"Logout clicked");
        
    }
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    
    
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
