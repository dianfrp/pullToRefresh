//
//  PullToRefreshManager.h
//  PullToRefresh
//
//  Created by KTW on 11/01/2019.
//  Copyright © 2019 KTW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullToRefreshManagerDelegate
@required
- (void)doHandleRefreshing;
@end

@interface PullToRefreshManager : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)aScrollView scrollDelegate:(id<UIScrollViewDelegate>)aScrollDelegate NS_DESIGNATED_INITIALIZER;

@property (weak, nonatomic) id<PullToRefreshManagerDelegate> delegate;

- (void)endRefreshing;

@end
