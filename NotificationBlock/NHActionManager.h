//
//  NHActionManager.h
//  NotificationBlock
//
//  Created by onhione on 2020/12/28.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NHActionType) {
    //颜色变化
    NHActionColorChange,
    //文字变化
    NHActionTextChange,
    //图片变化
    NHActionImageChange,
};

NS_ASSUME_NONNULL_BEGIN

@interface NHActionManager : NSObject

/*
    所有响应block生命周期和观察者对象生命周期一样，一个对象多次添加同一类型或者同一标识符的观察者，只会添加最后一次，响应的block回掉会随着观察者对象销毁自动销毁，建议使用枚举管理所有标识符
 */

+ (instancetype)sharedInstance;

/**
 根据类型添加观察者
 
 @param observer 观察者
 @param actionType 响应类型
 @param block 数据回掉
 */
+ (void)addObserver:(id)observer actionType:(NHActionType)actionType mainThread:(BOOL)mainThread block:(void(^)(id observer, NSDictionary *dictionary))block;

/**
 根据类型调用
 
 @param dictionary 数据
 @param actionType 响应类型
 */
+ (void)actionWithActionType:(NHActionType)actionType dictionary:(NSDictionary *)dictionary;


//------------------------------------字符串作为唯一标识符，内部已经处理，不会和上面枚举方式冲突-------------------------------------


/**
 根据标识符添加观察者

 @param observer 观察者
 @param identifier 标识
 @param mainThread 是否在主线程回掉
 @param block 数据回掉
 */
+ (void)addObserver:(id)observer identifier:(NSString *)identifier mainThread:(BOOL)mainThread block:(void(^)(id observer, NSDictionary *dictionary))block;

/**
 根据标识符调用

 @param dictionary 数据
 @param identifier 标识符
 */
+ (void)actionWithIdentifier:(NSString *)identifier dictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
