//
//  ViewController.m
//  GoAutoSlideViewExample
//
//  Created by jamie on 16/3/9.
//  Copyright (c) 2016 X-Monster. All rights reserved.
//


#import "ViewController.h"
#import "GoAutoSlideView.h"


@interface ViewController () <GoAutoSlideViewDataSource, GoAutoSlideViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    GoAutoSlideView *slideView = [[GoAutoSlideView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    slideView.slideDuration = 5;
    slideView.slideDelegate = self;
    slideView.slideDataSource = self;
    slideView.pageIndicatorColor = [UIColor grayColor];
    slideView.currentPageIndicatorColor = [UIColor blueColor];
    [self.view addSubview:slideView];
    [slideView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GoAutoSlideViewDataSource

- (NSInteger)numberOfPagesInGoAutoSlideView:(GoAutoSlideView *)goAutoSlideView {
    return 5;
}

- (UIView *)goAutoSlideView:(GoAutoSlideView *)goAutoSlideView viewAtPage:(NSInteger)page {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 300)];
    CGFloat hue = (CGFloat) ( arc4random() % 256 / 256.0 );
    CGFloat saturation = (CGFloat) (( arc4random() % 128 / 256.0 ) + 0.5);
    CGFloat brightness = (CGFloat) (( arc4random() % 128 / 256.0 ) + 0.5);
    UIColor *randomColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    [view setBackgroundColor:randomColor];
    return view;
}
#pragma mark GoAutoSlideViewDelegate

- (void)goAutoSlideView:(GoAutoSlideView *)goAutoSlideView didTapViewPage:(NSInteger)page {
    NSLog(@"Page %@ taped", @(page));
}

@end