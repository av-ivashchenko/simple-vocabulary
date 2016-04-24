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
    
    NSLog(@"%@", [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0]);
    
    [self customizeAppearance];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (void)customizeAppearance {
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIColor *tintColor = [UIColor colorWithRed:255/255.0 green:238/255.0 blue:136/255.0 alpha:1.0];
    
    [UITableView appearance].tintColor = tintColor;
    [UINavigationBar appearance].tintColor = tintColor;
    [UISearchBar appearance].tintColor = tintColor;
    [UITableViewCell appearance].tintColor = tintColor;
    [UIActivityIndicatorView appearance].tintColor = tintColor;
}

@end
