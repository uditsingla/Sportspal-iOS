//
//  SetLocationScreen.m
//  Plank
//
//  Created by admin on 18/06/15.
//  Copyright (c) 2015 Sourcefuse. All rights reserved.
//

#import "SetLocationScreen.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SVGeocoder.h"
#import "AppDelegate.h"

@implementation UISearchBar (enabler)


- (void) alwaysEnableSearch
{
    // loop around subviews of UISearchBar
    
    NSMutableSet *viewsToCheck = [NSMutableSet setWithArray:[self subviews]];
    
    while ([viewsToCheck count] > 0)
        
    {
        
        UIView *searchBarSubview = [viewsToCheck anyObject];
        
        [viewsToCheck addObjectsFromArray:searchBarSubview.subviews];
        
        [viewsToCheck removeObject:searchBarSubview];
        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            
            @try {
                
                // always force return key to be enabled
                
                [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:NO];
                
                
                
            }
            
            @catch (NSException * e)
            
            {
                
                // ignore exception
                
            }
            
        }
        
    }
    
}

@end


@interface SetLocationScreen ()
{
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    
    UIImageView *topNavBar;
    UILabel *topHeader;
    UIButton *backBtn;
    
    UISearchBar *searchBar;
    
    UITableView *tbl_predictions;
    NSMutableArray *arr_locations;
    
    //LabeledActivityIndicatorView *objLoader;
}

@end

@implementation SetLocationScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mapView_.myLocationEnabled = YES;
    mapView_ = [GMSMapView mapWithFrame:self.view.frame camera:nil];
    mapView_.delegate = self;
    [self.view addSubview:mapView_];
    
    mapView_.camera = [GMSCameraPosition cameraWithLatitude:kAppDelegate.myLocation.coordinate.latitude
                                                  longitude:kAppDelegate.myLocation.coordinate.longitude
                                                       zoom:13];
    
    mapView_.settings.myLocationButton = YES;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    topNavBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topNavBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topNavBar];
    
//    topHeader= [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 52)];
//    topHeader.text=@"YOUR LOCATION";
//    topHeader.backgroundColor=[UIColor clearColor];
//    topHeader.numberOfLines=1;
//    topHeader.textAlignment=NSTextAlignmentCenter;
//    topHeader.textColor=[UIColor whiteColor];
//    topHeader.adjustsFontSizeToFitWidth=YES;
//    topHeader.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:22];
//    [self.view addSubview:topHeader];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchDown];
    backBtn.backgroundColor=[UIColor clearColor];
    backBtn.frame = CGRectMake(0, 7, 40 , 60);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(self.view.frame.size.width/2.0-176/2.0, self.view.frame.size.height/2.0-54, 176, 34);
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundImg = [[UIImageView alloc] init];
    backgroundImg.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) ;
    backgroundImg.image = [UIImage imageNamed:@"map_location.png"];
    [view addSubview:backgroundImg];

    UILabel *header= [[UILabel alloc]initWithFrame:CGRectMake(0, -4, view.frame.size.width, view.frame.size.height)];
    header.text=@"Set My Location";
    header.backgroundColor=[UIColor clearColor];
    header.numberOfLines=1;
    header.textAlignment=NSTextAlignmentCenter;
    header.textColor=[UIColor whiteColor];
    header.adjustsFontSizeToFitWidth=YES;
    header.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
    [view addSubview:header];
    
    [self.view addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [view addGestureRecognizer:tap];
    
    UIImageView *markerIconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-50/4.0, self.view.frame.size.height/2.0-66/4.0, 50/2.0, 66/2.0)];
    markerIconView.image = [UIImage imageNamed:@"marker.png"];
    [self.view addSubview:markerIconView];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(35, 18, self.view.frame.size.width - 70, 42)];
    
    searchBar.placeholder = @"search location";
    [self.view addSubview:searchBar];
    
    searchBar.delegate = self;
    //////////////////
    // Search Bar Customization
    [searchBar setBackgroundImage:[[UIImage alloc]init]];
    
    [searchBar setBackgroundColor:[UIColor clearColor]];
    
    [searchBar setTintColor:[UIColor clearColor]];
    [searchBar setBarTintColor:[UIColor whiteColor]];
    
    
    //////////////////
    
    UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = [UIColor clearColor];
    txfSearchField.textColor = [UIColor whiteColor];
    txfSearchField.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14];
    
    // Change the search bar placeholder text color
    [txfSearchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    txfSearchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [searchBar setSearchTextPositionAdjustment:UIOffsetMake(3, 0)];
    
//    if(model_manager.profilemanager.svp_LocationInfo)
//    {
//        searchBar.text = model_manager.profilemanager.svp_LocationInfo.formattedAddress;
//    }
//    else
    {
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(kAppDelegate.myLocation.coordinate.latitude, kAppDelegate.myLocation.coordinate.longitude)
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
                            if(error)
                            {
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            
                            
                            else if([placemarks count]>0)
                            {
                                SVPlacemark *svp_Obj = [placemarks firstObject];
                                NSLog(@"Dictonary for google location = %@", svp_Obj);
                                
                                
                                searchBar.text = svp_Obj.formattedAddress;
                                
                                
                            }
                            
                        }];
    }

    
    //Table Predictions
    tbl_predictions=[[UITableView alloc]initWithFrame:CGRectMake(searchBar.frame.origin.x, topNavBar.frame.origin.y + topNavBar.frame.size.height-1.5, searchBar.frame.size.width, 200)];
    //TableView Delegates
    tbl_predictions.dataSource = self;
    tbl_predictions.delegate = self;
    tbl_predictions.tag = 444;
    //tbl_predictions.separatorColor = [UIColor clearColor];
    tbl_predictions.backgroundColor=[UIColor whiteColor];
    tbl_predictions.hidden=YES;
    tbl_predictions.layer.borderColor = [UIColor colorWithRed:65/255.0 green:195/255.0 blue:214/255.0 alpha:1].CGColor;
    tbl_predictions.layer.borderWidth = 1.5;
    [self.view addSubview:tbl_predictions];
    
    
    arr_locations = [[NSMutableArray alloc] init];
    
    
    //redirect to curent location button
//    UIButton *currentLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [currentLocationBtn addTarget:self action:@selector(redirectCurrentLocation) forControlEvents:UIControlEventTouchDown];
//    currentLocationBtn.backgroundColor=[UIColor clearColor];
//    currentLocationBtn.frame = CGRectMake(self.view.frame.size.width - 75, self.view.frame.size.height - 75, 60 , 60);
//    [currentLocationBtn setImage:[UIImage imageNamed:@"current_location_btn.png"] forState:UIControlStateNormal];
//    [self.view addSubview:currentLocationBtn];
    
    //objLoader=[[LabeledActivityIndicatorView alloc] initWithController:self andText:@"Loading..."];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Implement here to check if already KVO is implemented.
    
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Implement here if the view has registered KVO
    
    [mapView_ removeObserver:self forKeyPath:@"myLocation"];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if((kAppDelegate.myLocation.coordinate.latitude!=mapView_.camera.target.latitude) && (kAppDelegate.myLocation.coordinate.longitude!=mapView_.camera.target.longitude))
    {
        kAppDelegate.myLocation = [[CLLocation alloc] initWithLatitude:mapView_.camera.target.latitude longitude:mapView_.camera.target.longitude];
        
        [kAppDelegate.objLoader show];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [SVGeocoder reverseGeocode:mapView_.camera.target
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
                            if(error)
                            {
                                [kAppDelegate.objLoader hide];
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            
                            
                            else if([placemarks count]>0)
                            {
                                model_manager.profileManager.svp_LocationInfo = [placemarks firstObject];
                                NSLog(@"Dictonary for google location = %@", [placemarks firstObject]);
                                
                                [kAppDelegate.objLoader hide];
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        }];
        
        
        
    }

}

-(void)backBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
//        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
//                                                         zoom:14];
    }
}


#pragma mark mapview delegates

//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
//{
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, 200, 40);
//    view.backgroundColor = [UIColor colorWithRed:65/255.0 green:172/255.0 blue:189/255.0 alpha:1];
//    view.layer.cornerRadius = 5.0;
//    
//    
//    UILabel *header= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
//    header.text=@"Set My Location";
//    header.backgroundColor=[UIColor clearColor];
//    header.numberOfLines=1;
//    header.textAlignment=NSTextAlignmentCenter;
//    header.textColor=[UIColor whiteColor];
//    header.adjustsFontSizeToFitWidth=YES;
//    header.font= [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
//    [view addSubview:header];
//    
//    return view;
//}

// Since we want to display our custom info window when a marker is tapped, use this delegate method
//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
//{
//    if(marker.title.length == 0)
//        return NO ;
//    
//    
//    [mapView setSelectedMarker:marker];
//    return YES;
//}



/* If the map is tapped on any non-marker coordinate, reset the currentlyTappedMarker and remove our
 custom info window from self.view */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    tbl_predictions.hidden = YES;
    [arr_locations removeAllObjects];
    [tbl_predictions reloadData];
    //hide search keyboard if open
    [searchBar resignFirstResponder];
}

//- (void)mapView:(GMSMapView *)mapView
//didTapInfoWindowOfMarker:(GMSMarker *)marker
//{
//    if((model_manager.profilemanager.currentLatitude!=marker.position.latitude) && (model_manager.profilemanager.currentLongitude!=marker.position.longitude))
//    {
//        model_manager.profilemanager.currentLatitude = marker.position.latitude;
//        model_manager.profilemanager.currentLongitude = marker.position.longitude;
//        
//        [appdelegate.objLoader show];
//        
//        [SVGeocoder reverseGeocode:marker.position
//                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
//                            
//                            if(error)
//                            {
//                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                                [alert show];
//                            }
//                            
//                            
//                            else if([placemarks count]>0)
//                            {
//                                model_manager.profilemanager.svp_LocationInfo = [placemarks firstObject];
//                                NSLog(@"Dictonary for google location = %@", [placemarks firstObject]);
//                                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationFetched object:@"success"];
//                                [appdelegate.objLoader hide];
//                                [self.navigationController popViewControllerAnimated:YES];
//                            }
//                            
//                        }];
//
//        
//        
//    }
//    
//}


- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)position
{
    NSLog(@"%f......%f",position.target.latitude,position.target.longitude);
    [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(position.target.latitude,position.target.longitude)
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        
                        if(error)
                        {
//                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                            [alert show];
                        }
                        
                        
                        else if([placemarks count]>0)
                        {
                            SVPlacemark *svp_Obj = [placemarks firstObject];
                            NSLog(@"Dictonary for google location = %@", svp_Obj);
                            
                            
                            searchBar.text = svp_Obj.formattedAddress;
                            
                            
                        }
                        
                    }];

}


#pragma mark tableview delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return arr_locations.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
        return 40;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *_simpleTableIdentifier = @"CellIdentifier";
    
    
    
        UITableViewCell *cellnew = [tableView dequeueReusableCellWithIdentifier:_simpleTableIdentifier];
        UILabel *lbl_heading;
        if (cellnew == nil)
        {
            cellnew = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_simpleTableIdentifier];
            cellnew.backgroundColor=[UIColor clearColor];
            cellnew.selectionStyle=UITableViewCellSelectionStyleNone;
            
            //            imageview= [[UIImageView alloc]initWithFrame:CGRectMake(7, 14, 306, 113)];
            //            imageview.tag=1;
            //            imageview.image=[UIImage imageNamed:@"row_bg.png"];
            //            [cellnew.contentView addSubview:imageview];
            
            lbl_heading= [[UILabel alloc]initWithFrame:CGRectMake(10, 0, searchBar.frame.size.width-20, 40)];
            lbl_heading.tag=2;
            lbl_heading.backgroundColor=[UIColor clearColor];
            [lbl_heading setTextColor:[UIColor grayColor]];
            lbl_heading.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
            [cellnew.contentView addSubview:lbl_heading];
            
        }
        [cellnew setSelectionStyle:UITableViewCellSelectionStyleGray];
        //        imageview = (UIImageView *)[cellnew.contentView viewWithTag:1];
        lbl_heading = (UILabel *)[cellnew.contentView viewWithTag:2];
    
        SPGooglePlacesAutocompletePlace *place = [arr_locations objectAtIndex:indexPath.row];
        lbl_heading.text = place.name;
        
        return cellnew;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        SPGooglePlacesAutocompletePlace *place = [arr_locations objectAtIndex:indexPath.row];
    
        searchBar.text = place.name;
        tbl_predictions.hidden = YES;
        [searchBar resignFirstResponder];
    
    {
        SPGooglePlacesAutocompletePlace *place = [arr_locations objectAtIndex:indexPath.row];
        [kAppDelegate.objLoader show];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        //Third party class for forward-geo coding
        [SVGeocoder geocode:place.name
                 completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                     
                     if(error)
                     {
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     else
                     {
                         SVPlacemark *svp_Obj = [placemarks firstObject];
                         NSLog(@"Dictonary for google location = %@", svp_Obj);
                         
                         
                             
//                             GMSMarker *marker = [GMSMarker markerWithPosition:svp_Obj.coordinate];
//                             
//                             marker.map = mapView_;
//                             marker.title = svp_Obj.formattedAddress;
//                             marker.snippet = @"Tap here to set my current location";
//                             marker.userData = svp_Obj;
//                             
//                             [mapView_ setSelectedMarker:marker];
                             
                            
                             GMSCameraPosition *pos = [GMSCameraPosition cameraWithLatitude:svp_Obj.coordinate.latitude
                                                                                  longitude:svp_Obj.coordinate.longitude
                                                                                       zoom:13];
                             [mapView_ animateToCameraPosition:pos];
                         
                     }
                     
                     [kAppDelegate.objLoader hide];
                     [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                 }];
    }
        
    [arr_locations removeAllObjects];
    [tbl_predictions reloadData];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UISearchbar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
    //This is for Location Search, while adding a new location
    if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        tbl_predictions.hidden = YES;
        [arr_locations removeAllObjects];
        [tbl_predictions reloadData];
        
    }
    
    SPGooglePlacesAutocompleteQuery *query = [SPGooglePlacesAutocompleteQuery query];
    if (query) {
        query = nil;
        query = [SPGooglePlacesAutocompleteQuery query];
    }
    query.input = searchBar.text;
    query.radius = 100.0;
    query.language = @"en";
    query.types = SPPlaceTypeGeocode; // Only return geocoding (address) results.
    query.location = kAppDelegate.myLocation.coordinate;
    
    
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        if(places.count>0 && [searchBar isFirstResponder])
        {
            tbl_predictions.hidden = NO;
            [arr_locations removeAllObjects];
            arr_locations = [places mutableCopy];
            
            if(arr_locations.count*40<200)
                tbl_predictions.frame = CGRectMake(searchBar.frame.origin.x, topNavBar.frame.origin.y + topNavBar.frame.size.height-1.5, searchBar.frame.size.width, arr_locations.count*40);
            else
                tbl_predictions.frame = CGRectMake(searchBar.frame.origin.x, topNavBar.frame.origin.y + topNavBar.frame.size.height-1.5, searchBar.frame.size.width, 200);
            [tbl_predictions reloadData];
            
        }
        else
        {
            tbl_predictions.hidden = YES;
            [arr_locations removeAllObjects];
            [tbl_predictions reloadData];
        }
        
    }];

    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    tbl_predictions.hidden = YES;
    [arr_locations removeAllObjects];
    [tbl_predictions reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
    
    //[searchBar alwaysEnableSearch];
    
}



- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar

{
    if(searchBar.text.length==0)
    {
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(mapView_.camera.target.latitude,mapView_.camera.target.longitude)
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
                            if(error)
                            {
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            
                            
                            else if([placemarks count]>0)
                            {
                                SVPlacemark *svp_Obj = [placemarks firstObject];
                                NSLog(@"Dictonary for google location = %@", svp_Obj);
                                
                                
                                searchBar.text = svp_Obj.formattedAddress;
                                
                                
                            }
                            
                        }];

    }
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    tbl_predictions.hidden = YES;
    [arr_locations removeAllObjects];
    [tbl_predictions reloadData];
    
    [searchBar resignFirstResponder];
    
    if(searchBar.text.length>0)
    {
        [kAppDelegate.objLoader show];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        
        //Third party class for forward-geo coding
        [SVGeocoder geocode:searchBar.text
                 completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                     
                     if(error)
                     {
                         [kAppDelegate.objLoader hide];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     else
                     {
                         
                         SVPlacemark *svp_Obj = [placemarks firstObject];
                         NSLog(@"Dictonary for google location = %@", svp_Obj);
                         
                         
                         GMSCameraPosition *pos = [GMSCameraPosition cameraWithLatitude:svp_Obj.coordinate.latitude
                                                                              longitude:svp_Obj.coordinate.longitude
                                                                                   zoom:13];
                         [mapView_ animateToCameraPosition:pos];
                         
                         
                         [kAppDelegate.objLoader hide];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }
                     
                 }];
        
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

@end
