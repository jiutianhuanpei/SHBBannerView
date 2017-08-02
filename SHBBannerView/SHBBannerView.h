//
//  SHBBannerView.h
//  ServerDemo
//
//  Created by 沈红榜 on 2017/8/2.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SHBBannerViewScrollDirection) {
    SHBBannerViewScrollDirectionLeft,
    SHBBannerViewScrollDirectionRight,
};

@interface SHBBannerView : UIView

@property (nonatomic, assign) SHBBannerViewScrollDirection scrollDirection; //自动滚动方向
@property (nonatomic, assign) BOOL autoPlay;    //自动播放 默认：true
@property (nonatomic, assign) NSTimeInterval timeInterval;  //自动播放的间隔时间 默认：4s

/*
    点击banner时，触发的对应的model
    实现方法： - (void)clickedBanner:(SHBBannerView *)sender 以获取该值
*/
@property (nonatomic, strong, readonly) id selectObj;   //点击触发的model

- (void)configModel:(NSArray *)models modelToImageLinkRelationship:(NSURL *(^)(id model))relationship;
@end
