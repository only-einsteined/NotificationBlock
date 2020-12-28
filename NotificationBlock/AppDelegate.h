//
//  AppDelegate.h
//  NotificationBlock
//
//  Created by onhione on 2020/12/28.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@property (nonatomic, strong) UIWindow *window;

@end

