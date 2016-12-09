//
//  AutoRefreshTableView.m
//  SafePeriod
//
//  Created by Sheng long on 13-6-5.
//  Copyright (c) 2013年 cdeledu. All rights reserved.
//

#import "AutoRefreshTableView.h"
#import "AutoTableConstant.h"
#import "AutoRefreshTableHeaderView.h"
#import <MD5Digest/NSString+MD5.h>
#import "DLLoadingSetting.h"
#import <DLUtls/CommUtls+Time.h>

typedef void (^AT_RefreshData)();
typedef void (^AT_LoadingMoreData)();

@interface AutoRefreshTableView()<ATRefreshTableHeaderDelegate,AutoLoadingMoreViewDelegate>{
    //标志是否正在刷新
    BOOL _reloading;
}

@property (nonatomic,copy) AT_RefreshData refresBlock;
@property (nonatomic,copy) AT_LoadingMoreData loadingMoreBlock;

/**
 *  数据持有的个数，判断显示状态的重要依据
 *  防止设置autoDataArray时指针混乱影响判断，特加入此数据
 */
@property (nonatomic,assign) NSInteger dataNum;

@property (nonatomic,strong) AutoRefreshTableHeaderView *refreshView;
@property (nonatomic,strong) AutoLoadingMoreView *customLoadingDataView;

/**
 *  刷新时间
 */
@property (nonatomic,strong) NSString *refreshTime;

/**
 *  上次scrollView移到位置
 */
@property (nonatomic,assign) CGFloat lastOffset;

@end

@implementation AutoRefreshTableView

@synthesize currentRefreshState=_currentRefreshState;
@synthesize mainTable=_mainTable;
@synthesize refreshView=_refreshView;
@synthesize customLoadingDataView=_customLoadingDataView;

-(void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc====%@",self.class);
#endif
    self.refreshView.delegate = nil;
    self.refreshView = nil;
    self.customLoadingDataView = nil;
    self.mainTable = nil;
    
    _autoDataArray = nil;
    
    self.refresBlock = nil;
    self.loadingMoreBlock = nil;
}

//设置刷新获取数据view
-(void)setCurrentRefreshType:(AT_TABEL_REFRESH_STATE)type{
    //获取刷新view
    BOOL isDown = NO;
    BOOL isOn = NO;
    switch (type) {
        case AT_NO_REFRESH_STATE:{
            //没有刷新
        }
            break;
        case AT_REFRESH_STATE:{
            //下拉
            isDown = YES;
        }
            break;
        case AT_LOADING_MORE_STATE:{
            //上拉
            isOn = YES;
        }
            break;
        case AT_ALL_REFRESH_STATE:{
            //上下拉取
            isDown = YES;
            isOn = YES;
        }
            break;
        default:
            break;
    }
    
    if (YES == isDown && !_refreshView) {
        //下拉
        self.refreshView = [[AutoRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _mainTable.bounds.size.height, _mainTable.frame.size.width, _mainTable.bounds.size.height) state:downPullState];
        _refreshView.delegate = self;
        [_mainTable addSubview:_refreshView];
        [_refreshView refreshLastUpdatedDate];
    }
    
    if (YES == isOn && !_customLoadingDataView) {
        //设置默认状态
        self.customLoadingDataView = [[AutoLoadingMoreView alloc]initWithFrame:CGRectMake(0.0, 0.0,  _mainTable.frame.size.width, 40.0)];
        [_customLoadingDataView setDelegate:self];
    }
    
    //初始化是没有刷新的状态
    _currentRefreshState = AT_NO_REFRESH_STATE;
}

-(void)getRefreshTableData:(AT_RefreshData)block{
    self.refresBlock = block;
}

-(void)getLoadingMoreTableData:(AT_LoadingMoreData)block{
    self.loadingMoreBlock = block;
}

-(void)setAutoDataArray:(NSArray *)aArray{
    
    NSInteger oldDataNumber = self.dataNum;
    NSInteger newDataNumber = aArray.count;
    self.dataNum = aArray.count;
    
    //设置数据
    _autoDataArray = aArray;
    
    if (_customLoadingDataView) {
        //是否没有更多数据可加载
        BOOL noData = NO;
        //设置每次获取数据数量，可以判断是否加载完成
        if (_getDataNumber > 0) {
            if ((_currentRefreshState == AT_LOADING_MORE_STATE) && (newDataNumber-oldDataNumber<_getDataNumber) && (newDataNumber-oldDataNumber>=0)) {
                //加载更多数据加载完成
                noData = YES;
            }else if (newDataNumber<_getDataNumber) {
                noData = YES;
            }
        }else if (_currentRefreshState == AT_LOADING_MORE_STATE && newDataNumber-oldDataNumber==0){
            //因为有可能加载更多数据的时候，返回数据量不定的时候
            //此时虽然没有设置加载更多数据量，但是依然判断是否还有更多数据可加载
            //所以如果在加载更多的状态下，数据量相等，此时判断是没有更多数据可用
            noData = YES;
        }
        if (noData) {
            //此情况一般说明没有更多数据可用加载了
            [_customLoadingDataView setCurrentDataState:AlreadyLoadedState];
        }else{
            //显示加载更多数据
            [_customLoadingDataView setCurrentDataState:GetMoreDataState];
        }
    }
    
    [self doneLoadingTableViewData];
}

-(void)autoPullGetData{
    if (!_reloading) {
        [self.mainTable setContentOffset:CGPointMake(0, 0)];
        [self performSelector:@selector(autoS) withObject:nil afterDelay:0.1];
    }
}
-(void)autoS{
    [_refreshView autoRefreshData:_mainTable];
}

-(void)doneLoadingTableViewData{
    //刷新在前面，以免变化数据源之后调用egoRefreshScrollViewDataSourceDidFinishedLoading方法，位移变化之后可能会执行显示cell的代理，数据有问题就会导致bug
    if (![_mainTable isKindOfClass:[UICollectionView class]]) {
        [_mainTable reloadData];
    }
    
    //修改EGORefreshTableHeaderView状态和位置信息
    if (_currentRefreshState == AT_REFRESH_STATE) {
        [self recordRefreshTime];
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_mainTable];
    }
    
    //
    if (_customLoadingDataView.currentDataState==AlreadyRefreshReloading || _customLoadingDataView.currentDataState==LoadingDataState) {
        [_customLoadingDataView setCurrentDataState:GetMoreDataState];
    }
    
//    if (_reloading) {
//        //完成刷新UI
//        [_mainTable reloadData];
//    }else if (self.autoDataArray.count && _currentRefreshState == AT_NO_REFRESH_STATE){
//        //在初始情况下，没有刷新，直接赋值的时候，此时需要刷新下显示加载更多时才不会出现问题
//        [_mainTable reloadData];
//    }
//    //强制刷新了，不然影响使用
//    [_mainTable reloadData];
    
    //当table为UICollectionView时，先刷新会导致页面效果不佳，所有刷新只能放在后面
    //但是在后面又不能很好的规避数据减少之后带来的位移变化刷新cell的bug
    //此情况比较极端，且不会长期出现，所以在UICollectionView时忽略此情况，后期再优化
    if ([_mainTable isKindOfClass:[UICollectionView class]]) {
        [_mainTable reloadData];
    }
    
    _reloading = NO;
    _currentRefreshState = AT_NO_REFRESH_STATE;
    
    [self loadingMoreShow];
}

-(void)loadingMoreNoData{
    [_customLoadingDataView setCurrentDataState:AlreadyLoadedState];
    [self doneLoadingTableViewData];
}

-(void)recoverShowState{
    if (_currentRefreshState == AT_LOADING_MORE_STATE) {
        //设置加载更多状态异常
        [_customLoadingDataView setCurrentDataState:GetMoreDataExceptionState];
    }
    [self doneLoadingTableViewData];
}

-(void)deleteDataAfterShow{
    [self deleteDataAfterShow:1 deleteAll:nil];
}

-(void)deleteDataAfterShow:(NSInteger)num
                 deleteAll:(void(^)())all{
    BOOL deleteAll = (self.dataNum==num);
    self.dataNum-=num;
    [_mainTable reloadData];
    [self loadingMoreShow];
    if (deleteAll && all) {
        all();
    }
}

/**
 *  设置加载更多的显示状态
 */
-(void)loadingMoreShow{
    if (_customLoadingDataView) {
        //显示加载完成的时候，有时内容高度加上加载完成不过满屏，此时显示加载完成会比较难看
        //通过判断contentSize是否显示出加载完成
        if ((_mainTable.contentSize.height<_mainTable.frame.size.height) || (_noShowLoadingDone && _customLoadingDataView.currentDataState == AlreadyLoadedState) || (_mainTable.contentSize.height==0)) {
            [_mainTable setTableFooterView:nil];
        }else if (!_customLoadingDataView.superview){
            [_mainTable setTableFooterView:_customLoadingDataView];
        }
    }
}

#pragma mark - 执行获取数据的方法
//刷新数据
-(void)refreshData{
#ifdef DEBUG
    NSLog(@"刷新");
#endif
    if ([_delegate respondsToSelector:@selector(refreshTableData)]) {
        //正在下拉刷新
        [_delegate refreshTableData];
    }else if (self.refresBlock){
        self.refresBlock();
    }else{
        [self recoverShowState];
    }
}

//点击加载更多
-(void)loadingMoreData{
#ifdef DEBUG
    NSLog(@"加载更多");
#endif
    if ([_delegate respondsToSelector:@selector(loadingMoreTableData)] && !_reloading) {
        //正在加载更多
        _reloading = YES;
        _currentRefreshState = AT_LOADING_MORE_STATE;
        [_delegate loadingMoreTableData];
    }else if (self.loadingMoreBlock && !_reloading){
        //正在加载更多
        _reloading = YES;
        _currentRefreshState = AT_LOADING_MORE_STATE;
        self.loadingMoreBlock();
    }else if(_reloading && _currentRefreshState==AT_REFRESH_STATE){
        [_customLoadingDataView setCurrentDataState:AlreadyRefreshReloading];
    }else{
        [_customLoadingDataView setCurrentDataState:GetMoreDataExceptionState];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当前正在刷新
    if (!_reloading) {
        if (scrollView.contentOffset.y<0) {
            //处于下拉状态
            [_refreshView egoRefreshScrollViewDidScroll:scrollView];
        }else if (_customLoadingDataView.superview){
            if(!_clickLoadingMore && (_customLoadingDataView.currentDataState==GetMoreDataState) && (scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.bounds.size.height < _customLoadingDataView.bounds.size.height) && (_autoDataArray.count || !_autoDataArray) && scrollView.contentOffset.y > self.lastOffset){
                //需要自动刷新
                [_customLoadingDataView clickButt];
            }else if ((_customLoadingDataView.currentDataState==GetMoreDataExceptionState) && (scrollView.contentSize.height - scrollView.contentOffset.y -scrollView.bounds.size.height > _customLoadingDataView.bounds.size.height)){
                //加载更多异常状态
                //重新设置为加载更多状态
                _customLoadingDataView.currentDataState = GetMoreDataState;
            }
        }
    }
    self.lastOffset = scrollView.contentOffset.y;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //当前正在刷新
    if (!_reloading) {
        //停止拖动调用此方法
        [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //添加此方法是因为ios8下松开刷新有一个跳的动画，影响体验
    if ([_refreshView willBeginDecelerating:scrollView]) {
        [scrollView setContentOffset:scrollView.contentOffset animated:YES];
    }
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
//代理执行获取数据的方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(AutoRefreshTableHeaderView*)view{
    //网络状态不佳的情况下会卡死，开线程去执行方法
    //设置正在刷新状态
    _reloading = YES;
    
    //刷新数据
    _currentRefreshState = AT_REFRESH_STATE;
    [self refreshData];
}

//获取是否在刷新获取数据
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(AutoRefreshTableHeaderView*)view{
    return _reloading;
}

//是否显示时间
- (NSString *)egoRefreshTableHeaderDataSourceLastUpdated
{
//    NSString *key = [NSString stringWithFormat:@"%@_time_cdel",self.class];
//    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:[key MD5Digest]];
//    if (!time) {
//        time = @"暂未刷新";
//    }
//    return time;
    if (!self.refreshTime && [DLLoadingSetting sharedInstance].autoTableShowTime) {
        self.refreshTime = [CommUtls encodeTime:[NSDate date]];
    }
    return [NSString stringWithFormat:@"最后更新: %@", self.refreshTime];
}

/**
 *  记录刷新时间，刷新显示时间用
 */
- (void)recordRefreshTime {
    if ([DLLoadingSetting sharedInstance].autoTableShowTime) {
//        NSString *key = [NSString stringWithFormat:@"%@_time_cdel",self.class];
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        [[NSUserDefaults standardUserDefaults] setObject:[formatter stringFromDate:date] forKey:[key MD5Digest]];
        self.refreshTime = [CommUtls encodeTime:[NSDate date]];
    }
}

@end
