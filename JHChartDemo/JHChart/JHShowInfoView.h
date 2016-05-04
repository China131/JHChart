//
//  JHShowInfoView.h
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/4.
//  Copyright © 2016年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHShowInfoView : UIView



@property (copy, nonatomic) NSString * showContentString;


- (void)updateFrameTo:(CGRect)frame andBGColor:(UIColor *)bgColor andShowContentString:(NSString *)contentString;

@end
