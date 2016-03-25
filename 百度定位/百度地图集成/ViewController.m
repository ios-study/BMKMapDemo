//
//  ViewController.m
//  百度地图集成
//
//  Created by xiaomage on 15/8/24.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "BNCoreServices.h"

@interface ViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;

@property (nonatomic, assign) CGFloat locaLatitude;
@property (nonatomic, assign) CGFloat locaLongitude;

- (IBAction)currentLocationBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationText;
@property (weak, nonatomic) IBOutlet UITextField *latitudeText;     // 纬度
@property (weak, nonatomic) IBOutlet UITextField *longtitudeText;   // 经度
@property (nonatomic, assign) int count;    // 只添加一次大头针
@property (weak, nonatomic) IBOutlet UITextView *locationStr;
- (IBAction)getCodeResult:(id)sender;   // 地理编码
- (IBAction)getReverseCodeResult:(id)sender;    // 反地理编码

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _count = 0;
    _mapView.delegate=self;
    _mapView.showsUserLocation=YES;//可以显示用户位置
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geoSearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geoSearch.delegate = nil;
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@"latitude--%f,longtitude---%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _locaLatitude=userLocation.location.coordinate.latitude;//纬度
    _locaLongitude=userLocation.location.coordinate.longitude;//精度
    BMKCoordinateRegion region;
    //将定位的点居中显示
    region.center.latitude=_locaLatitude;
    region.center.longitude=_locaLongitude;
    
    //反地理编码出地理位置
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){_locaLatitude,_locaLongitude};
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                                BMKReverseGeoCodeOption alloc]init];
                                                                reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag=[_geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        _mapView.showsUserLocation=NO;//不显示自己的位置
    }
    
    _mapView.region = region;
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    

    
    // 反地理编码出地理位置
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
//
//    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
//    BMKReverseGeoCodeOption alloc]init];
//    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
//    if(flag)
//    {
//      NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//      NSLog(@"反geo检索发送失败");
//    }
    

    
}


/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    NSLog(@"纬度:%f, 经度:%f", result.location.latitude, result.location.longitude);
    self.latitudeText.text = @(result.location.latitude).stringValue;
    self.longtitudeText.text = @(result.location.longitude).stringValue;
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      /** NSString* _streetNumber;
       NSString* _streetName;
       NSString* _district;
       NSString* _city;
       NSString* _province; */
      
      BMKPointAnnotation *item=[[BMKPointAnnotation alloc] init];
      item.coordinate=result.location;//地理坐标
      item.title=result.address;//地理名称
      [_mapView addAnnotation:item];
      _mapView.centerCoordinate=result.location;
      

    self.locationText.text = result.address;
      
      self.locationStr.text = result.address;
      
      
     // 在此处理正常结果
//      NSLog(@"%@", result.address);
//      NSLog(@"result.addressDetail.streetNumber：%@, result.addressDetail.streetName:%@, result.addressDetail.district:%@, result.addressDetail.city:%@, result.addressDetail.province:%@", result.addressDetail.streetNumber, result.addressDetail.streetName, result.addressDetail.district, result.addressDetail.city, result.addressDetail.province);
//      self.locationText.text = result.address;
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }

}


// 关闭定位服务
- (void)stopLocation
{
    [_locService startUserLocationService];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent: event];
    
    [self.view endEditing:YES];
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    _count ++;
    if (_count == 1) {
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
            // 生成重用标示identifier
            NSString *AnnotationViewID = @"xidanMark";
            
            // 检查是否有重用的缓存
            BMKPinAnnotationView* annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
            
            // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
            if (annotationView == nil) {
                annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
                
            }
            annotationView.pinColor = BMKPinAnnotationColorRed;
            // 设置重天上掉下的效果(annotation)
            annotationView.animatesDrop = YES;
            
            // 设置位置
            annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
            annotationView.annotation = annotation;
            // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
            annotationView.canShowCallout = YES;
            // 设置是否可以拖拽
            annotationView.draggable = NO;
            
            return annotationView;
        }
        

    }
    return nil;
    
}

//地图长按事件
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    //长按之前删除所有标注
    NSArray *arrayAnmation=[[NSArray alloc] initWithArray:_mapView.annotations];
    [_mapView removeAnnotations:arrayAnmation];
    //得到经纬度
    _locaLatitude=coordinate.latitude;
    _locaLongitude=coordinate.longitude;
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){coordinate.latitude,coordinate.longitude};
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag=[_geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"success");
    }else{
        NSLog(@"falied");
    }
}

// 获取当前位置
- (IBAction)currentLocationBtnClick:(id)sender {
    _count = 0;
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _geoSearch.delegate = self;

}

// 地理编码
- (IBAction)getCodeResult:(id)sender {
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _geoSearch.delegate = self;

    
    // 地理编码
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//        geoCodeSearchOption.city= @"广州市";
        geoCodeSearchOption.address = self.locationStr.text;
        BOOL flag = [_geoSearch geoCode:geoCodeSearchOption];
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
}

// 反地理编码
- (IBAction)getReverseCodeResult:(id)sender {
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _geoSearch.delegate = self;

    
    //反地理编码出地理位置
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){[_latitudeText.text floatValue],[_longtitudeText.text floatValue]};
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag=[_geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        _mapView.showsUserLocation=NO;//不显示自己的位置
    }
    
}

// 谷歌定位和百度地图的经纬度有偏差
//- (void)coderbreserve
//{
//    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
//    _mapView.centerCoordinate = coordinate;
//
//    [_mapView updateLocationData:userLocation];
//
//    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude
//                                                longitude:userLocation.location.coordinate.longitude];
//    __block NSString *province;
//    __block NSString *cityName;
//    __block NSString *cityStr;
//    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
//        for (CLPlacemark *placemark in placemarks) {
//            province = placemark.administrativeArea;
//            if (province.length == 0) {
//                province = placemark.locality;
//                cityName = placemark.subLocality;
//                NSLog(@"cityName %@",cityName);//获取城市名
//                NSLog(@"province %@ ++",province);
//            }else {
//                //获取街道地址
//                cityStr = placemark.thoroughfare;
//                //获取城市名
//                cityName = placemark.locality;
//                province = placemark.administrativeArea;
//                NSLog(@"cityStr %@",cityStr);//获取街道地址（喻园大道）
//                NSLog(@"cityName %@",cityName);//获取城市名（武汉市）
//                NSLog(@"province %@",province);// 省份（湖北省）
//                NSLog(@"name %@", placemark.name);// 整体地名（中国湖北省武汉市洪山区关山街道喻园大道）
//                NSLog(@"subLocality %@", placemark.subLocality);// 区（洪山区）
//            }
//            break;
//        }
//
//    }];
//
//}

@end
