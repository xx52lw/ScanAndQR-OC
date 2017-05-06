//
//  LWScanQRViewController.m
//  OCScanAndQR
//
//  Created by 张星星 on 17/4/23.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "LWScanQRViewController.h"
#import "LWScanQRCollectionViewCell.h"
#import "LWScanQRModel.h"
#import "LWTools.h"
#import "LWScanViewController.h"
#import "LWQRViewController.h"
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
- (void)scanStyle;  // scan样式
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
- (UICollectionView *)collectionView {
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
- (NSArray *)listArray {
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
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"样例";
    [self.view addSubview:self.collectionView];
}

#pragma mark 扫码样式
- (void)scanStyle {
    if ([self checkCameraAuthority] == NO) {
        return;
    }
    LWScanViewController *vc = [[LWScanViewController  alloc] init];
    vc.animationImage = [LWTools iamgeName:@"scan_scanLine" withBundleName:@"CodeScan"];
    vc.bgImage = [LWTools iamgeName:@"scan_scanBg" withBundleName:@"CodeScan"];
    vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 二维码条形码
- (void)qrStyle {
    LWQRViewController * vc = [[LWQRViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 相册
- (void)photoStyle {

}

#pragma mark 检查相机是否可用
- (BOOL)checkCameraAuthority {
    return [LWTools checkCameraOrAblumAuthorityWith:UIImagePickerControllerSourceTypeCamera];
}


@end

// ====================================================================================================================================================================
#pragma mark - 扫描和二维码控制器UICollectionViewDelegateDataSource方法实现
@implementation LWScanQRViewController(UICollectionViewDelegateDataSource)

#pragma mark 组数（默认一组）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark 每组cell 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

#pragma mark cell尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 170);
}

#pragma mark cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LWScanQRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    LWScanQRModel *model = self.listArray[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark 选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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




