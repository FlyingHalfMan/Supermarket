//
//  LUMapViewController.m
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUMapViewController.h"
#import "MAMapView.h"
#import "POIAnnotation.h"
#import "LMUSupermaretHomeViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface LMUMapViewController ()<AMapLocationManagerDelegate,AMapSearchDelegate,MAMapViewDelegate>
@property(nonatomic,strong)MAMapView* mapView;
@property(nonatomic,strong)AMapLocationManager* locationManager;
@property(nonatomic,strong)AMapSearchAPI* searchAPI;

@property(nonatomic,strong)RACSubject* locationUpdateSignal;
@end

@implementation LMUMapViewController{
     NSArray<AMapPOI *> *poisitions;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationUpdateSignal = [[RACSubject subject]setNameWithFormat:@"update"];
    

    
    [self initUI];
    
    // 定位
    _locationManager = [[AMapLocationManager alloc]init];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    // Do any additional setup after loading the view.
    
    //搜索api
    self.searchAPI = [[AMapSearchAPI alloc]init];
    self.searchAPI.delegate = self;
    
    _mapView = [[MAMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.mapType= MAMapTypeStandard;
    _mapView.delegate = self;
    self.view =_mapView;
    
    // 设置高德定位
    
    _mapView.pausesLocationUpdatesAutomatically = NO;
    
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    self.locationManager  =[[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self.locationManager startUpdatingLocation];
    //[self.locationManager setLocatingWithReGeocode:YES];
    
    [_locationUpdateSignal subscribeNext:^(AMapGeoPoint* x) {
        //
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        
        request.keywords            = @"超市";
        request.location            =x;
        request.types               = @"购物服务";
        request.requireExtension    = YES;
        
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        request.sortrule            = 0;
        request.requireExtension    = YES;
        request.requireSubPOIs      = YES;
        [self.searchAPI AMapPOIAroundSearch:request];
    }];
}

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{

    
    AMapGeoPoint*point = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [self.locationUpdateSignal sendNext:point];



}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView removeAnnotations:_mapView.annotations];
    [_locationManager stopUpdatingLocation];
}


// 搜索
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{

    NSLog(@"搜索结果%@",response.pois);
    poisitions = response.pois;
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@ %@",obj.address,obj.name);
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI{

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"personal_back_image"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new ]];
    
    //在navigationController 加入搜索栏

}
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{

    NSLog(@"annotation View %@ %@",view.annotation.title,view.annotation.subtitle);
    

}
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{

    static NSString *identify = @"annotation";
    //在原有的大头针中添加自定义的修饰
    MAPinAnnotationView *pointAnnotation = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    if (pointAnnotation == nil) {
        //在原有的大头针中创建一个新的自定义的大头针
        pointAnnotation = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify];
    }
    if ([annotation.title isEqualToString:@"当前位置"]) {
        pointAnnotation.pinColor =MAPinAnnotationColorGreen;
    }
    //设置是否能选中的标题
    pointAnnotation.canShowCallout = YES;
    //是否允许拖拽
    pointAnnotation.draggable = YES;
    //是否允许退拽动画
    pointAnnotation.animatesDrop = YES;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button setTitle:@"进入超市" forState:UIControlStateNormal];
    button.rac_command =[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"LMUSupermarketHome" bundle:nil];
        UINavigationController* nav = storyboard.instantiateInitialViewController;
        [self presentViewController:nav animated:YES completion:nil];
//        LMUSupermaretHomeViewController* supermarketHomeVC = [[LMUSupermaretHomeViewController alloc]initWithName:annotation.title Address:annotation.subtitle];
//        
//        [self.navigationController pushViewController:supermarketHomeVC animated:YES];
//        
        return [RACSignal empty];
    }];
    pointAnnotation.rightCalloutAccessoryView = button;
    return pointAnnotation;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
