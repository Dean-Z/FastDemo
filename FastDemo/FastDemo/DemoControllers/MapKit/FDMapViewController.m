//
//  FDMapViewController.m
//  FastDemo
//
//  Created by Jason on 2020/2/10.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDMapViewController.h"
#import <MapKit/MapKit.h>
#import "FDAnnonation.h"
#import "FDKit.h"

@interface FDMapViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) CLLocationManager *locationM;
@property (nonatomic, strong) FDAnnonation *currentAnnonation;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) BOOL addAnnonationing;

@end

@implementation FDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self addViews];

}

- (void)setup {
    self.navigationBar.title = @"MapKit";
    self.navigationBar.parts = FDNavigationBarPartBack | FDNavigationBarPartAdd | FDNavigationBarPartFiles;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.navigationBar.onClickAddAction = ^{
        weakSelf.addAnnonationing = YES;
        weakSelf.navigationBar.addItem.hidden = YES;
    };
    
    self.navigationBar.onClickFileAction = ^{
        if (weakSelf.currentAnnonation) {
            [weakSelf beginNav];
        }
    };
}

- (void)addViews {
    [self locationM];
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.addAnnonationing || touches.count > 1) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.mapView];
    
    CLLocationCoordinate2D center = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *mark = [placemarks firstObject];
            self.currentAnnonation.title = mark.name;
            self.currentAnnonation.subtitle = mark.country;
        };
    }];
    [self addAnnonationWithCoordinate:center];
    self.addAnnonationing = NO;
    self.navigationBar.addItem.hidden = NO;
}

- (void)addAnnonationWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self.currentAnnonation) {
        [self.mapView removeAnnotation:self.currentAnnonation];
    }
    FDAnnonation *annonation = [FDAnnonation new];
    self.currentAnnonation = annonation;
    self.currentAnnonation.coordinate = coordinate;
    [self.mapView addAnnotation:self.currentAnnonation];
}


- (void)beginNav {
    NSArray *overlays = [self.mapView overlays];
    if (overlays.count > 0) {
        [self.mapView removeOverlays:overlays];
    }
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *itemP1 = [[MKPlacemark alloc] initWithCoordinate:self.currentCoordinate];
    MKMapItem *item1 = [[MKMapItem alloc]initWithPlacemark:itemP1];
    MKPlacemark *itemP2 = [[MKPlacemark alloc]initWithCoordinate:self.currentAnnonation.coordinate];
    MKMapItem *item2 = [[MKMapItem alloc]initWithPlacemark:itemP2];
    
//    NSDictionary *launDic = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeKey,
//    MKLaunchOptionsMapTypeKey: @(MKMapTypeHybridFlyover),
//    MKLaunchOptionsShowsTrafficKey : @(YES)};
//    //打开苹果自带地图app
//    [MKMapItem openMapsWithItems:@[item1,item2] launchOptions:launDic];
    
    request.source = item1;
    request.destination = item2;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            [self.mapView addOverlay:response.routes.firstObject.polyline level:MKOverlayLevelAboveRoads];
            MKMapRect rect = response.routes.firstObject.polyline.boundingMapRect;
            [self.mapView setRegion:MKCoordinateRegionForMapRect(rect) animated:YES];
        }
    }];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    userLocation.title = @"当前位置";
//    userLocation.subtitle = [NSString stringWithFormat:@"设备朝向 %@",userLocation.heading];
    self.currentCoordinate = userLocation.coordinate;
    if (self.mapView.userTrackingMode != MKUserTrackingModeFollowWithHeading) {
        self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    }
//
//    MKCoordinateSpan  span = MKCoordinateSpanMake(0.01, 0.01);
//    //    设置经纬度区域
//    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, span);
//    //    设置地图显示区域
//    [mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    NSLog(@"纬度%f,经度%f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(FDAnnonation *)annotation {
    static NSString *pinID = @"pinID";
    MKAnnotationView *customPinView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    if (!customPinView) {
        customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
    }
     NSString *imageName = @"category_3";
    //    保证一定加载
//        if(self.currentAnnonation)
//        {
//            switch (annotation.AT) {
//                case AnnotationTypeMovie:
//                    imageName = @"category_3";
//                    break;
//                case AnnotationTypeHotel:
//                    imageName = @"category_3";
//                    break;
//
//                default:
//                    break;
//            }
//        }
//
        customPinView.image = [UIImage imageNamed:imageName];
        customPinView.canShowCallout = YES;
//        // 设置标注左侧视图
//        UIImageView *leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        leftIV.image = [UIImage imageNamed:@"huba.jpeg"];
//        customPinView.leftCalloutAccessoryView = leftIV;
//
//        // 设置标注右侧视图
//        UIImageView *rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        rightIV.image = [UIImage imageNamed:@"eason.jpg"];
//        customPinView.rightCalloutAccessoryView = rightIV;

//        // 设置标注详情视图（iOS9.0）
//        customPinView.detailCalloutAccessoryView = [[UISwitch alloc] init];
    return customPinView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *lineRenderer = [[MKPolylineRenderer alloc]
        initWithOverlay:overlay];
        lineRenderer.lineWidth = 6;
        lineRenderer.strokeColor = [UIColor redColor];
        return lineRenderer;
    }
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc]
        initWithOverlay:overlay];

        circleRender.fillColor = [UIColor cyanColor];

        circleRender.alpha = 0.6;

        return circleRender;
    }
    return nil;
}

#pragma mark - Getter

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [MKMapView new];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.scrollEnabled = YES;
        _mapView.zoomEnabled = YES;
        _mapView.rotateEnabled = YES;
        _mapView.pitchEnabled = YES;
        _mapView.showsCompass = YES;
        _mapView.showsScale = NO;
        _mapView.showsTraffic = NO;
        _mapView.showsBuildings = NO;
    }
    return _mapView;
}

- (CLLocationManager *)locationM {
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc]init];
        if ([_locationM respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationM requestAlwaysAuthorization];
        }
    }
    return _locationM;
}

-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

@end
