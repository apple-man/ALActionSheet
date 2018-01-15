//
//  ALActionSheet.m
//  ALActionSheet
//
//  Created by Alan on 2018/1/15.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import "ALActionSheet.h"

#define ALScreenWidth [UIScreen mainScreen].bounds.size.width;
#define ALScreenHeight [UIScreen mainScreen].bounds.size.height;

@interface ALActionSheetCell : UITableViewCell
@property (nonatomic, copy) NSString *optionText;
@end
@interface ALActionSheetCell()
@property (nonatomic, strong) UILabel *optionLabel;
@property (nonatomic, strong) UIView *divideLine;
@end

@implementation ALActionSheetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupALActionSheetCell];
    }
    return self;
}
- (void)setupALActionSheetCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.optionLabel = [UILabel new];
    self.optionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.optionLabel];
    self.divideLine = [UIView new];
    self.divideLine.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.divideLine];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.divideLine.frame = CGRectMake(0, self.contentView.bounds.size.height-0.5, self.contentView.bounds.size.width, 0.5);
    //self.optionLabel.center = CGPointMake(self.contentView.bounds.size.width/2.0, self.contentView.bounds.size.height/2.0);
    self.optionLabel.frame = self.contentView.bounds;
}
- (void)setOptionText:(NSString *)optionText{
    _optionText = optionText;
    self.optionLabel.text = optionText;
}
@end



@interface ALActionSheet()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightCons;

@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIView *cancleView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *cancleStr;
@property (nonatomic, strong) void(^index)(NSInteger index);

@end

static ALActionSheet *_actionSheet;

@implementation ALActionSheet


+ (instancetype)actionSheet{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (void)showActionSheetWithOptionArray:(NSArray *)optionArray cancleStr:(NSString *)cancleStr click:(void(^)(NSInteger index))index{
    if(_actionSheet)return;
    // 这个实例 actionSheet 实现所有的实例方法
    ALActionSheet *actionSheet = [self actionSheet];
    _actionSheet = actionSheet; // 为了在外面调用dismiss
    actionSheet.dataSource = optionArray;
    actionSheet.cancleStr = cancleStr;
    actionSheet.index = index;
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
}

+ (void)dismiss{
    [_actionSheet removeFromSuperview];
    _actionSheet = nil;
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
    NSLog(@"awakeFromNib");
}

-(void)setCancleStr:(NSString *)cancleStr{
    _cancleStr = cancleStr;
    [self.cancleBtn setTitle:cancleStr forState:UIControlStateNormal];
    [self.cancleBtn setTitle:cancleStr forState:UIControlStateHighlighted];
}

-(void)setDataSource:(NSArray *)dataSource{
     NSLog(@"dataSource");
    _dataSource = dataSource;
    
    self.contentViewHeightCons.constant = dataSource.count * 60 + 90;
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentViewHeightCons.constant);
    //self.contentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, self.contentViewHeightCons.constant);
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform =  CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (void)setupUI{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.optionView.layer.cornerRadius = 10;
    self.optionView.layer.masksToBounds = YES;
    self.cancleView.layer.cornerRadius = 10;
    self.cancleView.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    CGAffineTransform t = self.contentView.transform;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform = CGAffineTransformTranslate(t, 0, self.contentViewHeightCons.constant);
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const cellID = @"ALActionSheetCell";
    ALActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ALActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.optionText = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    _actionSheet = nil;
//    [self removeFromSuperview];
    self.index(indexPath.row);
}

- (IBAction)cancleBtnAction:(UIButton *)sender {
    self.index(3);
}

- (void)dealloc{
    
}

@end
