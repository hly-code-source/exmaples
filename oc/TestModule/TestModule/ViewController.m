//
//  ViewController.m
//  TestModule
//
//  Created by helinyu on 2024/10/18.
//

#import "ViewController.h"

@import Person;


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p = [Person new];
    [p printName];
    
    self.view.backgroundColor = [UIColor redColor];
}


@end
