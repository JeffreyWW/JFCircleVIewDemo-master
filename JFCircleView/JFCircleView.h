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

/**是否自动滑动,默认NO
 * YES情况下,若circle为NO,会在自动滑动到最后一页后瞬间回到第一页,不推荐在特殊样式情况下这样设置
 * 可以在全屏显示的时候使用此种情况
 * */
@property(nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;
/**是否可循环,默认YES*/
@property(nonatomic, assign, getter=isCircle) BOOL circle;

#pragma mark - 特殊样式
/**ScrollView距离父视图的边距*/
@property(nonatomic, assign) UIEdgeInsets scrollViewEdgInset;
/**scrollView内部contentView的高度始终会和ScrollView本身高度相同
 * 但宽度会根据这个值来确定,该值相当于内部contentView宽高比,若不设置,它会和ScrollView的宽高比相同*/
@property(nonatomic, assign) CGFloat contentViewMulriple;
/**效果参数,中间视图高度为原始值,其他的纵向会根据此值来进行缩放
 * 例:contentViewScaleDifferent为0.2,那么其他视图高度缩放为0.8*/
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