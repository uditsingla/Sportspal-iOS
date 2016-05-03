//
//  AddTeam.m
//  SportsPal
//
//  Created by Abhishek Singla on 01/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#define sportname 1
#define teamname 2
#define teamtype 3
#define teamsize 4

#import "AddTeam.h"
#import "Add_VC.h"

#import "Sport.h"

@interface AddTeam ()
{
    __weak IBOutlet UIPickerView *pickerSports;
    __weak IBOutlet UIPickerView *pickerType;
    
    __weak IBOutlet UIButton *btnSportName;
    __weak IBOutlet UIButton *btnTeamName;
    __weak IBOutlet UIButton *btnTeamType;
    __weak IBOutlet UIButton *btnTeamSize;
    
    __weak IBOutlet UILabel *lblteamCurrentMembers;
    __weak IBOutlet UILabel *lblteamMaxMembers;


    
    NSString *strSportName,*strSportID,*strTeamname,*strTeamType;
    int teamSize;
    
    int pickerselected;
    UIToolbar *toolBar;
    
    __weak IBOutlet UISegmentedControl *segmentcotrol;
    
    NSArray *arraySportsType;
}
- (IBAction)clkSlider:(id)sender;

- (IBAction)clkButton:(id)sender;

- (IBAction)clkSegment:(UISegmentedControl*)sender;

@end

@implementation AddTeam
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,pickerSports.frame.origin.y-44,pickerSports.frame.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    toolBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(selectDateTime:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    [self.view addSubview:toolBar];
    //
    
    [UIView appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil].backgroundColor =[UIColor colorWithWhite:1 alpha:0];
    

    
    [segmentcotrol addTarget:self
                      action:@selector(clkSegment:)
            forControlEvents:UIControlEventValueChanged];
    
    [segmentcotrol setSelectedSegmentIndex:1];
    
    
    [self hideAllPickers];
    
    arraySportsType = [NSArray arrayWithObjects:@"Corporate",@"Private", nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   // NSLog(@"%@",self.navigationController.viewControllers);
//    self.tabBarController.tabBar.hidden = NO;
//    self.hidesBottomBarWhenPushed = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clkSlider:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)clkButton:(id)sender {
    
    [self hideAllPickers];
    
    UIButton *btn = (UIButton*)sender;
    
    
    if (btn.tag == sportname)
    {
        pickerselected = sportname;
        pickerSports.hidden = NO;
        toolBar.hidden = NO;
        
    }
    else if (btn.tag == teamname){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Team Name"
                                                                                  message: @"Choose your teamname"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Team Name";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            
            strTeamname = namefield.text;
            
            [btnTeamName setTitle:strTeamname forState:UIControlStateNormal];
            NSLog(@"%@",namefield.text);
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (btn.tag == teamtype)
    {
        
        pickerselected = teamtype;
        pickerType.hidden = NO;
        toolBar.hidden = NO;
        
        
    }
    
    else if (btn.tag == teamsize)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Team Size"
                                                                                  message: @"Max number of members"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Team Size";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            
            teamSize = [namefield.text intValue];
            
            [btnTeamSize setTitle:namefield.text forState:UIControlStateNormal];
            
            lblteamMaxMembers.text = [NSString stringWithFormat:@"MAX. SIZE (%@)",namefield.text];
            NSLog(@"%@",namefield.text);
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    //[self createNewGame];
}


-(void)hideAllPickers
{
    
    pickerSports.hidden =YES;
    pickerType.hidden = YES;
    toolBar.hidden = YES;
    
}

-(void)createNewTeam
{
    Game *game = [Game new];
    game.sportID = strSportID;
    game.sportName = strSportName;
    game.creator = model_manager.profileManager.owner;
    game.gameType = GameTypeIndividual;
    game.geoLocation = kAppDelegate.myLocation.coordinate;
    
    [kAppDelegate.objLoader show];
    
    [model_manager.sportsManager createNewGame:game completion:^(NSDictionary *dictJson, NSError *error) {
        [kAppDelegate.objLoader hide];
        if(!error)
        {
            if([[dictJson valueForKey:@"success"] boolValue])
            {
                //game created successfully
                [self showAlert:[dictJson valueForKey:@"message"]];
            }
            else
            {
                [self showAlert:[dictJson valueForKey:@"message"]];
            }
        }
    }];
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

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    if (pickerView == pickerSports) {
        return  [ModelManager modelManager].sportsManager.arraySports.count;
    }
    else if (pickerView == pickerType)
        return 2;
    
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView == pickerSports) {
        Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
            return  sport.sportName;
    }
    else if (pickerView == pickerType)
    {
        return arraySportsType[row];
    }

    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == pickerSports)
    {
        Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
        strSportName=  sport.sportName;
        strSportID = sport.sportID;
    }
    
    else if (pickerView == pickerType)
    {
        strTeamType = arraySportsType[row];
    }
    
    NSLog(@"Sport Name : %@",strSportName);
}




#pragma mark - Segment control
- (IBAction)clkSegment:(UISegmentedControl*)sender
{
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        NSLog(@"sport");
        //[self.navigationController popViewControllerAnimated:NO];
        
        NSArray *arrControlers = self.tabBarController.viewControllers;
        
        Add_VC *addTeam = [kMainStoryboard instantiateViewControllerWithIdentifier:@"add_vc"];
        
        addTeam.title=@"ADD";
        addTeam.tabBarItem.image=[UIImage imageNamed:@"add.png"];
        
        
        UIViewController *thisIsTheViewControllerIWantToSetNow = addTeam;
        int indexForViewControllerYouWantToReplace = 2;
        
        NSMutableArray *tabbarViewControllers = [arrControlers mutableCopy];
        
        [tabbarViewControllers replaceObjectAtIndex:indexForViewControllerYouWantToReplace withObject:thisIsTheViewControllerIWantToSetNow];
        

        
        self.tabBarController.viewControllers = tabbarViewControllers;
        
        }
    
}


- (IBAction)clkSave:(id)sender
{
    
    if ([self validateData])
    {
        [self createNewTeam];
    }
    
}

-(BOOL)validateData
{
    return YES;
}



-(void)selectDateTime:(id)sender
{
    if (pickerselected == sportname)
    {
        if (strSportName == nil)
        {
            Sport *sport = [[ModelManager modelManager].sportsManager.arraySports objectAtIndex:0];
            
            strSportName = sport.sportName;
            strSportID = sport.sportID;
        }
        
        [btnSportName setTitle:strSportName forState:UIControlStateNormal];
    }
    
    else if (pickerselected == teamtype)
    {
        if (strTeamType == nil)
        {
            strTeamType = arraySportsType[0];
        }
        [btnTeamType setTitle:strTeamType forState:UIControlStateNormal];
    }

    
    [self hideAllPickers];
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
