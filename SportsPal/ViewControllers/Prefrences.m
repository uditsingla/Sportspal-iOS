//
//  Prefrences.m
//  SportsPal
//
//  Created by Abhishek Singla on 17/04/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import "Prefrences.h"

@interface Prefrences ()
{
    
    __weak IBOutlet UITableView *tblPrefrences;
    NSMutableArray *arrSelectedPrefrences;
    
}
- (IBAction)clkBack:(id)sender;
- (IBAction)clkDone:(id)sender;

@end

@implementation Prefrences

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    arrSelectedPrefrences = [NSMutableArray new];
    
    [arrSelectedPrefrences addObject:@"Cricket"];
    [arrSelectedPrefrences addObject:@"BadMinton"];
    [arrSelectedPrefrences addObject:@"Football"];
    [arrSelectedPrefrences addObject:@"Swimming"];
    [arrSelectedPrefrences addObject:@"Boxing"];
    [arrSelectedPrefrences addObject:@"Shoting"];
    
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clkBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clkDone:(id)sender
{
    NSLog(@"done");
}



#pragma mark - Delegates and Tatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [arrSelectedPrefrences objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    tblPrefrences.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSelectedPrefrences count];
}


#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %d row", indexPath.row);
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
