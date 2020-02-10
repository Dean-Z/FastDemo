//
//  FDAnnonation.h
//  FastDemo
//
//  Created by Jason on 2020/2/10.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum{
    AnnotationTypeMovie = 0,
    AnnotationTypeHotel
} AnnotationType;

@interface FDAnnonation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@property (nonatomic, assign) AnnotationType AT;

@end

