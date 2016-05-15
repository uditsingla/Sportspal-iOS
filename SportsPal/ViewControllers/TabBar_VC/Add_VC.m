//
//  Add_VC.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//




#define ksportname 1
#define kgametype 2
#define kteamname 3
#define kgamename 4
#define kdate 5
#define ktime 6
#define kaddress 7




#import "Add_VC.h"
#import "AddTeam.h"
#import "Sport.h"
#import "SetLocationScreen.h"


@interface Add_VC ()
{
    
    __weak IBOutlet UIPickerView *pickerTeamName;
    __weak IBOutlet UIPickerView *pickerGameType;
    __weak IBOutlet UIPickerView *pickerSports;
    __weak IBOutlet UIDatePicker *pikerDate;
    __weak IBOutlet UIDatePicker *pikerTime;
    
    __weak IBOutlet UIButton *btnTime;
    __weak IBOutlet UIButton *btnGameName;
    __weak IBOutlet UIButton *btnAddress;
    __weak IBOutlet UIButton *btnDate;
    __weak IBOutlet UIButton *btnSportName;
    
    __weak IBOutlet UIButton *btnGameType;
    __weak IBOutlet UIButton *btnTeamName;
    
    NSString *strSportName,*strSportID,*strGameName;
    
    NSString *strDate,*strTime;
    
    int pickerselected;
    UIToolbar *toolBar;
    
    __weak IBOutlet UISegmentedControl *segmentcotrol;
    
    
    __weak IBOutlet NSLayoutConstraint *constraintHeight;
    //__weak IBOutlet NSLayoutConstraint *contImageTeamName;
    
    //__weak IBOutlet NSLayoutConstraint *contBtngap;
    //__weak IBOutlet NSLayoutConstraint *contImageGap;
    
    NSArray *arrGameType;
    //NSMutableArray *arrTeamName;
    
    NSString *strGameType,*strTeamName,*strTeamID,*strLocation;
    
    __weak IBOutlet UIView *magicView;
    
    
    __weak IBOutlet UIView *toolBarSuperView;
    
    
    __weak IBOutlet UIImageView *imgSelectedImage;
}
- (IBAction)clkButton:(id)sender;
- (IBAction)clkSegment:(UISegmentedControl*)sender;
- (IBAction)clkSave:(id)sender;
- (IBAction)clkSlider:(id)sender;

@end

@implementation Add_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [pikerDate addTarget:self action:@selector(dateChanged:)               forControlEvents:UIControlEventValueChanged];
    
    [pikerTime addTarget:self action:@selector(timeChanged:)               forControlEvents:UIControlEventValueChanged];
    
    
    //
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    toolBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(clkDone:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    [toolBarSuperView addSubview:toolBar];
    //
    
    [UIView appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil].backgroundColor =[UIColor colorWithWhite:1 alpha:0];
    
    pikerDate.backgroundColor=[UIColor whiteColor];
    pikerDate.backgroundColor=[UIColor whiteColor];//Another view on which you subview picker
    
    pikerTime.backgroundColor=[UIColor whiteColor];
    pikerTime.backgroundColor=[UIColor whiteColor];

    
    
    [segmentcotrol addTarget:self
                         action:@selector(clkSegment:)
               forControlEvents:UIControlEventValueChanged];

    
    arrGameType = [NSArray arrayWithObjects:@"Individual",@"Team", nil];
    
    //arrTeamName = [NSMutableArray new];
    
    [self hideAllPickers];


    if (strSportName == nil) {
        imgSelectedImage.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    [segmentcotrol setSelectedSegmentIndex:0];
    
    
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"isLocation"]);
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isLocation"] isEqualToString:@"locationclicked"])
    {
        if(model_manager.profileManager.svp_LocationInfo)
            [btnAddress setTitle:model_manager.profileManager.svp_LocationInfo.formattedAddress forState:UIControlStateNormal];
    }
    else
    {
        [self resetAllContent];
    }
    
        
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clkButton:(id)sender {
    
    [self hideAllPickers];
    
    UIButton *btn = (UIButton*)sender;
    
    
    if (btn.tag == ksportname)
    {
        
        pickerselected = ksportname;
        
        pickerSports.hidden = NO;
        toolBarSuperView.hidden = NO;
        
        
        
    }
    else if (btn.tag == kgametype)
    {
        pickerselected = kgametype;
        pickerGameType.hidden = NO;
        toolBarSuperView.hidden = NO;

    }
    else if (btn.tag == kteamname)
    {
        if(model_manager.profileManager.owner.arrayTeams.count==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No team available" message:@"Please create new team first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            strGameType = @"Individual";
            [btnGameType setTitle:@"Individual" forState:UIControlStateNormal];
            return;
        }
        pickerselected = kteamname;
        pickerTeamName.hidden = NO;
        toolBarSuperView.hidden = NO;
        
    }
    
    else if (btn.tag == kgamename){
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
                
            strGameName = namefield.text;
                
            [btnGameName setTitle:strGameName forState:UIControlStateNormal];
            NSLog(@"%@",namefield.text);
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else if (btn.tag == kdate){
        
        pickerselected = kdate;
        pikerDate.hidden = NO;
        toolBarSuperView.hidden = NO;
        
        
    }
    else if (btn.tag == ktime){
        
        pickerselected = ktime;
        pikerTime.hidden = NO;
        toolBarSuperView.hidden = NO;
    }
    else if (btn.tag == kaddress){
        
        
        [[NSUserDefaults standardUserDefaults]setValue:@"locationclicked" forKey:@"isLocation"];
        
        SetLocationScreen *obj = [SetLocationScreen new];
        [self.navigationController pushViewController:obj animated:YES];
    }
    
}


-(void)hideAllPickers
{
    pickerGameType.hidden =YES;
    pickerTeamName.hidden = YES;
    pickerSports.hidden =YES;
    pikerDate.hidden = YES;
    pikerTime.hidden = YES;
    toolBarSuperView.hidden = YES;
    
}

-(void)resetAllContent
{
    [self hideAllPickers];
    imgSelectedImage.hidden = YES;
    strSportName = nil;
    strSportID = nil;
    strGameName = nil;
    strDate = nil;
    strTime = nil;
    strGameType = nil;
    strTeamName = nil;
    
    constraintHeight.constant = 40;
    magicView.hidden = NO;
    
    [btnSportName setTitle:@"SPORT" forState:UIControlStateNormal];
    [btnGameType setTitle:@"GAME TYPE" forState:UIControlStateNormal];
    [btnTeamName setTitle:@"TEAM NAME" forState:UIControlStateNormal];
    [btnGameName setTitle:@"GAME NAME" forState:UIControlStateNormal];
    [btnDate setTitle:@"DD/MM/YYYY" forState:UIControlStateNormal];
    [btnTime setTitle:@"HH:MM" forState:UIControlStateNormal];
    [btnAddress setTitle:@"PICK ADDRESS" forState:UIControlStateNormal];

}

-(void)createNewGame
{
    Game *game = [Game new];
    game.sportID = strSportID;
    game.sportName = strSportName;
    game.creator = model_manager.profileManager.owner;
    game.gameName = strGameName;
    if([strGameType isEqualToString:@"Individual"])
        game.gameType = GameTypeIndividual;
    else
    {
        game.gameType = GameTypeTeam;
        game.teamID = strTeamID;
    }
    game.date = strDate;
    game.time = strTime;
    game.geoLocation = kAppDelegate.myLocation.coordinate;
    game.address = btnAddress.titleLabel.text;
    
    [kAppDelegate.objLoader show];
    
    [model_manager.sportsManager createNewGame:game completion:^(NSDictionary *dictJson, NSError *error) {
        [kAppDelegate.objLoader hide];
        if(!error)
        {
            if([[dictJson valueForKey:@"success"] boolValue])
            {
                //game created successfully
                [self showAlert:[dictJson valueForKey:@"message"]];
                
               /*
                [btnSportName setTitle:@"SPORT" forState:UIControlStateNormal];
                [btnTeamName setTitle:@"TEAM NAME" forState:UIControlStateNormal];
                [btnDate setTitle:@"DD/MM/YYYY" forState:UIControlStateNormal];
                [btnTime setTitle:@"HH:MM" forState:UIControlStateNormal];
                [btnAddress setTitle:@"PICK ADDRESS" forState:UIControlStateNormal];
                [btnGameName setTitle:@"GAME NAME" forState:UIControlStateNormal];
                [btnGameType setTitle:@"GAME TYPE" forState:UIControlStateNormal];
                
                
                strSportName = @"";
                strSportID = @"";
                strTeamName = @"";
                strDate = @"";
                strTime = @"";
                strGameName = @"";
                strGameType = @"";
                strTeamID = @"";
                */
                
                [self resetAllContent];
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
                                  alertControllerWithTitle:@""
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
    if(pickerView == pickerSports)
    return  [ModelManager modelManager].sportsManager.arraySports.count;
    
    else if(pickerView == pickerGameType)
    return arrGameType.count;
    
    else if (pickerView == pickerTeamName)
    return model_manager.profileManager.owner.arrayTeams.count;
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(pickerView == pickerSports)
    {
        Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
        return  sport.sportName;
    }
    
    else if(pickerView == pickerGameType)
    {
        return arrGameType[row];

    }
    
    else if (pickerView == pickerTeamName)
    {
        return ((Team*)model_manager.profileManager.owner.arrayTeams[row]).teamName;
    }
    return  @"";
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
   // NSLog(@"Sport Name : %@",strSportName);
    
    
    
    if(pickerView == pickerSports)
    {
        Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
        strSportName=  sport.sportName;
        strSportID = sport.sportID;
    }
    
    else if(pickerView == pickerGameType)
    {
        strGameType =  arrGameType[row];
        
        if ([strGameType isEqualToString:@"Individual"])
        {
            constraintHeight.constant = 0;
            magicView.hidden = YES;
//            contImageTeamName.constant = 0;
//            contImageGap.constant = 0;
//            contBtngap.constant = 0;
        }
        else
        {
            constraintHeight.constant = 40;
            magicView.hidden = NO;

//            contImageTeamName.constant = 23;
//            contBtngap.constant = 15;
//            contBtngap.constant = 17;
        }
        
        
    }
    
    else if (pickerView == pickerTeamName)
    {
        strTeamName = ((Team*)model_manager.profileManager.owner.arrayTeams[row]).teamName;
        strTeamID = ((Team*)model_manager.profileManager.owner.arrayTeams[row]).teamID;
    }
}


- (void)dateChanged:(UIDatePicker *)datePicker
{
    NSLog(@"value: %@",[NSDate date]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    strDate = [dateFormatter stringFromDate:datePicker.date];
    
}

- (void)timeChanged:(UIDatePicker *)datePicker
{
    NSLog(@"value: %@",[NSDate date]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    strTime = [dateFormatter stringFromDate:datePicker.date];
    
}

-(void)clkDone:(id)sender
{
    if (pickerselected == ksportname)
    {
        if (strSportName == nil)
        {
            Sport *sport = [[ModelManager modelManager].sportsManager.arraySports objectAtIndex:0];
            
            strSportName = sport.sportName;
            strSportID = sport.sportID;
        }
        
        imgSelectedImage.hidden = NO;
        NSString *strImageName = [strSportName lowercaseString];
        imgSelectedImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",strImageName]];
        
        [btnSportName setTitle:strSportName forState:UIControlStateNormal];
    }
    
    else if (pickerselected == kgametype)
    {
        if (strGameType == nil)
        {
            strGameType = [arrGameType objectAtIndex:0];
            
            constraintHeight.constant = 0;
            magicView.hidden = YES;

        }
        [btnGameType setTitle:strGameType forState:UIControlStateNormal];
        
    }
    
    else if (pickerselected == kteamname)
    {
        
        if (strTeamName == nil)
        {
            strTeamName = ((Team*)model_manager.profileManager.owner.arrayTeams[0]).teamName;
            strTeamID = ((Team*)model_manager.profileManager.owner.arrayTeams[0]).teamID;
        }
        [btnTeamName setTitle:strTeamName forState:UIControlStateNormal];
    }
    
   
    
    else if (pickerselected == kdate)
    {
        [btnDate setTitle:strDate forState:UIControlStateNormal];
    }
    else if (pickerselected == ktime)
    {
        [btnTime setTitle:strTime forState:UIControlStateNormal];
    }
    
    [self hideAllPickers];
}


#pragma mark - Segment control
- (IBAction)clkSegment:(UISegmentedControl*)sender
{
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        NSLog(@"sport");
    }
    
    else if (selectedSegment == 1)
    {
        NSLog(@"team");
        
        
        NSLog(@"Tabbar controlles : %@",self.tabBarController.viewControllers);
        
        NSArray *arrControlers = self.tabBarController.viewControllers;
        
        AddTeam *addTeam = [kMainStoryboard instantiateViewControllerWithIdentifier:@"addteam"];

        
        UIViewController *thisIsTheViewControllerIWantToSetNow = addTeam;
        int indexForViewControllerYouWantToReplace = 2;
        
        NSMutableArray *tabbarViewControllers = [arrControlers mutableCopy];
        
        [tabbarViewControllers replaceObjectAtIndex:indexForViewControllerYouWantToReplace withObject:thisIsTheViewControllerIWantToSetNow];
        
        self.tabBarController.viewControllers = tabbarViewControllers;

    }
}

- (IBAction)clkSave:(id)sender {
    
    if(segmentcotrol.selectedSegmentIndex==0)
        [self createNewGame];
}

- (IBAction)clkSlider:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}




@end
