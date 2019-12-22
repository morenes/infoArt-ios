//
//  RMPath.h
//
// Copyright (c) 2008-2009, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>

#import "RMFoundation.h"
#import "RMLatLong.h"
#import "RMMapLayer.h"

@class RMMapContents;
@class RMMapView;

@interface RMPath : RMMapLayer <RMMovingMapLayer> 

- (id) initWithContents: (RMMapContents*)aContents;
- (id) initForMap: (RMMapView*)map;
- (id) initForMap: (RMMapView*)map withCoordinates:(const CLLocationCoordinate2D*)coordinates count:(NSInteger)count;

- (void) moveToXY: (RMProjectedPoint) point;
- (void) moveToScreenPoint: (CGPoint) point;
- (void) moveToLatLong: (RMLatLong) point;
- (void) addLineToXY: (RMProjectedPoint) point;
- (void) addLineToScreenPoint: (CGPoint) point;
- (void) addLineToLatLong: (RMLatLong) point;
- (void) closePath;

@property (nonatomic, assign) CGLineCap lineCap;
@property (nonatomic, assign) CGLineJoin lineJoin;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, assign) BOOL	scaleLineWidth;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) NSArray *lineDashLengths;
@property (nonatomic, assign) CGFloat lineDashPhase;
@property (nonatomic, assign) BOOL scaleLineDash;
@property (nonatomic, assign) RMProjectedPoint projectedLocation;
@property (assign) BOOL enableDragging;
@property (assign) BOOL enableRotation;
@property (nonatomic, readwrite, assign) UIColor *lineColor;
@property (nonatomic, readwrite, assign) UIColor *fillColor;
@property (nonatomic, readonly) CGPathRef CGPath;
@property (nonatomic, readonly) RMProjectedRect projectedBounds;
@end

