#import "WSTabBar.h"

@interface WSTabBar ()
/** 当前选中的按钮 */
@property(nonatomic,strong) UIButton *selectedBtn;

@end

@implementation WSTabBar
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//
//    }
//
//    return self;
//}

- (void)setItems:(NSArray *)items
{
    _items = items; // 千万不要漏掉这一句啊！漏掉后，会导致_items为nil
    NSInteger index = 0;
    for (UITabBarItem *item in items) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:item.image forState:UIControlStateNormal];
        [btn setBackgroundImage:item.selectedImage forState:UIControlStateSelected];
        
        btn.tag = index;
        ++index;
        [btn addTarget:self action:@selector(btnDidOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = self.subviews[i];
        CGFloat width = self.frame.size.width / self.items.count;
        CGFloat height = self.frame.size.height;
        
        btn.frame = CGRectMake(i * width, 0, width, height);
        
    }
}
- (void)btnDidOnClick:(UIButton *)btn
{
    // 三部曲
    self.selectedBtn.selected = NO; // 上一个按钮取消选中
    btn.selected = YES; // 当前按钮设置选中
    self.selectedBtn = btn; // 当前按钮赋值给selectedBtn
    
    // 5种方法
    // 1.tabBarController属性
    /*
     self.tabBarController.selectedIndex = btn.tag;
     */
    
    // 2.通知
    /*
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     dict[@"selectedIndex"] = @(btn.tag);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelectedIndexNotification" object:self userInfo:dict];
     */
    
    // 3.KVO 控制器或者tabBar监听selectedBtn.tag的变化
    
    // 4.block
    /*
     if (self.selectedIndexBlock) {
     self.selectedIndexBlock(btn.tag);
     }
     */
    
    // 5.代理
    if ([self.delegate respondsToSelector:@selector(tabBar:withSelectedIndex:)]) {
        [self.delegate tabBar:self withSelectedIndex:btn.tag];
    }
}

- (void)dealloc
{
    
}

@end
