//
//  SHCircleView.m
//  PageViewTest
//
//  Created by Jeffrey on 2017/11/12.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import "JFCircleView.h"
#import "Masonry.h"

@interface JFCircleView ()
@property(nonatomic, strong) NSMutableArray *contentViews;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, assign) NSUInteger maxNumber;
@property(nonatomic, assign) NSUInteger realMaxNumber;


@end

@implementation JFCircleView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self defaultSet];
        self.contentViews = [NSMutableArray array];
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        /**改变手势,让self控制ScrollView的手势*/
        NSArray *ges = self.scrollView.gestureRecognizers;
        for (NSUInteger i = 0; i < 4; i++) {
            UIGestureRecognizer *gestureRecognizer = ges[i];
            if (i != 3) {
                [self addGestureRecognizer:gestureRecognizer];
            }
        }
        self.scrollView.clipsToBounds = NO;
        self.layer.masksToBounds = YES;
    }
    return self;
}

/**默认常规属性设置*/
- (void)defaultSet {
    self.autoScroll = NO;
    self.circle = YES;
}

- (NSUInteger)maxNumber {
    return [self.dataSource circleViewContentViewNumber:self];
}

- (NSUInteger)realMaxNumber {
    return self.isCircle ? self.maxNumber + 4 : self.maxNumber;
}

- (void)reloadData {
    /**停止计时*/
    [self timerStop];
    /**重置视图*/
    [self reSetViews];
    /**生成一个scrollView下整个scrollViewContentView并布局*/
    UIView *scrollViewContentView = [self scrollViewContentViewLayout];
    /**设置scrollViewContentView内部*/
    [self setupInsideWithScrollViewContentView:scrollViewContentView];
    /**刷新*/
    [self layoutIfNeeded];
    /**开始计时*/
    [self timerStart];
    CGPoint defaultOffset = self.isCircle ? CGPointMake(self.scrollView.frame.size.width * 2, 0) : CGPointZero;
    /**如果是循环的,那么默认偏移到第三张图*/
    [self.scrollView setContentOffset:defaultOffset animated:NO];
}

- (void)reSetViews {
    /**移除所有字视图,重新布局*/
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    /**同时移除掉保存的子视图*/
    [self.contentViews removeAllObjects];
}

/**ScrollView的整个子contentView的布局*/
- (UIView *)scrollViewContentViewLayout {
    __weak typeof(self) weakSelf = self;
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(self.scrollViewEdgInset);
    }];
    UIView *scrollViewContentView = [[UIView alloc] init];
    [self.scrollView addSubview:scrollViewContentView];
    /**ScrollView的整个contentView贴边布局*/
    [scrollViewContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        /**滑动方向单位,即滑动方向的长度,类似横向滑动即屏宽,纵向则屏高*/
        make.width.equalTo(weakSelf.scrollView).multipliedBy(self.realMaxNumber);
        /**静止方向的单位,即不能滑动的方向的长度*/
        make.height.equalTo(weakSelf.scrollView);
    }];
    return scrollViewContentView;
}

/**scrollViewContentView内部设置*/
- (void)setupInsideWithScrollViewContentView:(UIView *)scrollViewContentView {
    /**开始添加子视图,先计算对应的外部实际下标*/
    for (NSUInteger index = 0; index < self.realMaxNumber; index++) {
        /**获取实际的外部下标*/
        NSUInteger outSideIndex = [self getOutSideIndexWithIndex:index];
        /**根据外部下标拿到外部方法生成的view作为insideContentView*/
        UIView *insideContentView = [self.dataSource circleView:self contentViewAtIndex:outSideIndex];
        [self.contentViews addObject:insideContentView];
        [scrollViewContentView addSubview:insideContentView];
        /**内部的contentView布局*/
        [self insideContentViewLayout:insideContentView index:index];
        /**添加手势*/
        [self addTapGestureRecognizerToInsideContentView:insideContentView outsideIndex:outSideIndex];
        /**默认的动画显示*/
        NSUInteger scaleIndex = self.circle ? 2 : 0;
        CGFloat scaleY = index == scaleIndex ? 1.0f : 1.0f - self.contentViewScaleDifferent;
        insideContentView.transform = CGAffineTransformMakeScale(1, scaleY);
    }
}

/**根据传入的index来获取实际对应的外部index*/
- (NSUInteger)getOutSideIndexWithIndex:(NSUInteger)index {
    NSInteger finalIndex = 0;
    /**如果不是循环的,直接对应外部index即可*/
    if (!self.isCircle) {
        return index;
    }
    /**第一张为倒数实际第二张,第二张为实际最后一张*/
    if (index <= 1) {
        finalIndex = self.maxNumber - 2 + index;
        /**最后两张前一张为第一张,最后一张为第二张*/
    } else if (index >= self.realMaxNumber - 2) {
        finalIndex = index - (self.realMaxNumber - 2);
    } else {
        /**其他情况则直接减去2,和实际相符即可,*/
        finalIndex = index - 2;
    }
    /**处理只有个视图的情况*/
    if (finalIndex < 0 || finalIndex >= self.maxNumber) {
        finalIndex = 0;
    }
    return (NSUInteger) finalIndex;
}

/**每部每个contentView根据下标来布局*/
- (void)insideContentViewLayout:(UIView *)insideContentView index:(NSUInteger)index {
    __weak typeof(self) weakSelf = self;
    [insideContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.scrollView);
        if (self.contentViewMulriple) {
            make.width.equalTo(weakSelf.scrollView.mas_height).multipliedBy(self.contentViewMulriple);
        } else {
            make.width.equalTo(weakSelf.scrollView.mas_width);
        }
        make.centerY.equalTo(weakSelf.scrollView);
        make.centerX.equalTo(weakSelf.scrollView).multipliedBy(2 * index + 1);
    }];
}

/**添加手势*/
- (void)addTapGestureRecognizerToInsideContentView:(UIView *)insideContentView outsideIndex:(NSUInteger)outsideIndex {
    if ([self.delegate respondsToSelector:@selector(circleView:clickIndex:)]) {
        insideContentView.tag = outsideIndex;
        insideContentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentView:)];
        tapGestureRecognizer.delegate = self;
        [insideContentView addGestureRecognizer:tapGestureRecognizer];
    }
}


/**处理手势冲突*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/**点击内容*/
- (void)clickContentView:(UITapGestureRecognizer *)tapGestureRecognizer {
    NSUInteger index = (NSUInteger) tapGestureRecognizer.view.tag;
    [self.delegate circleView:self clickIndex:index];
}

#pragma mark - 计时相关

/**计时器开始*/
- (void)timerStart {
    if (self.autoScroll) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
}

/**计时器停止*/
- (void)timerStop {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)dealloc {
    [self timerStop];
}

#pragma mark - 滑动相关

/**下一页*/
- (void)nextPage {
    CGFloat offsetXWillBe = self.scrollView.contentOffset.x + self.scrollView.frame.size.width;
    /**是否超过了最后一页*/
    BOOL overScroll = offsetXWillBe > self.scrollView.frame.size.width * (self.contentViews.count - 1);
    BOOL animate = YES;
    if (!self.circle && overScroll) {
        offsetXWillBe = 0;
        animate = NO;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetXWillBe, 0) animated:animate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    /**移动完后的偏移量*/
    CGFloat currentOffSet = scrollView.contentOffset.x;
    if (self.contentViewScaleDifferent) {
        for (NSUInteger contentViewIndex = 0; contentViewIndex < self.contentViews.count; contentViewIndex++) {
            UIView *contentView = self.contentViews[contentViewIndex];
            /**最大的时候偏移量应该是*/
            CGFloat contentOffSetBalance = scrollView.frame.size.width * contentViewIndex;
            /**移动完偏移量和最大偏移的绝对值*/
            CGFloat contentOffSetDifferent = fabsf(contentOffSetBalance - currentOffSet);
            contentView.transform = CGAffineTransformMakeScale(1.0f, (CGFloat) (1.0 - self.contentViewScaleDifferent * (contentOffSetDifferent / scrollView.frame.size.width)));
        }
    }
    if (!self.circle) {
        return;
    }
    if (currentOffSet <= scrollView.frame.size.width) {
        NSLog(@"最小");
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * (self.maxNumber + 1), 0) animated:NO];
    } else if (currentOffSet >= scrollView.frame.size.width * (self.maxNumber + 2)) {
        NSLog(@"最大");
        [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * 2, 0) animated:NO];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self timerStart];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self timerStop];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
