//
//  ViewController.m
//  TESTUI
//
//  Created by helinyu on 2024/10/21.
//

#import "ViewController.h"
#import <SwiftUI/SwiftUI.h>
#import "TESTUI-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 60);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onAction:(id)sender {
    [self navigateToSwiftUIView];
}

- (void)navigateToSwiftUIView {
    UIViewController *vc = [[XXViewController alloc] createTestViewController];
    [self.navigationController pushViewController:vc animated:YES];
//        [self presentViewController:[adapter make] animated:YES completion:nil]; // 跳转到 SwiftUI 视
//    TestViewController *vc = [TestViewController new];
//    MySwiftUIView *swiftUIView = [[MySwiftUIView alloc] init];
//    UIHostingController *hostingController = [[UIHostingController alloc] initWithRootView:swiftUIView];
//    
//    [self presentViewController:hostingController animated:YES completion:nil]; // 跳转到 SwiftUI 视图
}

@end
