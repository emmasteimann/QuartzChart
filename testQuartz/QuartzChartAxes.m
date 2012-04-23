//
//  ChartAxes.m
//  testQuartz
//
//  Created by Emma Steimann on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzChartAxes.h"

@implementation QuartzChartAxes
{
    CGRect chartFrame; 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    if (self) {
        
        chartFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    NSLog(@"Haight of Axis: %f", chartFrame.origin.y+chartFrame.size.height);
    
    CGContextMoveToPoint(context, chartFrame.origin.x, chartFrame.origin.y);
    CGContextAddLineToPoint(context, chartFrame.origin.x, chartFrame.origin.y+chartFrame.size.height);
    CGContextStrokePath(context);
    
    
    CGContextSetLineWidth(context, 4.0);
    CGContextMoveToPoint(context, chartFrame.origin.x, chartFrame.origin.y+chartFrame.size.height);
    CGContextAddLineToPoint(context, chartFrame.origin.x+chartFrame.size.width, chartFrame.origin.y+chartFrame.size.height);
    CGContextStrokePath(context);
}

@end
