//
//  InfoViewController.m
//  NotificationBlock
//
//  Created by onhione on 2020/12/28.
//

#import "InfoViewController.h"
#import "NHActionManager.h"
#import <Masonry/Masonry.h>
#import "UIImageView+NHExtension.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface InfoViewController ()

@property (nonatomic, strong) UIImageView *headerView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor blackColor];
    _headerView = [[UIImageView alloc] init];
    _headerView.layer.cornerRadius = 100 * 0.5;
    _headerView.clipsToBounds = YES;
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.mas_equalTo(self.view);
    }];

    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"方式一变色" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 150));
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(_headerView.mas_top).mas_offset(-40);
    }];
    
    UIButton *button1 = [[UIButton alloc] init];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"方式二变色" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(changeColor1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 150));
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(_headerView.mas_top).mas_offset(-40);
    }];
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"方式一切换图片" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 150));
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(_headerView.mas_bottom).mas_offset(40);
    }];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(300, 300, 150, 150)];
    button3.backgroundColor = [UIColor orangeColor];
    [button3 setTitle:@"方式二切换图片" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(changeImage2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 150));
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(_headerView.mas_bottom).mas_offset(40);
    }];

    [NHActionManager addObserver:self actionType:NHActionColorChange mainThread:YES block:^(InfoViewController * _Nonnull observer, NSDictionary * _Nonnull dictionary) {
        observer.view.backgroundColor = [dictionary objectForKey:@"color"];
        NSLog(@"InfoViewController收到颜色变化,方式一");
    }];
    
   
    [NHActionManager addObserver:self identifier:@"NHActionColorChange" mainThread:YES block:^(InfoViewController * _Nonnull observer, NSDictionary * _Nonnull dictionary) {
        observer.view.backgroundColor = [dictionary objectForKey:@"color"];
        NSLog(@"InfoViewController收到颜色变化,方式二");
    }];
    
}

- (void)changeColor {
    NSDictionary *dict = @{
                           @"color" : randomColor,
                           };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NHActionManager actionWithActionType:NHActionColorChange dictionary:dict];
    });
}

- (void)changeColor1 {
    NSDictionary *dict = @{
                           @"color" : randomColor,
                           };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NHActionManager actionWithIdentifier:@"NHActionColorChange" dictionary:dict];
    });

}

- (void)changeImage {
    [_headerView loadImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",[self randomNumber:1 to:8]]] type:0];
}

- (void)changeImage2 {
    [_headerView loadImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",[self randomNumber:1 to:8]]] type:1];
}

- (int)randomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
