//
//  LoadGraph.h
//  testQuartz
//
//  Created by Emma Steimann on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzChart.h"

@interface LoadGraph : UIView {
    
    @private
    NSTimer *timer;
    QuartzChart *quartzChart;
    
}

@end