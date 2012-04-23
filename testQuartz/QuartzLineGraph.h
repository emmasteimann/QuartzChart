//
//  LineGraph.h
//  testQuartz
//
//  Created by Emma Steimann on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartzLineGraph : UIView
{
    @public
    UIColor *lineColor;
    int resolution;
    float intervalOfTransition;
    BOOL withPoints;
    float sizeOfPoints;
    BOOL isScatterPlot;
    NSMutableArray *currentDataArray;
    
    @private
    NSArray *initialDataArray;
    NSArray *replacmentDataArray;
    int transitionCount;
    NSTimer *transitionTimer;

}
	
@property (nonatomic, strong) NSArray *initialDataArray;
@property (nonatomic, readonly) NSMutableArray *currentDataArray;
@property (nonatomic, strong) NSArray *replacmentDataArray;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) int resolution;
@property (nonatomic, assign) float intervalOfTransition;
@property (nonatomic, assign) BOOL withPoints;
@property (nonatomic, assign) float sizeOfPoints;
@property (nonatomic, assign) BOOL isScatterPlot;

- (id)initWithFrame:(CGRect)frame andDataSet:(NSArray *)dataset;
- (void)loadNewDataSet:(NSArray *)dataset;
- (id)initWithFrame:(CGRect)frame andDataSet:(NSArray *)dataset withAxes:(BOOL)includeAxes;

@end

@interface QuartzLineGraph (private)

@property (nonatomic, readwrite) NSMutableArray *currentDataArray;

- (UIColor *) getRandomColor;

@end
