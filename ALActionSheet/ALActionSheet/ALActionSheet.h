//
//  ALActionSheet.h
//  ALActionSheet
//
//  Created by Alan on 2018/1/15.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALActionSheet : UIView


+ (instancetype)actionSheet;

+ (void)showActionSheetWithOptionArray:(NSArray *)optionArray cancleStr:(NSString *)cancleStr click:(void(^)(NSInteger index))index;

+ (void)dismiss;

@end
