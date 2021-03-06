//
//  MapViewController.m
//  AppListaDeCompras
//
//  Created by ALUNO on 07/12/16.
//  Copyright © 2016 IESB. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<MKMapViewDelegate>{
    __weak IBOutlet MKMapView *mapa;
    CLLocationManager *localizacao;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapa.showsUserLocation = YES;
    
    localizacao = [CLLocationManager new];
    
    if([localizacao respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [localizacao requestWhenInUseAuthorization];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [localizacao requestWhenInUseAuthorization];
    }
    
    [localizacao startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *local = [locations firstObject];
    CLLocationCoordinate2D coordenada = local.coordinate;
    
    NSLog(@"Latitude: %f, Longitude: %f", coordenada.latitude, coordenada.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
