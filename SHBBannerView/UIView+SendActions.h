//
//  UIView+SendActions.h
//  SHBBannerView
//
//  Created by 沈红榜 on 2017/8/2.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SendActions)


- (BOOL)shb_sendActionWithName:(NSString *)actionName from:(UIView *)from;

@end
