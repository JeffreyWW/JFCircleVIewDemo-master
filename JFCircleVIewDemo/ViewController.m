//
//  ViewController.m
//  PageViewTest
//
//  Created by Jeffrey on 2017/11/12.
//  Copyright © 2017 Jeffrey. All rights reserved.
//

#import "ViewController.h"
#import "JFInsideView.h"


@interface ViewController ()
@property(nonatomic, weak) IBOutlet JFCircleView *circleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.circleView.dataSource = self;
    self.circleView.delegate = self;
    self.circleView.scrollViewEdgInset = UIEdgeInsetsMake(8, 44, 8, 44);
    self.circleView.contentViewMulriple = 1.7;
    self.circleView.contentViewScaleDifferent = 0.2;
    self.circleView.autoScroll = NO;
//    self.circleView.circle = NO;
    [self.circleView layoutIfNeeded];
    NSLog(@"%@", NSStringFromCGRect(self.circleView.frame));
    [self.circleView reloadData];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)circleViewContentViewNumber:(JFCircleView *)circleView {
    return 3;
}

- (UIView *)circleView:(JFCircleView *)circleView contentViewAtIndex:(NSInteger)index {
    JFInsideView *testView = [[NSBundle mainBundle] loadNibNamed:@"JFInsideView" owner:nil options:nil].firstObject;
    testView.lbTest.text = [NSString stringWithFormat:@"%d", index + 1];
    if (index == 0) {
        testView.backgroundColor = [UIColor grayColor];
    }

    if (index == 1) {
        testView.backgroundColor = [UIColor greenColor];
    }
    if (index == 2) {
        testView.backgroundColor = [UIColor redColor];
    }
    if (index == 3) {
        testView.backgroundColor = [UIColor darkGrayColor];
    }
    if (index == 4) {
        testView.backgroundColor = [UIColor blackColor];
    }
    if (index == 5) {
        testView.backgroundColor = [UIColor blueColor];
    }
    if (index == 6) {
        testView.backgroundColor = [UIColor brownColor];
    }

    return testView;
}

- (void)circleView:(JFCircleView *)circleView clickIndex:(NSInteger)index {
    NSLog([NSString stringWithFormat:@"点击了下标:%d", index]);
}


@end