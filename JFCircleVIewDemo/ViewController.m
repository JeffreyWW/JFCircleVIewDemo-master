//
//  ViewController.m
//  PageViewTest
//
//  Created by Jeffrey on 2017/11/12.
//  Copyright © 2017 Jeffrey. All rights reserved.
//

#import "ViewController.h"
#import "JFBannerModel.h"
#import "Masonry.h"

@interface ViewController ()
@property(nonatomic, weak) IBOutlet JFCircleView *circleView;
@property(nonatomic, copy) NSArray *models;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModels];
    self.navigationItem.title = @"JFCircleView";
    self.circleView.dataSource = self;
    self.circleView.delegate = self;
    NSLog(@"%@", NSStringFromCGRect(self.circleView.frame));
    [self.circleView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupModels {
    JFBannerModel *model1 = [JFBannerModel modelWithImageName:@"banner1" clickUrl:@"https://www.baidu.com"];
    JFBannerModel *model2 = [JFBannerModel modelWithImageName:@"banner2" clickUrl:@"https://www.jianshu.com"];
    JFBannerModel *model3 = [JFBannerModel modelWithImageName:@"banner3" clickUrl:@"https://www.sina.com.cn"];
    JFBannerModel *model4 = [JFBannerModel modelWithImageName:@"banner4" clickUrl:@"https://github.com"];
    self.models = @[model1, model2, model3, model4];

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

- (IBAction)clickBtScaleType:(UIButton *)sender {

    self.circleView.scrollViewEdgInset = UIEdgeInsetsMake(22, 44, 22, 44);
    /**图片宽高比(注意一定要浮点类型)*/
    self.circleView.contentViewMulriple = 750.f / 390;
    self.circleView.contentViewScaleDifferent = 0.2;
    [self.circleView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)circleViewContentViewNumber:(JFCircleView *)circleView {
    return self.models.count;
}

- (UIView *)circleView:(JFCircleView *)circleView contentViewAtIndex:(NSUInteger)index {
    JFBannerModel *model = self.models[index];
    NSString *path = [[NSBundle mainBundle] pathForResource:model.imageName ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOpacity = 0.8f;
    imageView.layer.shadowRadius = 2.f;
    imageView.layer.shadowOffset = CGSizeMake(2, 2);
    return imageView;
}


- (void)circleView:(JFCircleView *)circleView clickIndex:(NSUInteger)index {
    JFBannerModel *model = self.models[index];
    NSLog([NSString stringWithFormat:@"点击了下标:%d", index]);
    NSLog([NSString stringWithFormat:@"地址是:%@", model.clickUrl]);

}


@end