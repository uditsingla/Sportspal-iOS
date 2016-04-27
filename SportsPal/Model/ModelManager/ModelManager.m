//
//  ModelManager.m
//  ApiTap
//
//  Created by Abhishek Singla on 13/03/16.
//  Copyright © 2016 ApiTap. All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager

static ModelManager *modelManager = nil;

+ (ModelManager *)modelManager {
    if (nil != modelManager) {
        return modelManager;
    }
    
    static dispatch_once_t pred; // Lock
    dispatch_once(&pred, ^{ // This code is called at most once per app
        modelManager = [[ModelManager alloc] init];
    });
    
    return modelManager;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Work your initialising magic here as you normally would
        self.loginManager=[[LoginManager alloc] init];
        self.requestManager=[[RequestManager alloc] init];
        self.profileManager=[[ProfileManager alloc] init];

    }
    return self;
}

@end
