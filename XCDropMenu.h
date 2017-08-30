//
//  XCDropMenu.h
//  HelloWorld
//
//  Created by XenonChau on 22/08/2017.
//  Copyright © 2017 Code1Bit Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XCDropMenuType) {
    // 可选择状态
    XCDropMenuTypeDefault = 0,
    // 只有 COC 状态
    XCDropMenuTypeCocToken = 999,
    
};

@interface XCDropMenu : UIControl

/** 菜单下拉样式 */
@property (assign, nonatomic) XCDropMenuType menuType;

/** Button 的左侧图标 */
@property (strong, nonatomic) UIImageView *iconView;
/** Button 的文本 */
@property (strong, nonatomic) UILabel *titleLabel;
/** Button 的右侧指示器 */
@property (strong, nonatomic) UIImageView *indicatorView;
/** Button 的边框颜色 */
@property (copy, nonatomic) UIColor *borderColor;
/** Button 的文本颜色 */
@property (copy, nonatomic) UIColor *textColor;
/** Button 的默认选中文本 */
@property (copy, nonatomic) NSString *selectedCoin; // Default: BTC

/** 点击 Item 后是否隐藏菜单 */
@property (assign, nonatomic) BOOL hideMenuAfterTouch;

/** 每个 Item 的高度 Default: 50 */
@property (assign, nonatomic) CGFloat itemHeight;

/** 最多显示的 Item 数量, Default: 4 */
@property (assign, nonatomic) NSInteger numberOfShownItems;

/** Item 的点击回调*/
@property (copy, nonatomic) void (^itemSelectCallback)(NSInteger index, NSString *coinName);
/** Item 是否可以点击 */
//@property (assign, nonatomic) BOOL canSelect;

// 文字数据源必须要有
- (instancetype)initWithDataSource:(NSArray *)dataSource;
/** 数据源 */
@property (copy, nonatomic) NSArray *dataSource;
/** 数据源 */
@property (copy, nonatomic) NSArray *icons;
/** 更新数据源 */
- (void)updateDataSource:(NSArray *)newDataSource;
/** 重载数据源 */
- (void)reloadDataSource;
/** 关闭菜单 */
- (void)hideMenuOutside;

@end


@interface DMCell : UITableViewCell

- (void)updateCell:(id)model;

@end
