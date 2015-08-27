//
//  ViewController.m
//  LocationARTest
//
//  Created by skytoup on 15/8/24.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#include <metaioSDK/Common/SensorsComponentIOS.h>
#include <metaioSDK/IMetaioSDKIOS.h>
#import "StoreNetManager.h"
#import "StoreNetManager.h"
#import "StoreViewController.h"

class AnnotatedGeometriesGroupCallback : public metaio::IAnnotatedGeometriesGroupCallback
{
public:
    AnnotatedGeometriesGroupCallback(ViewController* _vc) : vc(_vc) {}
    
    virtual metaio::IGeometry* loadUpdatedAnnotation(metaio::IGeometry* geometry, void* userData, metaio::IGeometry* existingAnnotation) override {
        return [vc loadUpdatedAnnotation:geometry userData:userData existingAnnotation:existingAnnotation];
    }
    
    ViewController* vc;
};


@interface ViewController ()
{
    metaio::IGeometry **geos;
}
@property (nonatomic, assign) AnnotatedGeometriesGroupCallback *annotatedGeometriesGroupCallback;
@property (strong, nonatomic) NSArray *storeModles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!m_pMetaioSDK->setTrackingConfiguration("GPS"))
    {
        NSLog(@"Failed to set the tracking configuration");
    }
    
    
    // 注册回调
    annotatedGeometriesGroup = m_pMetaioSDK->createAnnotatedGeometriesGroup();
    self.annotatedGeometriesGroupCallback = new AnnotatedGeometriesGroupCallback(self);
    annotatedGeometriesGroup->registerCallback(self.annotatedGeometriesGroupCallback);
    
    
    // Clamp geometries' Z position to range [5000;200000] no matter how close or far they are away.
    // This influences minimum and maximum scaling of the geometries (easier for development).
    m_pMetaioSDK->setLLAObjectRenderingLimits(5, 200);
    
    // Set render frustum accordingly
    m_pMetaioSDK->setRendererClippingPlaneLimits(10, 220000);
    m_radar = m_pMetaioSDK->createRadar();
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *radarPath = [mainBundle pathForResource:@"radar.png" ofType:nil];
    const char *radarUtf8Path = [radarPath UTF8String];
    
    m_radar->setBackgroundTexture(metaio::Path::fromUTF8(radarUtf8Path));
    
    NSString *yellowPath = [mainBundle pathForResource:@"yellow.png" ofType:nil];
    const char *yellowUtf8Path = [yellowPath UTF8String];
    m_radar->setObjectsDefaultTexture(metaio::Path::fromUTF8(yellowUtf8Path));
    m_radar->setRelativeToScreen(metaio::IGeometry::ANCHOR_TL);
    m_radar->setObjectsScale(.8f);
    
    ViewController * __weak v = self;
    [[StoreNetManager sharedInstance] getAroundStoreWithBlock:^(NSArray *storeDatas) {
        if(!storeDatas) {
            return;
        }
        v.storeModles = storeDatas;
        m_radar->removeAll();
        
        if(geos) {
            free(geos);
        }
        geos = (metaio::IGeometry**)malloc(sizeof(metaio::IGeometry*)*storeDatas.count);
        
        [storeDatas enumerateObjectsUsingBlock:^(StoreModule *m, NSUInteger idx, BOOL *stop) {
            metaio::LLACoordinate coor = metaio::LLACoordinate(m.latitude.doubleValue, m.longitude.doubleValue, 0, 0);
            NSString* poiModelPath = [[NSBundle mainBundle] pathForResource:@"ExamplePOI" ofType:@"obj"];
            
            const char *utf8Path = [poiModelPath fileSystemRepresentation];
            metaio::IGeometry* geo = m_pMetaioSDK->createGeometry(metaio::Path::fromUTF8(utf8Path));
            geo->setName(metaio::stlcompat::String([m.name UTF8String]) );
            geo->setTranslationLLA(coor);
            geo->setLLALimitsEnabled(true);
            geo->setScale(70);
            geo->setTranslation(metaio::Vector3d(0, 0, idx*5000) );
            geos[idx] = geo;
            
            annotatedGeometriesGroup->addGeometry(geo, (__bridge void*)m);
            m_radar->add(geo);
        }];
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    m_pMetaioSDK->stopCamera();
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    m_pMetaioSDK->startCamera();
    
}

- (void)drawFrame
{
    // make pins appear upright
    if (m_pMetaioSDK && m_pSensorsComponent)
    {
        const metaio::SensorValues sensorValues = m_pSensorsComponent->getSensorValues();
        
        float heading = 0.0f;
        if (sensorValues.hasAttitude()) {
            float m[9];
            sensorValues.attitude.getRotationMatrix(m);
            
            metaio::Vector3d v(m[6], m[7], m[8]);
            v = v.getNormalized();
            
            heading = -atan2(v.y, v.x) - (float)M_PI_2;
        }
        
        const metaio::Rotation rot((float)M_PI_2, 0.0f, -heading);
        for (int i = 0; i < _storeModles.count; ++i) {
            geos[i]->setRotation(rot);
        }
    }
    
    [super drawFrame];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Here's how to pick a geometry
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.glkView];
    
    // get the scale factor (will be 2 for retina screens)
    float scale = self.glkView.contentScaleFactor;

    metaio::IGeometry* model = m_pMetaioSDK->getGeometryFromViewportCoordinates(loc.x * scale, loc.y * scale, true);
    
    if(model) {
        metaio::stlcompat::String s =  model->getName();
        NSString *string = [NSString stringWithUTF8String:s.c_str()];
        [_storeModles enumerateObjectsUsingBlock:^(StoreModule *m, NSUInteger idx, BOOL *stop) {
            if([string isEqualToString:m.name]) {
                *stop = YES;
                StoreViewController *vc = [StoreViewController new];
                vc.module = m;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }];
    }
}


- (metaio::IGeometry*)loadUpdatedAnnotation:(metaio::IGeometry*)geometry userData:(void*)userData existingAnnotation:(metaio::IGeometry*)existingAnnotation
{
    if (existingAnnotation) {
        return existingAnnotation;
    }
    
    if (!userData) {
        return 0;
    }
    
    StoreModule *m = (__bridge StoreModule*)userData;
    
    UIImage* img = metaio::createAnnotationImage(m.name, geometry->getTranslationLLA(), m_currentLocation, nil, nil, m.stars.floatValue);
    return m_pMetaioSDK->createGeometryFromCGImage([m.name UTF8String], img.CGImage, true, false);
}

@end
