//
//  LineGraph.m
//  testQuartz
//
//  Created by Emma Steimann on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuartzLineGraph.h"
#import "QuartzChartAxes.h"

@implementation QuartzLineGraph

@synthesize currentDataArray, initialDataArray, lineColor, replacmentDataArray, resolution, intervalOfTransition, withPoints, sizeOfPoints, isScatterPlot;

#pragma mark - Line Graph Instance Methods

- (id)initWithFrame:(CGRect)frame andDataSet:(NSArray *)dataset{
    
    return [self initWithFrame:frame andDataSet:dataset withAxes:NO];
    
}

- (id)initWithFrame:(CGRect)frame andDataSet:(NSArray *)dataset withAxes:(BOOL)_includeAxes{
        
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        if ([dataset count] > 0) {
            
            // Set Default Values 
            
            resolution = 60;
            intervalOfTransition = .02;
            withPoints = NO;
            lineColor = [self getRandomColor];
            sizeOfPoints = 5;
            isScatterPlot = NO;
            
            // Load arrays
            
            initialDataArray = dataset;
            currentDataArray = [[NSMutableArray alloc] initWithArray:initialDataArray];
                        
        }
    }
    
    return self;
}

- (void)loadNewDataSet:(NSMutableArray *)dataset{
    
    if ([dataset count] > 0) {
        
        replacmentDataArray = dataset;
        transitionCount = 0;
        transitionTimer = [NSTimer scheduledTimerWithTimeInterval:intervalOfTransition
                                                   target:self
                                                 selector:@selector(transitionPoints:)
                                                 userInfo:nil
                                                  repeats:YES];
        
    }
}

- (void)transitionPoints:(id)sender  {
    
    if (transitionCount >= resolution) {
        
        [transitionTimer invalidate];
        transitionTimer = nil;
        
    } else {
        
        transitionCount++;
        
        [replacmentDataArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            
            NSValue *currentDataPointValue = [replacmentDataArray
                                              objectAtIndex:idx];
            CGPoint currentDataPoint = [currentDataPointValue CGPointValue];
            
            NSValue *comparingDataPointValue = [currentDataArray objectAtIndex:idx];
            CGPoint comparingDataPoint = [comparingDataPointValue CGPointValue];
            
            int dx = currentDataPoint.y - comparingDataPoint.y;
            
            int transitionDx;
            
            if (dx == 0){
                transitionDx = 0;
            } else {
                transitionDx = dx/resolution;
                
                [currentDataArray replaceObjectAtIndex:idx withObject:[NSValue valueWithCGPoint:CGPointMake(comparingDataPoint.x, comparingDataPoint.y+transitionDx)]];
                
            }
                
        }];
        [self setNeedsDisplay];
    }
}

- (UIColor *) getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)drawRect:(CGRect)rect
{
    
    // Set up base line style
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, lineColor.CGColor);
    
    // Grab first point
    NSValue *initialDataFirstPoint = [currentDataArray objectAtIndex:0];
    CGPoint initialPoint = [initialDataFirstPoint CGPointValue];
    
    // Map the line 
    if (!isScatterPlot){
        // First Point
        
        CGContextMoveToPoint(context, self.frame.size.width-initialPoint.x, self.frame.size.height-initialPoint.y);
            
        [currentDataArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                        
            if (idx > 0) {
                
                NSValue *currentDataPointValue = [currentDataArray objectAtIndex:idx];
                CGPoint currentDataPoint = [currentDataPointValue CGPointValue];
                
                CGContextAddLineToPoint(context, self.frame.size.width-currentDataPoint.x, self.frame.size.height-currentDataPoint.y);
                
            }
             
        }];
        
        
        // Fill the line
        CGContextStrokePath(context);
        
    } else{
        withPoints = YES;
    }
    
    if (withPoints){
    
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        
        [currentDataArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                    
            if (idx > 0) {
                
                NSValue *currentDataPointValue = [currentDataArray objectAtIndex:idx];
                CGPoint currentDataPoint = [currentDataPointValue CGPointValue];
                
                CGRect outside = CGRectMake(self.frame.size.width-(currentDataPoint.x+(sizeOfPoints/2   )), self.frame.size.height-(currentDataPoint.y+(sizeOfPoints/2)), sizeOfPoints, sizeOfPoints);
                CGRect legend = CGRectInset(outside, 1, 1);
                CGContextFillEllipseInRect(context, legend);
                CGContextAddEllipseInRect(context, outside);
                CGContextStrokePath(context);
                
            }
            
        }];
    
    }
}

@end
