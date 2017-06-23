//
//  JHPieForeBGView.m
//  JHCALayer
//
//  Created by 简豪 on 16/4/28.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHPieForeBGView.h"

@implementation JHPieForeBGView

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self touchesBegan:touches withEvent:event];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint p = [touch locationInView:self];
    
    
    
    if ((p.x-self.frame.size.width/2)*(p.x-self.frame.size.width/2) + (p.y-self.frame.size.height/2)*(p.y-self.frame.size.height/2) >self.frame.size.height*self.frame.size.height) {
        return;
    }
    
    
    /* 计算角度并block回调 */
    CGFloat aLen2 = (p.x - self.frame.size.width/2)*(p.x - self.frame.size.width/2) + (p.y - self.frame.size.width/2)*(p.y - self.frame.size.width/2);
    CGFloat aLen = sqrt(aLen2);
    
    CGFloat cLen2 =self.frame.size.width/2 * self.frame.size.width/2;
    CGFloat cLen = self.frame.size.width/2;
    
    CGFloat bLen2 = (p.x - self.frame.size.width)*(p.x - self.frame.size.width) + (p.y - self.frame.size.width/2)*(p.y - self.frame.size.width/2);

    
    CGFloat angle = acos((aLen2 + cLen2 -bLen2)/2/aLen/cLen);
    
    if (p.y<self.frame.size.height/2) {
        angle = M_PI*2 -angle;
        
    }
    if (self.select) {
        self.select(angle,p);
    }
    
}



@end
