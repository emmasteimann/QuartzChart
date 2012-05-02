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

@synthesize currentDataArray, initialDataArray, lineColor, replacmentDataArray, resolution, intervalOfTransition, withPoints, sizeOfPoints, isScatterPlot, paddingInside, paddingAmount;

#pragma mark - Line Graph Instance Methods

- (id)initWithFrame:(CGRect)frame andDataSet:(NSArray *)dataset{
    
    return [self initWithFrame:frame andDataSet:dataset withAxes:NO];
    
}

- (id)initWithFrame:(CGRect)frame andDataSet:(NSArray *)dataset withAxes:(BOOL)_includeAxes{
        
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        NSLog(@"**************INIT METHOD LAUNCHED****************");
        
        if ([dataset count] > 0) {
            
            // Set Default Values 
            
            resolution = 60;
            intervalOfTransition = .02;
            withPoints = NO;
            lineColor = [[UIColor alloc] initWithCGColor:[QuartzLineGraph getRandomColor]];
            sizeOfPoints = 5;
            isScatterPlot = NO;
            paddingAmount = 10; 
            
            // Load arrays
            
            initialDataArray = dataset;
            replacmentDataArray = [[NSMutableArray alloc] init];
            currentDataArray = [[NSMutableArray alloc] initWithArray:initialDataArray];
            
            CGRect initialFrame = self.frame;
            
            paddingInside = CGRectMake(initialFrame.origin.x, initialFrame.origin.y, initialFrame.size.width, initialFrame.size.height);
            
            [self setFrame:CGRectMake(initialFrame.origin.x-paddingAmount, initialFrame.origin.y-paddingAmount, initialFrame.size.width+(paddingAmount*2), initialFrame.size.height+(paddingAmount*2))];
            
            [self setClipsToBounds: NO];
        }
    }
    
    return self;
}

- (void)loadNewDataSet:(NSMutableArray *)dataset{
    
    NSLog(@"Loading new dataset");
    
    if ([dataset count] > 0) {
        [replacmentDataArray removeAllObjects];
        [replacmentDataArray addObjectsFromArray:dataset];
        //[replacmentDataArray addObjectsFromArray:dataset];
        //replacmentDataArray = dataset;
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
            
            NSValue *currentDataPointValue = [replacmentDataArray objectAtIndex:idx];
            CGPoint currentDataPoint = [currentDataPointValue CGPointValue];
            
            NSValue *comparingDataPointValue = [currentDataArray objectAtIndex:idx];
            CGPoint comparingDataPoint = [comparingDataPointValue CGPointValue];
            
            int dx = currentDataPoint.y - comparingDataPoint.y;
            
            int transitionDx;
            
            if (dx == 0){
                
            } else {
                transitionDx = dx/resolution;
                
                [currentDataArray replaceObjectAtIndex:idx withObject:[NSValue valueWithCGPoint:CGPointMake(comparingDataPoint.x, comparingDataPoint.y+transitionDx)]];
                
            }

        }];
        [self setNeedsDisplay];
    }
}

+ (CGColorRef) getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1].CGColor;
}

- (void)drawRect:(CGRect)rect
{
    
    // Set up base line style
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, lineColor.CGColor);
    
    // Grab first point
    NSValue *initialDataFirstPoint = [currentDataArray objectAtIndex:0];
    CGPoint initialPoint = [initialDataFirstPoint CGPointValue];
    
    // Map the line 
    if (!isScatterPlot){
        // First Point
        CGRect outside = CGRectMake(paddingAmount + (initialPoint.x-(sizeOfPoints/2)), paddingInside.size.height-(initialPoint.y+(sizeOfPoints/2)), sizeOfPoints, sizeOfPoints);
        CGRect legend = CGRectInset(outside, 1, 1);
        
        CGContextFillEllipseInRect(context, legend);
        CGContextAddEllipseInRect(context, outside);
        CGContextStrokePath(context);
        
        CGContextMoveToPoint(context, paddingAmount + initialPoint.x, paddingInside.size.height-initialPoint.y);
        
        [currentDataArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                    
            __block NSValue *currentDataPointValue = [currentDataArray objectAtIndex:idx];
            __block CGPoint currentDataPoint = [currentDataPointValue CGPointValue];
            
            // Draw Second through Final point
            if (idx > 0) {
                
                CGContextAddLineToPoint(context, paddingAmount + currentDataPoint.x, paddingInside.size.height-currentDataPoint.y);
                
            }
            
            if (idx == ([currentDataArray count] - 1))
            {
                CGContextStrokePath(context);
                
                CGRect outside = CGRectMake(paddingAmount + (currentDataPoint.x-(sizeOfPoints/2)), paddingInside.size.height-(currentDataPoint.y+(sizeOfPoints/2)), sizeOfPoints, sizeOfPoints);
                CGRect legend = CGRectInset(outside, 1, 1);
                CGContextFillEllipseInRect(context, legend);
                CGContextAddEllipseInRect(context, outside);
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
                
                CGRect outside = CGRectMake(paddingAmount + (currentDataPoint.x-(sizeOfPoints/2)), paddingInside.size.height-(currentDataPoint.y+(sizeOfPoints/2)), sizeOfPoints, sizeOfPoints);
                CGRect legend = CGRectInset(outside, 1, 1);
                CGContextFillEllipseInRect(context, legend);
                CGContextAddEllipseInRect(context, outside);
                CGContextStrokePath(context);
                
            }
            
        }];
    
    }
}
@end
