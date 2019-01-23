//
//  AppDelegate.h
//  PullToRefresh
//
//  Created by KTW on 11/01/2019.
//  Copyright © 2019 KTW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

