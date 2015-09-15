//
//  ViewController.m
//  CollectionDemo
//
//  Created by Broccoli on 15/7/23.
//  Copyright (c) 2015年 brocccoli. All rights reserved.
//

#import "ViewController.h"
#import "MagazineSliderLayout.h"
#import "MagazineSliderCell.h"
#import "PrefixHeader.pch"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_magazineView;
    NSArray *_magazineArray;
}

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Finished" object:nil];
}

// 设置状态栏风格
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setUpNavigation];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self reloadMagazineData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMagazineData) name:@"Finished" object:nil];
    [self startAsyncRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)reloadMagazineData {
    [_magazineView reloadData];
    [self initCollectionView];
}

-(void)initCollectionView
{
    MagazineSliderLayout *layout = [[MagazineSliderLayout alloc] init];
    [layout setContentSize:100];
    _magazineView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:layout];
    [_magazineView registerClass:[MagazineSliderCell class] forCellWithReuseIdentifier:@"CELL"];
    _magazineView.delegate = self;
    _magazineView.dataSource = self;
    _magazineView.userInteractionEnabled = YES;
//    [_magazineView addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [self.view addSubview:_magazineView];
}

//- (void)headerBeginRefreshing
//{
//    [_magazineView.header beginRefreshing];
//    [self startAsyncRequest];
//}

// 设置导航栏
- (void)setUpNavigation {
    self.navigationItem.title = @"良仓杂志";
    
    // 自定义导航栏文字Color
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:CustomGray,NSForegroundColorAttributeName,nil]];
    // 自定义导航栏背景颜色
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
   
    self.navigationItem.rightBarButtonItem.tintColor = CustomGray;
}



// 异步请求数据
- (void)startAsyncRequest
{
    NSLog(@"网络请求事件");
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.sina.com"];
//    if ([reach isReachableViaWiFi]) {
//        ASIHTTPRequest *ahttp = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:Magazine]];
//        ahttp.secondsToCache = 60;
//        [ahttp setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        //        appDelegate.cache = nil;
//        [ahttp setDownloadCache:appDelegate.cache];
//        ahttp.delegate = self;
//        [ahttp startAsynchronous];
//    } else {
//        ASIHTTPRequest *ahttp = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:Magazine]];
//        ahttp.secondsToCache = 60;
//        [ahttp setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [ahttp setDownloadCache:appDelegate.cache];
//        ahttp.delegate = self;
//        [ahttp startAsynchronous];
//        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络不可达" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            NSLog(@"network cannot reachable");
//        }];
//        [alertCtr addAction:alertAction];
//        [self presentViewController:alertCtr animated:YES completion:nil];
//    }
}

//// 请求完成时调用
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    [_magazineView headerEndRefreshing];
//    _magazineArray = [NSMutableArray  new];
//    NSDictionary *dic = [request.responseString objectFromJSONString];
//    _magazineArray = dic[@"data"][@"items"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Finished" object:nil];
//}
//
//// 请求失败时调用
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSLog(@"err:%@", request.error);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UICollectionViewDataSource

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT);
    }else if(indexPath.row == 1){
        return CGSizeMake(CELL_WIDTH, CELL_CURRHEIGHT);
    }else{
        return CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineSliderCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setIndex:indexPath.row];
    [cell reset];
    
    if(indexPath.row == 0){
        cell.imageView.image = nil;
    }else{
        if(indexPath.row == 1){
            [cell revisePositionAtFirstCell];
        }
//        NSDictionary *magazineDic = _magazineArray[indexPath.row-1];
        [cell setTitleLabel:[NSString stringWithFormat:@"我是title ---- %ld",(long)indexPath.row]];
        [cell setDescLabel:[NSString stringWithFormat:@"我是descLabel --- %ld", (long)indexPath.row]];
//        NSString *urlString = magazineDic[@"cover"][@"url"];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    WebViewController *webCtr = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
//    webCtr.urlStr = _magazineArray[indexPath.row-1][@"access_url"];
//    [self.navigationController pushViewController:webCtr animated:YES];
}

@end
