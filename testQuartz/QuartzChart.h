//
//  QuartzChart.h
//  testQuartz
//
//  Created by Emma Steimann on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartzChart : UIView
{
    @public
    NSArray *currentChartArray;
    BOOL includeAxes;
}

@property (nonatomic, strong) NSArray *currentChartArray;
@property (nonatomic, assign) BOOL includeAxes;

+ (id)createRandomCharts:(int)numberOfCharts withPoints:(int)numberOfPoints;
+ (id)createRandomCharts:(int)numberOfCharts withPoints:(int)numberOfPoints withBounds:(CGRect)chartBounds;
+ (id)randomChart:(int)numberOfPoints;
+ (id)randomChart:(int)numberOfPoints withBounds:(CGRect)chartBounds;
+ (NSArray *)getRandomPoints:(int)numberOfPoints;
+ (NSArray *)getRandomPoints:(int)numberOfPoints withBounds:(CGRect)chartBounds;

- (void)loadRandomData;

@end

@interface QuartzChart (private)


@end