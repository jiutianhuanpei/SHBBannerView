//
//  UIView+SendActions.m
//  SHBBannerView
//
//  Created by 沈红榜 on 2017/8/2.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "UIView+SendActions.h"

@implementation UIView (SendActions)

- (BOOL)shb_sendActionWithName:(NSString *)actionName from:(UIView *)from {
    id target = from;
    SEL action = NSSelectorFromString(actionName);
    
    while (target && ![target canPerformAction:action withSender:target]) {
        target = [target nextResponder];
    }
    
    if (target) {
        return [[UIApplication sharedApplication] sendAction:action to:target from:from forEvent:nil];
    }
    return false;
}

@end
