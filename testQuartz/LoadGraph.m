//
//  LoadGraph.m
//  testQuartz
//
//  Created by Emma Steimann on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadGraph.h"
#import "QuartzChart.h"
#import "QuartzLineGraph.h"

@implementation LoadGraph

-(void)awakeFromNib {
    
    int chartWidth = 300; 
    int chartHeight = 300; 
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    
    quartzChart = [QuartzChart createRandomCharts:3 withPoints:20 withBounds:CGRectMake(0, 0, chartWidth, chartHeight)];
    
    [quartzChart setFrame:CGRectMake((mainScreenFrame.size.width - chartWidth)/2,(mainScreenFrame.size.height - chartHeight)/2, chartWidth, chartHeight)];
    
    NSArray *chartArray = quartzChart.currentChartArray;
    
    QuartzLineGraph *itemAtIndexOne = [chartArray objectAtIndex:1];
    QuartzLineGraph *itemAtIndexTwo = [chartArray objectAtIndex:2];
    
    itemAtIndexOne.isScatterPlot = YES;
    itemAtIndexTwo.withPoints = YES;
    
    [self addSubview:quartzChart];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateScreen:) userInfo:nil repeats:YES];
    
}
- (void)updateScreen:(id)sender  {
    [quartzChart loadRandomData];
//    [thirdLineGraph loadNewDataSet:[QuartzChart getRandomPoints:20]];
//    [secondLineGraph loadNewDataSet:[QuartzChart getRandomPoints:20]];
//    [linegraph loadNewDataSet:[QuartzChart getRandomPoints:20]];

}

@end
