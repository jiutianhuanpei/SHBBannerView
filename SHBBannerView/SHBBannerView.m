//
//  SHBBannerView.m
//  ServerDemo
//
//  Created by 沈红榜 on 2017/8/2.
//  Copyright © 2017年 沈红榜. All rights reserved.
//

#import "SHBBannerView.h"
#import "UIImageView+WebCache.h"
#import "UIView+SendActions.h"

@interface _AdItem : UICollectionViewCell

@property (nonatomic, strong) id obj;   //用于记录点击触发的model

@property (nonatomic, strong) UIImageView   *imgView;

@end

@implementation _AdItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_imgView];
    }
    return self;
}

@end

@interface SHBBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *urlStrings;

@property (nonatomic, strong) UICollectionView *colView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSURL *(^fetchUrlFromModel)(id model);


@end

NSInteger _Times = 50;  //重复遍数，越大越不容易手动滑到边界

@implementation SHBBannerView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.colView];
        _autoPlay = true;
    }
    return self;
}

- (void)configModel:(NSArray *)models modelToImageLinkRelationship:(NSURL *(^)(id))relationship {
    _urlStrings = models;
    _fetchUrlFromModel = relationship;
    
    if (_urlStrings.count > 1 ) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(_scrollNextImage:) userInfo:nil repeats:true];
    }
    
    [self.colView setContentOffset:CGPointMake(CGRectGetWidth(self.frame) * ((models.count * _Times + 2) / 2), 0)];
}

- (void)_scrollNextImage:(NSTimer *)timer {
    
    if (!_autoPlay) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    NSIndexPath *nowIndex = [_colView.indexPathsForVisibleItems firstObject];
    NSInteger beginIndex = (_urlStrings.count * _Times + 2) / 2;
    
    NSInteger totalCount = _urlStrings.count *_Times + 2;
    
    if (_scrollDirection == SHBBannerViewScrollDirectionLeft) {
        if (nowIndex.item == totalCount - 2) {
            
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
        } else if (nowIndex.item == totalCount - 1) {
            //如果手动滑到最后一张，防止崩溃
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
        } else {
            
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nowIndex.item + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
        }
    } else {
        
        if (nowIndex.item == 0) {
            
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
            
        } else if (nowIndex.item == 1) {
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:beginIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
        } else {
            [_colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nowIndex.item - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:true];
        }
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //保证无限循环
    NSIndexPath *currentIndexPath = [_colView.indexPathsForVisibleItems firstObject];
    
    if (currentIndexPath.item == 0) {
        
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:_urlStrings.count inSection:0];
        [_colView scrollToItemAtIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
        
    } else if (currentIndexPath.item == _urlStrings.count + 1) {
        
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [_colView scrollToItemAtIndexPath:toIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    }
    
    if (_autoPlay && _urlStrings.count > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(_scrollNextImage:) userInfo:nil repeats:true];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_autoPlay && _timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _AdItem *item = (_AdItem *)[collectionView cellForItemAtIndexPath:indexPath];
    _selectObj = item.obj;
    
    [self shb_sendActionWithName:@"clickedBanner:" from:self];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _AdItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([_AdItem class]) forIndexPath:indexPath];
    
    id currentObj = nil;
    
    if (indexPath.item == 0) {
        currentObj = _urlStrings.lastObject;
    } else {
        currentObj = _urlStrings[(indexPath.item - 1) % _urlStrings.count];
    }
    
    item.obj = currentObj;
    
    NSURL *url = self.fetchUrlFromModel(currentObj);
        
    [item.imgView sd_setImageWithURL:url];
    return item;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_urlStrings.count == 1) {
        //一个不滚动
        return 1;
    }
    
    return _urlStrings.count * _Times + 2;
}


#pragma mark - getter
- (UICollectionView *)colView {
    if (!_colView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        
        _colView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _colView.backgroundColor = [UIColor whiteColor];
        _colView.pagingEnabled = true;
        _colView.showsHorizontalScrollIndicator = false;
        _colView.delegate = self;
        _colView.dataSource = self;
        [_colView registerClass:[_AdItem class] forCellWithReuseIdentifier:NSStringFromClass([_AdItem class])];
    }
    return _colView;
}

- (NSTimeInterval)timeInterval {
    if (_timeInterval <= 0) {
        return 4;
    }
    return _timeInterval;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
