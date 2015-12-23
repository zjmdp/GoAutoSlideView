//
//  GoAutoSlideView.m
//  LetsGo
//
//  Created by jamie on 15/12/21.
//  Copyright © 2015年 X-Monster. All rights reserved.
//

#import "GoAutoSlideView.h"

@interface GoAutoSlideView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *slideTimer;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *contentViews;

@property (nonatomic, strong) UIScrollView *scrollView;;
@end

@implementation GoAutoSlideView

- (instancetype)init{
    if (self = [super init]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    self.contentViews = [NSMutableArray new];
}

#pragma mark Private

- (void)resetPageControl{
    if (self.disablePageIndicator) {
        [self.pageControl removeFromSuperview];
        return;
    }
    if (!self.pageControl) {
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.pageControl.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) - 20);
        [self addSubview:self.pageControl];
    }
    if ([self.slideDataSource respondsToSelector:@selector(numberOfPagesInGoAutoSlideView:)]) {
        NSInteger pageCount = [self.slideDataSource numberOfPagesInGoAutoSlideView:self];
        self.pageControl.numberOfPages = pageCount;
    }else{
        self.pageControl.numberOfPages = 0;
    }
    if (self.currentPageIndicatorColor != nil) {
        [self.pageControl setCurrentPageIndicatorTintColor:self.currentPageIndicatorColor];
    }else{
        [self.pageControl setCurrentPageIndicatorTintColor:[UIColor blueColor]];
    }
    if (self.pageIndicatorColor != nil) {
        [self.pageControl setPageIndicatorTintColor:self.pageIndicatorColor];
    }else{
        [self.pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    }
}

- (void)onTimerFired{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.bounds), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)resetSubViewsFrame{
    for (NSInteger i = 0; i < [self.contentViews count]; i++) {
        UIView *view = [self.contentViews objectAtIndex:i];
        [view setFrame:CGRectMake(CGRectGetWidth(self.bounds) * i, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    }
    if ([self.contentViews count] > 1) {
        UIView *currentView = [self.contentViews objectAtIndex:1];
        NSInteger currentPage = currentView.tag;
        [self.pageControl setCurrentPage:currentPage];
    }
}

- (void)rorateViewsRight{
    UIView *lastView = [self.contentViews lastObject];
    [self.contentViews removeLastObject];
    [self.contentViews insertObject:lastView atIndex:0];
    [self resetSubViewsFrame];
}

- (void)rorateViewsLeft{
    UIView *firstView = [self.contentViews firstObject];
    [self.contentViews removeObjectAtIndex:0];
    [self.contentViews addObject:firstView];
    [self resetSubViewsFrame];
}

- (void)onPageTaped:(UITapGestureRecognizer *)reconnizer{
    UIView *tapedView = reconnizer.view;
    if ([self.slideDelegate respondsToSelector:@selector(goAutoSlideView:didTapViewPage:)]) {
        [self.slideDelegate goAutoSlideView:self didTapViewPage:tapedView.tag];
    }
}

#pragma mark Public
- (void)reloadData{
    [self stopAutoScroll];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentViews removeAllObjects];
    if ([self.slideDataSource respondsToSelector:@selector(numberOfPagesInGoAutoSlideView:)]) {
        NSInteger pageCount = [self.slideDataSource numberOfPagesInGoAutoSlideView:self];
        
        for (NSInteger i = 0; i < pageCount; i++) {
            if ([self.slideDataSource respondsToSelector:@selector(goAutoSlideView:viewAtPage:)]) {
                UIView *pageView = [self.slideDataSource goAutoSlideView:self viewAtPage:i];
                NSAssert(pageView != nil, @"page view can not be nil!");
                [pageView setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPageTaped:)];
                [pageView addGestureRecognizer:tapRecognizer];
                [pageView setTag:i];
                [self.contentViews addObject:pageView];
                [self.scrollView addSubview:pageView];
            }
        }
        if (pageCount > 1) {
            [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.bounds) * 3, CGRectGetHeight(self.bounds))];
            [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            [self rorateViewsRight];
        }else if(pageCount == 1){
            [self.scrollView setContentSize:self.bounds.size];
            [self.scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.bounds))];
            UIView *view = [self.contentViews firstObject];
            [view setFrame:self.bounds];
        }
    }
    
    [self resetPageControl];
    [self startAutoScroll];
}

- (void)setSlideDuration:(NSTimeInterval)slideDuration{
    NSAssert(slideDuration > 0, @"slideDuration must be greater than 0");
    _slideDuration = slideDuration;
    if (self.slideTimer != nil) {
        [self.slideTimer invalidate];
        self.slideTimer = nil;
    }
    self.slideTimer = [NSTimer scheduledTimerWithTimeInterval:self.slideDuration
                                                       target:self
                                                     selector:@selector(onTimerFired)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)setDisablePageIndicator:(BOOL)disablePageIndicator{
    _disablePageIndicator = disablePageIndicator;
    [self resetPageControl];
}

- (void)startAutoScroll{
    if ([self.slideTimer isValid] && [self.contentViews count] > 1) {
        [self.slideTimer setFireDate:[NSDate dateWithTimeInterval:[self slideDuration]
                                                        sinceDate:[NSDate date]]];
    }
}

- (void)stopAutoScroll{
    if ([self.slideTimer isValid]) {
        [self.slideTimer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startAutoScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.contentViews count] > 1) {
        if ([self.contentViews count] == 2) {
            if (scrollView.contentOffset.x > CGRectGetWidth(self.bounds)) {
                UIView *nextView = (UIView *)[self.contentViews firstObject];
                [nextView setFrame:CGRectMake(2 * CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            } else if (scrollView.contentOffset.x < CGRectGetWidth(self.bounds)) {
                UIView *nextView = (UIView *)[self.contentViews firstObject];
                [nextView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            }
        }
        if (scrollView.contentOffset.x == 0) {
            CGPoint newOffset = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            [self.scrollView setContentOffset:newOffset];
            [self rorateViewsRight];
        }else if(scrollView.contentOffset.x == CGRectGetWidth(self.bounds) * 2){
            CGPoint newOffset = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            [self.scrollView setContentOffset:newOffset];
            [self rorateViewsLeft];
        }
    }
    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
}

@end
