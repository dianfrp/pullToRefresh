//
//  PullToRefreshManager.m
//  PullToRefresh
//
//  Created by KTW on 11/01/2019.
//  Copyright © 2019 KTW. All rights reserved.
//

#import "PullToRefreshManager.h"

@interface PullToRefreshManager () <UIScrollViewDelegate>

@property (weak, nonatomic) id<UIScrollViewDelegate> scrollDelegate;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshBackgroundView;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIImageView *backGroundLoadingImageView;
@property (nonatomic, strong) UIImageView *tempLodingImageView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, readwrite) BOOL isRefreshAnimating;

@property (nonatomic, readwrite) BOOL isActiveRefresh;

@end

@implementation PullToRefreshManager

- (instancetype)initWithScrollView:(UIScrollView *)aScrollView scrollDelegate:(id<UIScrollViewDelegate>)aScrollDelegate
{
    self = [super init];
    if (self) {
        _scrollView = aScrollView;
        _scrollDelegate = aScrollDelegate;
        _isActiveRefresh = YES;
        _isRefreshAnimating = NO;
        [self setUpViews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithScrollView:nil scrollDelegate:self];
}

- (void)setUpViews
{
    [self setUpRefreshBackGroundView];
    [self setUpRefreshLoadingView];
    [self setUpRefreshControl];
    
    [_scrollView setDelegate:self];
    [_scrollView addSubview:_refreshControl];
    
    
}


- (void)setUpRefreshBackGroundView
{
    _refreshBackgroundView = [[UIView alloc] init];
    [_refreshBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_refreshBackgroundView setBackgroundColor:[UIColor clearColor]];
    
    _backGroundLoadingImageView = [[UIImageView alloc] init];
    [_backGroundLoadingImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_backGroundLoadingImageView setImage:[UIImage imageNamed:@"loding_cir_wt"]];
    
    [_refreshBackgroundView addSubview:_backGroundLoadingImageView];
    
    [[_backGroundLoadingImageView.centerXAnchor constraintEqualToAnchor:_refreshBackgroundView.centerXAnchor] setActive:YES];
    [[_backGroundLoadingImageView.centerYAnchor constraintEqualToAnchor:_refreshBackgroundView.centerYAnchor] setActive:YES];
    
    [_refreshBackgroundView setHidden:YES];
    
}

- (void)setUpRefreshLoadingView
{
    _refreshLoadingView = [[UIView alloc] init];
    [_refreshLoadingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_refreshLoadingView setBackgroundColor:[UIColor clearColor]];
    [_refreshLoadingView setClipsToBounds:YES];
    
    _loadingImageView = [[UIImageView alloc] init];
    [_loadingImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_loadingImageView setImage:[UIImage imageNamed:@"loading_line"]];
    
    _tempLodingImageView = [[UIImageView alloc] init];
    [_tempLodingImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_tempLodingImageView setImage:[UIImage imageNamed:@"loading_line"]];
    
    [_refreshLoadingView addSubview:_loadingImageView];
    [_refreshLoadingView addSubview:_tempLodingImageView];
    
    [[_loadingImageView.centerXAnchor constraintEqualToAnchor:_refreshLoadingView.centerXAnchor] setActive:YES];
    [[_loadingImageView.centerYAnchor constraintEqualToAnchor:_refreshLoadingView.centerYAnchor] setActive:YES];
    [[_tempLodingImageView.centerXAnchor constraintEqualToAnchor:_refreshLoadingView.centerXAnchor] setActive:YES];
    [[_tempLodingImageView.centerYAnchor constraintEqualToAnchor:_refreshLoadingView.centerYAnchor] setActive:YES];
    
    [_tempLodingImageView setHidden:YES];
    [_loadingImageView setHidden:YES];
    
}

- (void)setUpRefreshControl
{
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setTintColor:[UIColor clearColor]];
    [_refreshControl addSubview:_refreshBackgroundView];
    [_refreshControl addSubview:_refreshLoadingView];
    
    [[_refreshBackgroundView.topAnchor constraintEqualToAnchor:_refreshControl.topAnchor] setActive:YES];
    [[_refreshBackgroundView.leadingAnchor constraintEqualToAnchor:_refreshControl.leadingAnchor] setActive:YES];
    [[_refreshBackgroundView.trailingAnchor constraintEqualToAnchor:_refreshControl.trailingAnchor] setActive:YES];
    [[_refreshBackgroundView.bottomAnchor constraintEqualToAnchor:_refreshControl.bottomAnchor] setActive:YES];
    
    [[_refreshLoadingView.topAnchor constraintEqualToAnchor:_refreshControl.topAnchor] setActive:YES];
    [[_refreshLoadingView.leadingAnchor constraintEqualToAnchor:_refreshControl.leadingAnchor] setActive:YES];
    [[_refreshLoadingView.trailingAnchor constraintEqualToAnchor:_refreshControl.trailingAnchor] setActive:YES];
    [[_refreshLoadingView.bottomAnchor constraintEqualToAnchor:_refreshControl.bottomAnchor] setActive:YES];
    
    [_refreshControl addTarget:self action:@selector(doHandleRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.scrollDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.scrollDelegate respondsToSelector:aSelector]) {
        return self.scrollDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)doHandleRefresh:(UIRefreshControl *)sender
{
    if (_delegate != nil) {
        [_delegate doHandleRefreshing];
    }
}

- (void)endRefreshing
{
    [_refreshControl endRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self doRefresh:scrollView];
    
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset == 0) {
        [self stopAnimation];
    }
    
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset == 0) {
        [self stopAnimation];
    }
    
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self stopAnimation];

    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.scrollDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self stopAnimation];
    
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        [self.scrollDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)doRefresh:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset > 0) {
        _isActiveRefresh = NO;
        [_refreshBackgroundView setHidden:YES];
        [_tempLodingImageView setHidden:YES];
        [_loadingImageView setHidden:YES];
    }
    
    if (!_isActiveRefresh && !_isRefreshAnimating) {
        return;
    }
    
    
    CGFloat pullDistance = MAX(0.0, - _refreshControl.frame.origin.y);
    
    if (!_refreshControl.isRefreshing && !_isRefreshAnimating) {
        [_refreshBackgroundView setHidden:NO];
        [_tempLodingImageView setHidden:NO];
        [self animationRefreshing:pullDistance];
    }
    
    if (_refreshControl.isRefreshing && !_isRefreshAnimating) {
        _isRefreshAnimating = YES;
        _isActiveRefresh = NO;
        [_tempLodingImageView setHidden:YES];
        [_loadingImageView setHidden:NO];
        [self animationRefreshView];
    }
}

- (void)animationRefreshing:(CGFloat)pullDistance
{
    [_tempLodingImageView setTransform:CGAffineTransformRotate(_refreshLoadingView.transform, M_PI_2 * (pullDistance / 42))];
}


- (void)animationRefreshView
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.loadingImageView setTransform:CGAffineTransformRotate(self.loadingImageView.transform, M_PI_2)];
                     } completion:^(BOOL finished) {
                         if (self.refreshControl.isRefreshing) {
                             [self animationRefreshView];
                         } else {
                             [self.refreshBackgroundView setHidden:YES];
                             [self.loadingImageView setHidden:YES];
                         }
                     }];
}

- (void)stopAnimation
{
    _isActiveRefresh = YES;
    _isRefreshAnimating = NO;
    [_loadingImageView setTransform:CGAffineTransformRotate(_refreshLoadingView.transform, 0)];
}

@end

