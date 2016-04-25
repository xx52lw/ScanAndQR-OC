//
//  LWScanQRViewController.m
//  OCScanAndQR
//
//  Created by 张星星 on 16/4/23.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWScanQRViewController.h"
#import "LWScanQRCollectionViewCell.h"
#import "LWScanQRModel.h"
#import "LWTools.h"


static NSString *ID = @"LWScanQRCollectionViewCell";
static CGFloat  Margin = 10.0f;

// ====================================================================================================================================================================
#pragma mark - 扫描和二维码控制器私有方法和属性
@interface LWScanQRViewController ()
/** 界面布局 */
@property (nonatomic,strong) UICollectionView    *     collectionView;
/** 列表模型数组 */
@property (nonatomic,strong) NSArray    *     listArray;

@end

// ====================================================================================================================================================================
#pragma mark - 扫描和二维码控制器tools方法
@interface LWScanQRViewController (tools)

- (void)initUI;     // 初始化界面
- (void)qqStyle;    // QQ样式
- (void)zhifuStyle; // 支付宝扫码
- (void)wechatStyle;// 微信扫码
- (void)innerStyle; // 无边框
- (void)onStyle;    // 网格动画
- (void)colorStyle; // 自定义颜色
- (void)outStyle;   // 可识别框外
- (void)changeStyle;// 改变尺寸
- (void)notStyle;   // 条形码效果
- (void)qrStyle;    // 二维码条形码
- (void)photoStyle; // 相册
- (BOOL)checkCameraAuthority; // 检查相机是否可用

@end
// ====================================================================================================================================================================
#pragma mark - 扫描和二维码控制器UICollectionViewDelegateDataSource方法
@interface LWScanQRViewController (UICollectionViewDelegateDataSource)<UICollectionViewDelegate,UICollectionViewDataSource>

@end

// ====================================================================================================================================================================
#pragma mark - 扫描和二维码控制器
@implementation LWScanQRViewController

#pragma mark 懒加载界面布局
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0.0f;
        layout.minimumLineSpacing = Margin;
        layout.sectionInset = UIEdgeInsetsMake(Margin, Margin, Margin, Margin);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LWScanQRCollectionViewCell class] forCellWithReuseIdentifier:ID];
        
    }
    return _collectionView;
}


#pragma mark  懒加载列表模型数组
- (NSArray *)listArray
{
    if (_listArray == nil)
        _listArray = [LWScanQRModel scanQRModelArray];
    return _listArray;
}

#pragma mark 重写viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

@end

// ====================================================================================================================================================================
#pragma mark - 扫描和二维码控制器tools方法实现
@implementation LWScanQRViewController (tools)

#pragma mark 初始化界面
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"样例";
    [self.view addSubview:self.collectionView];
}

#pragma mark QQ样式
- (void)qqStyle
{
    if ([self checkCameraAuthority] == NO) {
        return;
    }
   
    
}

#pragma mark 支付宝扫码
- (void)zhifuStyle
{
}
#pragma mark 微信扫码
- (void)wechatStyle
{

}

#pragma mark mark 无边框
- (void)innerStyle
{

}

#pragma mark mark 网格动画
- (void)onStyle
{

}

#pragma mark 自定义颜色
- (void)colorStyle
{

}

#pragma mark 可识别框外
- (void)outStyle
{

}

#pragma mark  改变尺寸
- (void)changeStyle
{

}

#pragma mark 条形码效果
- (void)notStyle
{

}

#pragma mark 二维码条形码
- (void)qrStyle
{

}

#pragma mark 相册
- (void)photoStyle
{

}

#pragma mark 检查相机是否可用
- (BOOL)checkCameraAuthority
{
    return [LWTools checkCameraOrAblumAuthorityWith:UIImagePickerControllerSourceTypeCamera];
}


@end

// ====================================================================================================================================================================
#pragma mark - 扫描和二维码控制器UICollectionViewDelegateDataSource方法实现
@implementation LWScanQRViewController(UICollectionViewDelegateDataSource)

#pragma mark 组数（默认一组）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每组cell 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

#pragma mark cell尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 160);
}

#pragma mark cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LWScanQRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    LWScanQRModel *model = self.listArray[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark 选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LWScanQRModel *model = self.listArray[indexPath.row];
    NSString *methodName = model.style;
    SEL selector = NSSelectorFromString(methodName);
    if ([self respondsToSelector:selector]) {
# pragma clang diagnostic push
# pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector];
# pragma clang diagnostic pop
    }
}

@end

// ====================================================================================================================================================================




