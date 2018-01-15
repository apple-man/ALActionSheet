//
//  ViewController.m
//  ALActionSheet
//
//  Created by Alan on 2018/1/15.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import "ViewController.h"
#import "ALActionSheet.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation ViewController

- (IBAction)actionBtnClicked:(UIButton *)sender {
    
    //[self.view addSubview:[ALActionSheet actionSheet]];
    NSArray *optionArray = @[
                        @"哈哈",
                        @"呵呵",
                        @"嘿嘿"
                        ];
    [ALActionSheet showActionSheetWithOptionArray:optionArray cancleStr:@"取消" click:^(NSInteger index) {
        if (index == 1) {
            [ALActionSheet dismiss];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
