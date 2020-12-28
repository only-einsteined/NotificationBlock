//
//  DetailViewController.m
//  NotificationBlock
//
//  Created by onhione on 2020/12/28.
//

#import "DetailViewController.h"
#import "NHActionManager.h"
#import <Masonry/Masonry.h>
#import "InfoViewController.h"
#import "UIImageView+NHExtension.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"action" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.layer.cornerRadius = 100 * 0.5;
    headerView.clipsToBounds = YES;
    [self.view addSubview:headerView];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(headerView.mas_bottom).mas_offset(90);
    }];

    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).mas_offset(100);
    }];

    [NHActionManager addObserver:self actionType:NHActionColorChange mainThread:YES block:^(DetailViewController *  _Nonnull observer, NSDictionary * _Nonnull dictionary) {
        observer.view.backgroundColor = [dictionary objectForKey:@"color"];
        NSLog(@"AViewController收到颜色变化,方式一");
    }];
    
    [NHActionManager addObserver:self identifier:@"NHActionColorChange" mainThread:YES block:^(DetailViewController *  _Nonnull observer, NSDictionary * _Nonnull dictionary) {
        observer.view.backgroundColor = [dictionary objectForKey:@"color"];
        NSLog(@"AViewController收到颜色变化,方式二");
    }];
}

- (void)actionEvent {
    InfoViewController *infoViewController = [[InfoViewController alloc] init];
    [self.navigationController pushViewController:infoViewController animated:YES];
}

- (void)dealloc {
    NSLog(@"--------->>>>DetailViewController销毁了");
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
