//
//  XCDropMenu.m
//  HelloWorld
//
//  Created by XenonChau on 22/08/2017.
//  Copyright © 2017 Code1Bit Co.,Ltd. All rights reserved.
//

#import "XCDropMenu.h"

@interface XCDropMenu () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *originDataSource;
@property (copy, nonatomic) NSArray *originIcons;

@end

@implementation XCDropMenu

- (instancetype)initWithDataSource:(NSArray *)dataSource
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.dataSource = dataSource;
        [self initialValues];
        [self initialViews];
    }
    return self;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:
                     (CGRect){
                         self.frame.origin.x,
                         self.frame.origin.y + self.frame.size.height + 5,
                         self.frame.size.width,
                         0
                     }];
        _menuView.alpha = 0;
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 2;
        _menuView.layer.borderWidth = 0.5;
        _menuView.layer.borderColor = self.borderColor.CGColor;
        _menuView.backgroundColor = self.backgroundColor;
        [_menuView addSubview:self.tableView];
    }
    return _menuView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.layer.cornerRadius = 2;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.borderColor = self.borderColor.CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = self.borderColor;
        _tableView.alpha = 0;
        _tableView.rowHeight = self.itemHeight;
        _tableView.estimatedRowHeight = self.itemHeight;
        [_tableView registerClass:[DMCell class] forCellReuseIdentifier:NSStringFromClass([DMCell class])];
        
    }
    return _tableView;
}

- (void)initialValues {
    
    self.itemHeight = 50;
    self.numberOfShownItems = 4;
    self.hideMenuAfterTouch = YES;
    self.selectedCoin = self.selectedCoin ? : @"BTC";
    
}

- (void)initialViews {
    
    self.layer.cornerRadius = 2;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = 0.5;
    
    self.backgroundColor = [UIColor colorWithRed:28.f/255.f green:28.f/255.f blue:28.f/255.f alpha:1];
    self.borderColor = [UIColor colorWithRed:186.f/255.f green:186.f/255.f blue:186.f/255.f alpha:1];
    self.textColor = [UIColor whiteColor];
    
    [self addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.originDataSource) {
        // 可以用 init 传值。
        // 同时也要注意，init 传值后，远端更新数据源时，origin 也需要再赋值“一”次。
        self.originDataSource = self.dataSource.copy;
    }

    [self.superview addSubview:self.menuView];
    
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.selectedCoin]];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = self.selectedCoin;
    self.titleLabel.textColor = self.textColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
    
    self.indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"triangle"]];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.indicatorView];
    
    [self.superview addSubview:self.menuView];
    
}

- (void)setSelectedCoin:(NSString *)selectedCoin {
    _selectedCoin = selectedCoin;
    self.titleLabel.text = selectedCoin;
    if (self.icons && self.icons.count) {
        [self updateIconImage];
    } else {
        self.iconView.image = [UIImage imageNamed:self.selectedCoin];
    }
    
}

- (void)setIcons:(NSArray *)icons {
    _icons = icons;
    [self updateIconImage];
}

- (void)updateIconImage {
    NSInteger selectedIndex = [self selectedIndex];
    NSString *imageName = self.originIcons.count ? self.originIcons[selectedIndex] : self.icons[selectedIndex];
    self.iconView.image = [UIImage imageNamed:imageName];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self iconLayout];
    [self titleLayout];
    [self indicatorLayout];
}

- (void)updateDataSource:(NSArray *)newDataSource {
    self.originDataSource = newDataSource;
}

- (void)reloadDataSource {
    NSMutableArray *tempTitles = [self.originDataSource mutableCopy];
    [tempTitles removeObject:self.selectedCoin];
    self.dataSource = tempTitles.copy;
    
    if (self.icons && self.icons.count) {
        NSArray *temp = self.originIcons.count ? self.originIcons.copy : self.icons.copy; // 保存 origin
        NSMutableArray *tempIcons = [temp mutableCopy]; // 操作另一份拷贝
        [tempIcons removeObjectAtIndex:[self selectedIndex]];
        self.originIcons = temp.copy; // 恢复 origin
        self.icons = tempIcons.copy;
        [self updateIconImage];
    } else {
        self.iconView.image = [UIImage imageNamed:self.selectedCoin];
    }
    
}

- (void)controlAction:(UIControl *)control {
    
    self.selected = !self.selected;
    
    if (self.selected) {
        [self showMenuAnimated:YES];
    } else {
        [self hideMenuAnimated:YES];
    }
}

- (NSInteger)selectedIndex {
    __block NSInteger selectIndex = 0;
    [self.originDataSource enumerateObjectsUsingBlock:^(NSString *title,
                                                        NSUInteger idx,
                                                        BOOL *stop) {
        if ([title isEqualToString:self.selectedCoin]) {
            selectIndex = idx;
            *stop = YES;
        }
    }];
    return selectIndex;
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 外部传入 reuseIdentifier, Class？
    DMCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DMCell class]) forIndexPath:indexPath];
    NSString *iconName = self.dataSource[indexPath.row];
    if (self.icons && self.icons.count) {
        iconName = self.icons[indexPath.row];
    }
    NSDictionary *model = @{@"icon":iconName, @"title": self.dataSource[indexPath.row]};
    [cell updateCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *coinName = self.dataSource[indexPath.row];
    self.titleLabel.text = coinName;
    self.iconView.image = [UIImage imageNamed:coinName];
    self.selectedCoin = coinName;
    [self reloadDataSource];
    [UIView transitionWithView:self.tableView
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.tableView reloadData];
                    } completion:^ (BOOL complete) {
                        !_itemSelectCallback ? : _itemSelectCallback(indexPath.row, self.dataSource[indexPath.row]);
                        if (self.hideMenuAfterTouch) {
                            [self hideMenuOutside];
                        }
                    }];
}

#pragma mark - hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    CGPoint menuTouchPoint = CGPointMake(point.x,
                                         point.y - self.frame.size.height - 5);
    
    if ([self pointInside:point withEvent:event]) {
        return self;
    } else if ([self.menuView pointInside:menuTouchPoint withEvent:event]) {
        return [self.menuView hitTest:menuTouchPoint withEvent:event];
    } else {
        [self hideMenuOutside];
    }
    return nil;
}

#pragma mark - Menu Animation

- (void)showMenuAnimated:(BOOL)animate {
    [self reloadDataSource];
    
    if (!self.menuView.superview) {
        // 将menuView添加到父视图上。
        [self.superview addSubview:self.menuView];
        self.menuView.frame = (CGRect){
            self.frame.origin.x,
            self.frame.origin.y + self.frame.size.height + 5,
            self.frame.size.width,
            0
        };
    }
    // 防止未知的遮挡bug，将menuView提到最前面。
    [self.superview bringSubviewToFront:self.menuView];
    
    if (self.numberOfShownItems >= self.dataSource.count) {
        // 控制最大显示数量
        self.numberOfShownItems = self.dataSource.count;
        self.tableView.scrollEnabled = NO;
    } else {
        self.tableView.scrollEnabled = YES;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, M_PI);
    
    [self.tableView reloadData];
    
    [UIView animateWithDuration:animate ? 0.25f : 0.0f animations:^{
        self.menuView.alpha = 1;
        self.tableView.alpha = 1;
        self.menuView.frame = (CGRect){
                                         self.frame.origin.x,
                                         self.frame.origin.y + self.frame.size.height + 5,
                                         self.frame.size.width,
                                         self.itemHeight * self.numberOfShownItems
                                        };
        // 为了解决约束动画不好看的问题以及某些未知时刻会出现table.offsetY偏移-64问题。
        self.tableView.frame = (CGRect){
                                         0,
                                         0,
                                         self.frame.size.width,
                                         self.itemHeight * self.numberOfShownItems
                                       };
        
        self.indicatorView.layer.affineTransform = transform;
    }];
}

- (void)hideMenuAnimated:(BOOL)animate {
    if (self.numberOfShownItems >= self.dataSource.count) {
        self.numberOfShownItems = self.dataSource.count;
        self.tableView.scrollEnabled = NO;
    } else {
        self.tableView.scrollEnabled = YES;
    }
    [self.superview sendSubviewToBack:self.menuView];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, 0);
    
    [UIView animateWithDuration:animate ? 0.25f : 0.0f animations:^{
        self.menuView.alpha = 0;
        self.tableView.alpha = 0;
        
        [self.tableView reloadData];
        self.menuView.frame = (CGRect){
                                         self.frame.origin.x,
                                         self.frame.origin.y + self.frame.size.height + 5,
                                         self.frame.size.width,
                                         0
                                        };
        self.tableView.frame = (CGRect){
                                         0,
                                         0,
                                         self.frame.size.width,
                                         0
                                       };
        
        self.indicatorView.layer.affineTransform = transform;
    }];
}

- (void)hideMenuOutside {
    self.selected = NO;
    [self hideMenuAnimated:YES];
}

/*
- (void)tableLayout {
    // 如果tableview动画太丑，将这个方法注销。并解锁show、hide里面的frame布局。
    NSLayoutConstraint *table_leading = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.menuView
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1
                                                                     constant:0];
    NSLayoutConstraint *table_trailing = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.menuView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1
                                                                      constant:0];
    NSLayoutConstraint *table_top = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.menuView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:0];
    NSLayoutConstraint *table_bottom = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.menuView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:0];
    [NSLayoutConstraint activateConstraints:@[table_leading, table_trailing, table_top, table_bottom]];
}
 */

- (void)iconLayout {
    NSLayoutConstraint *iconView_centerX = [NSLayoutConstraint
                                            constraintWithItem:self.iconView
                                            attribute:NSLayoutAttributeCenterX
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeLeading
                                            multiplier:1
                                            constant:25];
    NSLayoutConstraint *iconView_centerY = [NSLayoutConstraint
                                            constraintWithItem:self.iconView
                                            attribute:NSLayoutAttributeCenterY
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeCenterY
                                            multiplier:1
                                            constant:0];
    [NSLayoutConstraint activateConstraints:@[iconView_centerX, iconView_centerY]];
}

- (void)titleLayout {
    NSLayoutConstraint *title_centerX = [NSLayoutConstraint
                                         constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeCenterX
                                         multiplier:1
                                         constant:0];
    NSLayoutConstraint *title_centerY = [NSLayoutConstraint
                                         constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1
                                         constant:0];
    [NSLayoutConstraint activateConstraints:@[title_centerX, title_centerY]];
}

- (void)indicatorLayout {
    NSLayoutConstraint *indicator_trailing = [NSLayoutConstraint
                                              constraintWithItem:self.indicatorView
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeTrailing
                                              multiplier:1
                                              constant:-5.5];
    NSLayoutConstraint *indicator_width    = [NSLayoutConstraint
                                              constraintWithItem:self.indicatorView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1
                                              constant:18];
    NSLayoutConstraint *indicator_height   = [NSLayoutConstraint
                                              constraintWithItem:self.indicatorView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1
                                              constant:15];
    NSLayoutConstraint *indicator_centerY  = [NSLayoutConstraint
                                              constraintWithItem:self.indicatorView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeCenterY
                                              multiplier:1
                                              constant:0];
    [NSLayoutConstraint activateConstraints:@[indicator_trailing, indicator_centerY, indicator_width, indicator_height]];
}

@end

@interface DMCell ()

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation DMCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:28.f/255.f green:28.f/255.f blue:28.f/255.f alpha:1];

        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.iconImage];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.titleLabel];
        
        [self iconLayout];
        [self titleLayout];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateCell:(id)model {
    self.iconImage.image = [UIImage imageNamed:model[@"icon"]];
    self.titleLabel.text = model[@"title"];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? [UIColor darkGrayColor] : [UIColor colorWithRed:28.f/255.f green:28.f/255.f blue:28.f/255.f alpha:1];;
}

- (void)iconLayout {
    NSLayoutConstraint *icon_centerX = [NSLayoutConstraint
                                        constraintWithItem:self.iconImage
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                        attribute:NSLayoutAttributeLeading
                                        multiplier:1
                                        constant:25];
    NSLayoutConstraint *icon_top     = [NSLayoutConstraint
                                        constraintWithItem:self.iconImage
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                        attribute:NSLayoutAttributeTop
                                        multiplier:1
                                        constant:10];
    NSLayoutConstraint *icon_bottom  = [NSLayoutConstraint
                                        constraintWithItem:self.iconImage
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                        constant:-10];
    NSLayoutConstraint *icon_aspect_ratio  = [NSLayoutConstraint
                                              constraintWithItem:self.iconImage
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.iconImage
                                              attribute:NSLayoutAttributeHeight
                                              multiplier:1
                                              constant:0];
    
    [NSLayoutConstraint activateConstraints:@[icon_centerX, icon_top, icon_bottom, icon_aspect_ratio]];
}

- (void)titleLayout {
    NSLayoutConstraint *title_centerX = [NSLayoutConstraint
                                         constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeCenterX
                                         multiplier:1
                                         constant:0];
    NSLayoutConstraint *title_centerY = [NSLayoutConstraint
                                         constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1
                                         constant:0];
    NSLayoutConstraint *title_width = [NSLayoutConstraint
                                         constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                         constant:0];
    [NSLayoutConstraint activateConstraints:@[title_centerX, title_centerY, title_width]];
}

@end
