#import <UIKit/UIKit.h>
@class WSTabBar;

@protocol WSTabBarDelegate <NSObject>
/** 控制器遵守该协议后，用于传递tabBar当前选中的按钮的索引给控制器 */
- (void)tabBar:(WSTabBar *)tabBar withSelectedIndex:(NSInteger)selectedIndex;

@end

@interface WSTabBar : UIView
/** tabBar的item数组 */
@property (nonatomic,strong) NSArray *items;
/** tabBar所属的tabBarController */
@property (nonatomic,strong) UITabBarController *tabBarController;

/** block */
@property (nonatomic,strong) void(^selectedIndexBlock)(NSInteger);

// 代理
@property (nonatomic,weak) id<WSTabBarDelegate> delegate;

@end