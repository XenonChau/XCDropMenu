//
//  ViewController.m
//  XCDropMenuDemo
//
//  Created by XenonChau on 30/08/2017.
//  Copyright © 2017 Code1Bit Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "XCDropMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *firstTitles = @[@"BTC", @"COC", @"ETH", @"ETC"];
    XCDropMenu *topMenu = [[XCDropMenu alloc] initWithDataSource:firstTitles];
    topMenu.selectedCoin = @"ETH";
    topMenu.frame = (CGRect){20, 230, 180, 50};
    [self.view addSubview:topMenu];
    
    /* This can use masonry as you wish.
    [topMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(120);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(165);
    }];
     */
    
    NSArray *secondTitles = @[@"BTM", @"QTUM", @"ZEC"];
    XCDropMenu *secondMenu = [[XCDropMenu alloc] initWithDataSource:secondTitles];
    secondMenu.icons = @[@"BTM_icon", @"QTUM_icon", @"ZEC_icon"];
    secondMenu.selectedCoin = @"QTUM";
    secondMenu.frame = (CGRect){20, 300, 180, 50};
    secondMenu.borderColor = [UIColor colorWithRed:186.f/255.f green:186.f/255.f blue:186.f/255.f alpha:1];
    [self.view addSubview:secondMenu];
    
    /* This can use masonry as you wish.
    [secondMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topMenu.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(165);
    }];
     */
    
    topMenu.itemSelectCallback = ^(NSInteger index, NSString *coinName) {
        NSLog(@"%@", firstTitles[index]);
    };
    
    secondMenu.itemSelectCallback = ^(NSInteger index, NSString *coinName) {
        NSLog(@"%@", secondTitles[index]);
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
