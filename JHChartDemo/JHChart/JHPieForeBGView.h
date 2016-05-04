//
//  JHPieForeBGView.h
//  JHCALayer
//
//  Created by cjatech-简豪 on 16/4/28.
//  Copyright © 2016年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBlock)(CGFloat angle,CGPoint p);
@interface JHPieForeBGView : UIView


@property (copy, nonatomic) selectBlock select;


@end
