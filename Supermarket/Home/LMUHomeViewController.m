//
//  LMUHomeViewController.m
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUHomeViewController.h"
#import "LMUHomeView.h"
#import "AMapLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LMUHomeCategoryView.h"
#import "LMUHomeView.h"
#import "LMUSearchViewController.h"
@interface LMUHomeViewController()<AMapLocationManagerDelegate,AMapSearchDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)LMUHomeView* homeView;
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)AMapLocationManager* locationManager;
@property(nonatomic,strong)AMapSearchAPI* search;
@end
@implementation LMUHomeViewController{

    UILabel* label;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;

}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    [self StartLocation];
    [self bindSignal];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets =NO;

    _homeView = [[LMUHomeView alloc]init];
    [self.view addSubview:_homeView];
    
    [self nearByNavigationBarView:_homeView isShowBottom:YES];
    
    label = [[UILabel alloc]init];
    [self.navigationBarView.titleView addSubview:label];
    @weakify(self)
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.left.right.bottom.equalTo(self.navigationBarView.titleView);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    
//    [self.navigationBarView.leftButton setImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
//    [self.navigationBarView.leftButton setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 8)];
    [self.navigationBarView.rightButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
}

-(void)bindSignal{

    [self.homeView.viewModel.itemSelectedSignal subscribeNext:^(NSNumber* x) {
        switch (x.integerValue) {
            case HomeCategoryItem_Hot:{
                CLog(@"jump To hot");
            }
                break;
            case HomeCategoryItem_Like:{
                CLog(@"jump To like");
            }
                break;
            case HomeCategoryItem_Often:{
                CLog(@"jump To often");
            }
                break;
            case HomeCategoryItem_Sales:{
                CLog(@"jump To sales");
            }
                break;
            case HomeCategoryItem_Watch:{
                CLog(@"jump To watch");
            }
                break;
            case HomeCategoryItem_Market:{
                CLog(@"jump To market");
            }
                break;
            case HomeCategoryItem_Category:{
                CLog(@"jump To category");
            }
                break;
                
            default:{
                CLog(@"jump To collection");
            }
                break;
        }
    }];
}

-(void)rightButtonClick{
    
    LMUSearchViewController* searchVC = [[LMUSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];

}
-(void)leftButtonClick{

}


// 定位服务
-(void)StartLocation{
    _locationManager = [[AMapLocationManager alloc]init];
    _locationManager.delegate = self;
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [_locationManager startUpdatingLocation];
    
    //搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];

}
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{

    if (response.regeocode !=nil) {
        AMapReGeocode* geoCode = response.regeocode;
        AMapAddressComponent* component  = geoCode.addressComponent;
        NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@",component.province,component.city,component.district]);
       
        [label setText: [NSString stringWithFormat:@"%@%@%@",component.province,component.city,component.district]];
    }


}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.homeView scrollViewDidScroll:scrollView];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.homeView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.homeView scrollViewDidEndDecelerating:scrollView];

}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.homeView scrollViewWillBeginDecelerating:scrollView];

}
@end
