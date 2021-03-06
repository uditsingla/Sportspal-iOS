//
//  AppDelegate.h
//  SportsPal
//
//  Created by Abhishek Singla on 09/03/16.
//  Copyright © 2016 SportsPal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    UIView *inAppNotificationView;
    BOOL isAlertAnimating;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (UIAlertController*)showAlert:(NSString*)string;

@property(nonatomic,strong) MFSideMenuContainerViewController *container;
@property(nonatomic,strong) LabeledActivityIndicatorView *objLoader;
//-(BOOL)checkInternetConnectivity;

@property(nonatomic,strong) CLLocationManager *location_Manager;
@property(nonatomic,strong) CLLocation *myLocation;
@property(nonatomic,strong) CLLocation *tempLocation;

@property (strong, nonatomic) Reachability *internetReachable;
@property (assign, nonatomic) BOOL isInternetReachable;



@end

