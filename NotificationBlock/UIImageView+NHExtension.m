//
//  UIImageView+NHExtension.m
//  NotificationBlock
//
//  Created by mac on 2020/12/28.
//

#import "UIImageView+NHExtension.h"
#import "NHActionManager.h"

@implementation UIImageView (NHExtension)

- (instancetype)initWithFrame:(CGRect)frame; {
    if (self = [super initWithFrame:frame]) {
  
        [NHActionManager addObserver:self actionType:NHActionImageChange mainThread:YES block:^(UIImageView *  _Nonnull observer, NSDictionary * _Nonnull dictionary) {
            if (observer != [dictionary objectForKey:@"observer"]) {
                NSLog(@"----    方式一   =====收到其他地方头像变化了");
                observer.image = [dictionary objectForKey:@"image"];
            }
        }];
        
        [NHActionManager addObserver:self identifier:@"NHActionImageChange" mainThread:YES block:^(UIImageView *  _Nonnull observer, NSDictionary * _Nonnull dictionary) {
            if (![observer isEqual:[dictionary objectForKey:@"observer"]]) {
                NSLog(@"----方式二----收到其他地方头像变化了");
                observer.image = [dictionary objectForKey:@"image"];
            }
        }];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)loadImage:(UIImage *)image type:(NSInteger)type; {
    self.image = image;
    NSDictionary *dict = @{
                           @"observer" : self,
                           @"image" : image,
                           };
    if (type == 0) {
        [NHActionManager actionWithActionType:NHActionImageChange dictionary:dict];
    } else {
        [NHActionManager actionWithIdentifier:@"NHActionImageChange" dictionary:dict];
    }
}

- (void)dealloc {
    NSLog(@"头像View销毁了----%p",self);
}


@end
