//
//  SHCircleView.h
//  PageViewTest
//
//  Created by Jeffrey on 2017/11/12.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHCircleViewDataSource;
@protocol SHCircleViewDelegate;


@interface JFCircleView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, weak) id <SHCircleViewDataSource> dataSource;
@property(nonatomic, weak) id <SHCircleViewDelegate> delegate;
/**是否自动滑动,默认NO*/
@property(nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;
/**是否可循环,默认YES*/
@property(nonatomic, assign, getter=isCircle) BOOL circle;


@property(nonatomic, assign) UIEdgeInsets scrollViewEdgInset;
@property(nonatomic, assign) CGFloat contentViewMulriple;
@property(nonatomic, assign) CGFloat contentViewScaleDifferent;

- (void)reloadData;
@end

/**数据源协议*/
@protocol SHCircleViewDataSource <NSObject>
@required
/**内容个数*/
- (NSUInteger)circleViewContentViewNumber:(JFCircleView *)circleView;

/**
 * 返回显示的视图
 * @param circleView 哪个circleView
 * @param index 下标,类似TableView的indexPath
 * @return 显示的视图
 */
- (UIView *)circleView:(JFCircleView *)circleView contentViewAtIndex:(NSInteger)index;
@end

/**代理*/
@protocol SHCircleViewDelegate <NSObject>
@optional
- (void)circleView:(JFCircleView *)circleView clickIndex:(NSInteger)index;
@end