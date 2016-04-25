//
//  AppDelegate.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/20/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"DataStore"];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [self customizeAppearance];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (void)customizeAppearance {
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor] };
    
    UIColor *tintColor = [UIColor globalTintColor];
    [UINavigationBar appearance].tintColor = tintColor;
    [UISearchBar appearance].tintColor = tintColor;
    [UIActivityIndicatorView appearance].tintColor = tintColor;
}

@end
