

#import "WSTabBarController.h"
#import "WSTabBar.h"
#import "OneChildViwController.h"
#import "TwoChildViwController.h"
#import "ThreeChildViwController.h"
#import "FourChildViwController.h"
#import "FiveChildViwController.h"

@interface WSTabBarController ()<WSTabBarDelegate>
@property(nonatomic,strong) NSMutableArray *items;
@property(nonatomic,strong) WSTabBar *WSTabBar;

@end

@implementation WSTabBarController

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVC];
    [self setupTabBar];
    
    // 2.注册监听通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedIndex:) name:@"changeSelectedIndexNotification" object:nil];
    
    //    // 3.KVO
    //    [self addObserver:self forKeyPath:@"WSTabBar.selectedBtn.tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
}

- (void)changeSelectedIndex:(NSNotification *)noti
{
    self.selectedIndex = [noti.userInfo[@"selectedIndex"] integerValue];
}

- (void)dealloc
{
    // 移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除KVO监听
    [self removeObserver:self forKeyPath:@"WSTabBar.selectedBtn.tag"];
}
- (void)setupChildVC
{
    OneChildViwController *oneVC = [[OneChildViwController alloc] init];
    TwoChildViwController *twoVC = [[TwoChildViwController alloc] init];
    ThreeChildViwController *threeVC = [[ThreeChildViwController alloc] init];
    FourChildViwController *fourVC = [[FourChildViwController alloc] init];
    FiveChildViwController *fiveVC = [[FiveChildViwController alloc] init];
    
    [self setupChildVC:oneVC image:@"TabBar_Arena" selectedImage:@"TabBar_Arena_selected" title:@"竞技场"];
    [self setupChildVC:twoVC image:@"TabBar_Discovery" selectedImage:@"TabBar_Discovery_selected" title:@"发现"];
    [self setupChildVC:threeVC image:@"TabBar_History" selectedImage:@"TabBar_History_selected" title:@"开奖信息"];
    [self setupChildVC:fourVC image:@"TabBar_LotteryHall" selectedImage:@"TabBar_LotteryHall_selected" title:@"购彩大厅"];
    [self setupChildVC:fiveVC image:@"TabBar_MyLottery" selectedImage:@"TabBar_MyLottery_selected" title:@"我的彩票"];
    
}

- (void)setupChildVC:(UIViewController *)childVC image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    childVC.tabBarItem.title = title;
    [self.items addObject:childVC.tabBarItem];
    
    [self addChildViewController:nav];
}

- (void)setupTabBar
{
    WSTabBar *tabBar = [[WSTabBar alloc] init];
    tabBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49);
    // iphone 4、5、6 tabBar高度为49
    
    // iPhone 4、5、6 UINavigationBar高度为44
    // iphone 4、5、6 UINavigationBarBackGround高度为64 所以会有状态栏被导航栏同化的现象
    
    tabBar.items = self.items; // 不能 tabBar.items = self.tabBar.items;
    
//    tabBar.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tabBar];
    // 1.WSTabBar的tabBarController属性
    //     tabBar.tabBarController = self;
    
    // 3.KVO(tabBar监听)
    //    [tabBar addObserver:self forKeyPath:@"selectedBtn.tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // 3.KVO(让控制器监听)
    //    self.WSTabBar = tabBar;
    //    [self addObserver:self forKeyPath:@"WSTabBar.selectedBtn.tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // 4.block方式
    //    tabBar.selectedIndexBlock = ^(NSInteger selectedIndex){
    //        self.selectedIndex = selectedIndex;
    //    };
    
    // 5.代理
    tabBar.delegate = self;
    
}

// KVO监听到键值变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSInteger new = [change[NSKeyValueChangeNewKey] integerValue];
    self.selectedIndex = new;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *subView in self.tabBar.subviews) {
        if (![subView isKindOfClass:[WSTabBar class]]) {
            // 移除原生tabBar上的item
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - WSTabBarDelegate
- (void)tabBar:(WSTabBar *)tabBar withSelectedIndex:(NSInteger)selectedIndex
{
    self.selectedIndex = selectedIndex;
}
@end