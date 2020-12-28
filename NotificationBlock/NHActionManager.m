//
//  NHActionManager.m
//  NotificationBlock
//
//  Created by onhione on 2020/12/28.
//

#import "NHActionManager.h"
#import <objc/message.h>

@interface NHActionManager ()

@property (nonatomic, strong) NSMapTable *observerMapTable;
@property (nonatomic, strong) NSMapTable *blockKeyMapTable;
@property (nonatomic, strong) NSMapTable *mainThreadKeyMapTable;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation NHActionManager

static NHActionManager *sharedInstanced = nil;

+ (instancetype)sharedInstance; {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanced = [[NHActionManager alloc] init];
        
        //弱引用value，强引用key
        sharedInstanced.observerMapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
        sharedInstanced.blockKeyMapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
        sharedInstanced.mainThreadKeyMapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
        
        //信号
        sharedInstanced.semaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(sharedInstanced.semaphore);
    });
    return sharedInstanced;
}

+ (void)addObserver:(id)observer actionType:(NHActionType)actionType mainThread:(BOOL)mainThread block:(void(^)(id observer, NSDictionary *dictionary))block {
    //增加信号保证线程安全
    dispatch_semaphore_wait([NHActionManager sharedInstance].semaphore, DISPATCH_TIME_FOREVER);
    //内存地址+key，使用内存地址保证一个对象只监听一次，key保证是同一类型
    NSString *key = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%p",observer], [[self keyWithActionType:actionType] stringByAppendingString:@"-1"]];
    NSString *actionBlock = [key stringByAppendingString:@"-CLActionBlock-1"];
    NSString *actionMainThread = [key stringByAppendingString:@"-CLActionMainThread-1"];
    [[NHActionManager sharedInstance].observerMapTable setObject:observer forKey:key];
    [[NHActionManager sharedInstance].blockKeyMapTable setObject:actionBlock forKey:key];
    [[NHActionManager sharedInstance].mainThreadKeyMapTable setObject:actionMainThread forKey:key];
    //动态设置block
    objc_setAssociatedObject(observer, CFBridgingRetain(actionBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //动态设置是否主线程
    objc_setAssociatedObject(observer, CFBridgingRetain(actionMainThread), [NSNumber numberWithBool:mainThread], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_semaphore_signal([NHActionManager sharedInstance].semaphore);
}

+ (void)actionWithActionType:(NHActionType)actionType dictionary:(NSDictionary *)dictionary; {
    dispatch_semaphore_wait([NHActionManager sharedInstance].semaphore, DISPATCH_TIME_FOREVER);
    //key数组
    NSArray<NSString *> *keyArray = [[[NHActionManager sharedInstance].observerMapTable keyEnumerator] allObjects];
    //匹配出对应key
    NSString *identifier = [[self keyWithActionType:actionType] stringByAppendingString:@"-1"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@",identifier];
    NSArray<NSString *> *array = [keyArray filteredArrayUsingPredicate:predicate];
    //遍历查找所有key
    for (NSString *key in array) {
        NSString *actionBlock = [[NHActionManager sharedInstance].blockKeyMapTable objectForKey:key];
        NSString *actionMainThread = [[NHActionManager sharedInstance].mainThreadKeyMapTable objectForKey:key];
        //找出对应类型的观察者
        id observer = [[NHActionManager sharedInstance].observerMapTable objectForKey:key];
        //取出block
        void(^block)(id observer, NSDictionary *dictionary) = objc_getAssociatedObject(observer, CFBridgingRetain(actionBlock));
        BOOL mainThread = [(NSNumber *)objc_getAssociatedObject(observer, CFBridgingRetain(actionMainThread)) boolValue];
        //block存在并且是对应方法添加，调用block
        if (block) {
            if (mainThread) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(observer, dictionary);
                });
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    block(observer, dictionary);
                });
            }
        }
    }
    dispatch_semaphore_signal([NHActionManager sharedInstance].semaphore);
}

+ (NSString *)keyWithActionType:(NHActionType)actionType {
    NSString *key;
    switch (actionType) {
        case NHActionTextChange:
            key = @"NHActionTextChange";
            break;
        case NHActionColorChange:
            key = @"NHActionColorChange";
            break;
        case NHActionImageChange:
            key = @"NHActionImageChange";
            break;
        default:
            break;
    }
    return key;
}

+ (void)addObserver:(id)observer identifier:(NSString *)identifier mainThread:(BOOL)mainThread block:(void(^)(id observer, NSDictionary *dictionary))block {
    //增加信号保证线程安全
    dispatch_semaphore_wait([NHActionManager sharedInstance].semaphore, DISPATCH_TIME_FOREVER);
    //内存地址+key，使用内存地址保证一个对象只监听一次，key保证是同一类型
    NSString *key = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%p",observer], [identifier stringByAppendingString:@"-0"]];
    NSString *actionBlock = [key stringByAppendingString:@"-CLActionBlock-0"];
    NSString *actionMainThread = [key stringByAppendingString:@"-CLActionMainThread-0"];
    [[NHActionManager sharedInstance].observerMapTable setObject:observer forKey:key];
    [[NHActionManager sharedInstance].blockKeyMapTable setObject:actionBlock forKey:key];
    [[NHActionManager sharedInstance].mainThreadKeyMapTable setObject:actionMainThread forKey:key];
    //动态设置block
    objc_setAssociatedObject(observer, CFBridgingRetain(actionBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //动态设置是否主线程
    objc_setAssociatedObject(observer, CFBridgingRetain(actionMainThread), [NSNumber numberWithBool:mainThread], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_semaphore_signal([NHActionManager sharedInstance].semaphore);
}

+ (void)actionWithIdentifier:(NSString *)identifier dictionary:(NSDictionary *)dictionary; {
    dispatch_semaphore_wait([NHActionManager sharedInstance].semaphore, DISPATCH_TIME_FOREVER);
    //key数组
    NSArray<NSString *> *keyArray = [[[NHActionManager sharedInstance].observerMapTable keyEnumerator] allObjects];
    //匹配出对应key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@",[identifier stringByAppendingString:@"-0"]];
    NSArray<NSString *> *array = [keyArray filteredArrayUsingPredicate:predicate];
    //遍历查找所有key
    for (NSString *key in array) {
        NSString *actionBlock = [[NHActionManager sharedInstance].blockKeyMapTable objectForKey:key];
        NSString *actionMainThread = [[NHActionManager sharedInstance].mainThreadKeyMapTable objectForKey:key];
        //找出对应类型的观察者
        id observer = [[NHActionManager sharedInstance].observerMapTable objectForKey:key];
        //取出block
        void(^block)(id observer, NSDictionary *dictionary) = objc_getAssociatedObject(observer, CFBridgingRetain(actionBlock));
        BOOL mainThread = [(NSNumber *)objc_getAssociatedObject(observer, CFBridgingRetain(actionMainThread)) boolValue];
        //block存在并且是对应方法添加，调用block
        if (block) {
            if (mainThread) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(observer, dictionary);
                });
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    block(observer, dictionary);
                });
            }
        }
    }
    dispatch_semaphore_signal([NHActionManager sharedInstance].semaphore);
}

@end
