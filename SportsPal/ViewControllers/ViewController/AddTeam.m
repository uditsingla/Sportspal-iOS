//
//  AddTeam.m
//  SportsPal
//
//  Created by Abhishek Singla on 01/05/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#define sportname 1
#define teamname 2
#define kdate 3
#define time 4
#define address 5

#import "AddTeam.h"

@interface AddTeam ()
{
    __weak IBOutlet UIPickerView *pickerSports;
    __weak IBOutlet UIDatePicker *pikerDate;
    __weak IBOutlet UIDatePicker *pikerTime;
    
    __weak IBOutlet UIButton *btnTime;
    __weak IBOutlet UIButton *btnTeamName;
    __weak IBOutlet UIButton *btnAddress;
    __weak IBOutlet UIButton *btnDate;
    __weak IBOutlet UIButton *btnSportName;
    
    NSString *strSportName,*strSportID,*strTeamname;
    
    NSString *strDate,*strTime;
    
    int pickerselected;
    UIToolbar *toolBar;
    
    __weak IBOutlet UISegmentedControl *segmentcotrol;
}

- (IBAction)clkButton:(id)sender;
- (IBAction)clkSegment:(UISegmentedControl*)sender;

@end

@implementation AddTeam
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [pikerDate addTarget:self action:@selector(dateChanged:)               forControlEvents:UIControlEventValueChanged];
    
    [pikerTime addTarget:self action:@selector(timeChanged:)               forControlEvents:UIControlEventValueChanged];
    
    
    //
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,pikerDate.frame.origin.y-44,pikerDate.frame.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    toolBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(selectDateTime:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    [self.view addSubview:toolBar];
    //
    
    [UIView appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil].backgroundColor =[UIColor colorWithWhite:1 alpha:0];
    
    pikerDate.backgroundColor=[UIColor whiteColor];
    pikerDate.backgroundColor=[UIColor whiteColor];//Another view on which you subview picker
    
    pikerTime.backgroundColor=[UIColor whiteColor];
    pikerTime.backgroundColor=[UIColor whiteColor];
    
    
    
    [segmentcotrol addTarget:self
                      action:@selector(clkSegment:)
            forControlEvents:UIControlEventValueChanged];
    
    [segmentcotrol setSelectedSegmentIndex:1];
    
    
    [self hideAllPickers];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else if (btn.tag == kdate){
        
        pickerselected = kdate;
        pikerDate.hidden = NO;
        toolBar.hidden = NO;
        
        
    }
    else if (btn.tag == time){
        
        pickerselected = time;
        pikerTime.hidden = NO;
        toolBar.hidden = NO;
    }
    else if (btn.tag == address){
        
    }
    
    //[self createNewGame];
}


-(void)hideAllPickers
{
    
    pickerSports.hidden =YES;
    pikerDate.hidden = YES;
    pikerTime.hidden = YES;
    toolBar.hidden = YES;
    
}

-(void)createNewGame
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
    return  [ModelManager modelManager].sportsManager.arraySports.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
//    Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
//    return  sport.sportName;
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    Sport *sport = [ModelManager modelManager].sportsManager.arraySports[row];
//    strSportName=  sport.sportName;
//    strSportID = sport.sportID;
    
    NSLog(@"Sport Name : %@",strSportName);
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

-(void)selectDateTime:(id)sender
{
    if (pickerselected == sportname)
    {
        [btnSportName setTitle:strSportName forState:UIControlStateNormal];
    }
    else if (pickerselected == kdate)
    {
        [btnDate setTitle:strDate forState:UIControlStateNormal];
    }
    else if (pickerselected == time)
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
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}


- (IBAction)clkSave:(id)sender {
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
