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

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property(nonatomic,strong) MFSideMenuContainerViewController *container;
@property(nonatomic,strong) LabeledActivityIndicatorView *objLoader;
//-(BOOL)checkInternetConnectivity;

@property(nonatomic,strong) CLLocationManager *location_Manager;
@property(nonatomic,strong) CLLocation *myLocation;

@end

