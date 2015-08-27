//
//  ViewController.h
//  LocationARTest
//
//  Created by skytoup on 15/8/24.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <metaioSDK/IMetaioSDK.h>
#import <MetaioSDK/MetaioSDKViewController.h>

namespace metaio
{
    class IGeometry;   // forward declaration
}

@interface ViewController : MetaioSDKViewController
{
    metaio::IAnnotatedGeometriesGroup* annotatedGeometriesGroup;
    metaio::IRadar* m_radar;
    
    metaio::LLACoordinate   m_currentLocation;
}
- (metaio::IGeometry*)loadUpdatedAnnotation:(metaio::IGeometry*)geometry userData:(void*)userData existingAnnotation:(metaio::IGeometry*)existingAnnotation;
@end

