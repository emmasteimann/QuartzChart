//
//  QuartzChart.m
//  testQuartz
//
//  Created by Emma Steimann on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzChart.h"
#import "QuartzLineGraph.h"
#import "QuartzChartAxes.h"

@implementation QuartzChart

@synthesize currentChartArray, includeAxes;

#pragma mark - Line Graph Class Methods

    /* These are convenience methods for testing charts,
     with random data */

    /* The following methods are used to create random
        arrays of charts. */

+ (id)createRandomCharts:(int)numberOfCharts withPoints:(int)numberOfPoints{
    
    return [self createRandomCharts:numberOfCharts withPoints:numberOfPoints withBounds:[[UIScreen mainScreen] bounds]];
    
}

+ (id)createRandomCharts:(int)numberOfCharts withPoints:(int)numberOfPoints withBounds:(CGRect)chartBounds{
    
    NSMutableArray *arrayOfCharts = [[NSMutableArray alloc] init];
    
    for (int y = 0; y < numberOfCharts; y++) {
        [arrayOfCharts addObject:[self randomChart:numberOfPoints withBounds:chartBounds]];
    }
    
    NSArray *newChartArray = [[NSArray alloc] initWithArray:arrayOfCharts];
    
    return [[QuartzChart alloc] initWithFrame:chartBounds withChartArray:newChartArray];
}

    /* The following method is used to create a single
     random chart. */

+ (id)randomChart:(int)numberOfPoints{
    return [self randomChart:numberOfPoints withBounds:[[UIScreen mainScreen] bounds]];
}
+ (id)randomChart:(int)numberOfPoints withBounds:(CGRect)chartBounds{
        
    NSArray *lineArray = [self getRandomPoints:numberOfPoints withBounds:chartBounds];
    
    QuartzLineGraph *newLineGraph = [[QuartzLineGraph alloc] initWithFrame:chartBounds andDataSet:lineArray withAxes:YES];
    
    return newLineGraph;
}

    /* The following methods are used to create random
     CGPoints for charts. */

+ (NSArray *)getRandomPoints:(int)numberOfPoints{
    return [self getRandomPoints:numberOfPoints withBounds:[[UIScreen mainScreen] bounds]];
}

+ (NSArray *)getRandomPoints:(int)numberOfPoints withBounds:(CGRect)chartBounds{
    
    int screenWidth = (int)chartBounds.size.width;
    int pointInterval = screenWidth/numberOfPoints; 
    
    int maxY = (int)chartBounds.size.height;
    
    NSMutableArray *lineData = [[NSMutableArray alloc] init];

    [lineData addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    
    for (int y = 0; y < numberOfPoints-2; y++) {
        [lineData addObject:[NSValue valueWithCGPoint:CGPointMake((pointInterval * (y+1)), arc4random() % maxY)]];
    }
    
    [lineData addObject:[NSValue valueWithCGPoint:CGPointMake((pointInterval * numberOfPoints), 0)]];
    
    NSArray *lineArray = [[NSArray alloc] initWithArray:lineData];
    
    return lineArray;
}


- (id)initWithFrame:(CGRect)frame withChartArray:(NSArray *)_newChartArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setCurrentChartArray:_newChartArray];
        
        includeAxes = NO;
        if (includeAxes){
            [self loadAxes];
        }

    }
    return self;
}

- (void)setCurrentChartArray:(NSArray *)_currentChartArray{    
    for (QuartzLineGraph *currentLineGraph in _currentChartArray){
        [self addSubview:currentLineGraph];
    }
    currentChartArray = _currentChartArray;
}

- (void)loadAxes{
//    CGRect chartFrame = [self getChartFrame];
    QuartzChartAxes *chartAxes = [[QuartzChartAxes alloc] initWithFrame:self.frame];
    [self addSubview:chartAxes];
}
//- (CGRect)getChartFrame{
//    
//    CGRect currentChartFrame;
//    
//    int maxValueX = self.frame.size.width;
//    int maxValueY = self.frame.size.height;
//    
//    for(QuartzLineGraph *currentLineGraph in currentChartArray){
//    
//        NSMutableArray *currentGraphDataArray = currentLineGraph.currentDataArray;
//        
//        for (NSValue *_currentValue in currentGraphDataArray)
//        {
//            
//            CGPoint currentValuePoint = [_currentValue CGPointValue];
//            
//            int currentValueY = currentValuePoint.y;
//            
//            if (currentValueY < maxValueY){
//                maxValueY = currentValueY;
//            }
//            
//            int currentValueX = currentValuePoint.x;
//            
//            if (currentValueX < maxValueX){
//                maxValueX = currentValueX;
//            }
//            
//        }
//        
//    } 
//    
//    currentChartFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxValueX, maxValueY);
//    
//    return currentChartFrame;
//}
- (void)loadRandomData {
    
    NSLog(@"Loading Random Data");
    
    [self loadRandomDataWithBounds:self.frame];
    
}
- (void)loadRandomDataWithBounds:(CGRect)bounds {
    
    for(QuartzLineGraph *currentLineGraph in currentChartArray){
        
        int currentArrayLength = [currentLineGraph.currentDataArray count];
        
        [currentLineGraph loadNewDataSet:[QuartzChart getRandomPoints:currentArrayLength withBounds:bounds]];
        
    }
    
}

@end
