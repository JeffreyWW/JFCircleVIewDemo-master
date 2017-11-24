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
    self.navigationItem.title = @"JFCircleView";
    self.circleView.dataSource = self;
    self.circleView.delegate = self;
    ^(CALayer *insideContentViewLayer) {

    };
    NSLog(@"%@", NSStringFromCGRect(self.circleView.frame));
    [self.circleView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickBtCircle:(UIButton *)sender {
    self.circleView.circle = YES;
    [self.circleView reloadData];
}

- (IBAction)clickBtCanNotCircle:(UIButton *)sender {
    self.circleView.circle = NO;
    [self.circleView reloadData];
}

- (IBAction)clickBtAutoScroll:(UIButton *)sender {
    self.circleView.autoScroll = YES;
    [self.circleView reloadData];
}

- (IBAction)clickBtNotAutoScroll:(UIButton *)sender {
    self.circleView.autoScroll = NO;
    [self.circleView reloadData];
}

- (IBAction)clickBtScalType:(UIButton *)sender {
    self.circleView.scrollViewEdgInset = UIEdgeInsetsMake(8, 44, 8, 44);
    self.circleView.contentViewMulriple = 1.7;
    self.circleView.contentViewScaleDifferent = 0.2;
    [self.circleView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)circleViewContentViewNumber:(JFCircleView *)circleView {
    return 6;
}

- (UIView *)circleView:(JFCircleView *)circleView contentViewAtIndex:(NSInteger)index {
    JFInsideView *testView = [[NSBundle mainBundle] loadNibNamed:@"JFInsideView" owner:nil options:nil].firstObject;
    testView.layer.cornerRadius = 10.f;
    testView.layer.shadowColor = [UIColor blackColor].CGColor;
    testView.layer.shadowOpacity = 0.8f;
    testView.layer.shadowRadius = 2.f;
    testView.layer.shadowOffset = CGSizeMake(2, 2);
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
        testView.backgroundColor = [UIColor yellowColor];
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