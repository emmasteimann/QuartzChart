//
//  draw2D.m
//  testQuartz
//
//  Created by Emma Steimann on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestQuartzDrawing.h"

@implementation TestQuartzDrawing
{
    float i;
    NSTimer *timer;
    BOOL direction;
}
-(void)awakeFromNib{
    direction = false;
}
- (void)updateScreen:(id)sender  {
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    //NSLog(@"Resdisplayed");
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateScreen:) userInfo:nil repeats:NO];
    
    if(direction){
        i = i + .5;
        if (i > 30){
            //NSLog(@"****************flip********************");
            direction = false;
        }
    } else{
        i = i - .5;
        if (i < -30){
            direction = true;
        }
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetFillColorWithColor(context, color);
    
    CGContextMoveToPoint(context, 0, 350);
    CGContextAddLineToPoint(context, 20, 250);
    CGContextAddLineToPoint(context, 120, 150+i);
    CGContextAddLineToPoint(context, 200, 320-i);
    CGContextAddLineToPoint(context, 260, 250+i);
    CGContextAddLineToPoint(context, 400, 350);
    
    CGContextFillPath(context);
    
    
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}

@end
