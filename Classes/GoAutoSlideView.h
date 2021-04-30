//
//  GoAutoSlideView.h
//  LetsGo
//
//  Created by jamie on 15/12/21.
//  Copyright © 2015年 X-Monster. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoAutoSlideView;

@protocol GoAutoSlideViewDataSource <NSObject>

@required
/**
 *  Tells the data source to return the number of pages of a auto slide view.
 *
 *  @param goAutoSlideView The auto slide view requesting the information.
 *
 *  @return The number of pages of in auto slide view.
 */
- (NSInteger)numberOfPagesInGoAutoSlideView:(GoAutoSlideView *)goAutoSlideView;
/**
 *  Asks the data source for a page view at a particular location of the auto slide view.
 *
 *  @param goAutoSlideView The auto slide view requesting the information.
 *  @param page            An index locating a page view in auto slide view.
 *
 *  @return A view for the specified page. An assertion is raised if you return nil.
 */
- (nonnull UIView *)goAutoSlideView:(GoAutoSlideView *)goAutoSlideView viewAtPage:(NSInteger)page;

@end

@protocol GoAutoSlideViewDelegate <NSObject>

@optional
/**
 *  Tells the delegate that the specified page is tapped.
 *
 *  @param goAutoSlideView The auto slide view informing the new page view tapped.
 *  @param page            An index locating the new tapped page view in auto slide view.
 */
- (void)goAutoSlideView:(GoAutoSlideView *)goAutoSlideView didTapViewPage:(NSInteger)page;
- (void)goAutoSlideView:(GoAutoSlideView *)goAutoSlideView didMoveToPage:(NSInteger)page;

@end

@interface GoAutoSlideView : UIView
/**
 *  The object that acts as the data source of the auto slide view.
 */
@property (nonatomic, weak, nullable) id<GoAutoSlideViewDataSource> slideDataSource;
/**
 *  The object that acts as the delegate of the auto slide view.
 */
@property (nonatomic, weak, nullable) id<GoAutoSlideViewDelegate> slideDelegate;
/**
 *  The period time the auto slide view slide. If not set, page views will not be slide automatically;
 */
@property (nonatomic, assign) NSTimeInterval slideDuration;
/**
 *  Disable the page indicator. The page indicator is shown by default.
 */
@property (nonatomic, assign) BOOL disablePageIndicator;
/**
 *  The color of the current page indicator.
 */
@property (nonatomic, strong, nullable) UIColor *currentPageIndicatorColor;
/**
 *  The color of the indicator except the current indicator.
 */
@property (nonatomic, strong, nullable) UIColor *pageIndicatorColor;
/**
 * The bottom margin of indicator.
 */
@property (nonatomic, assign) CGFloat indicatorBottomMargin;
/**
 * The page control of the slide view.
 */
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
/**
 *  Loads/Reloads the page view of the auto slide view.
 */
- (void)reloadData;
/**
 *  Get current pages count.
 *
 *  @return The pages count of the auto slide view.
 */
- (NSInteger)getPagesCount;

/**
 * Get view at specified page
 * @param page The page of the view
 * @return The view of the specified page
 */
- (UIView *)viewAtPage:(NSInteger)page;

NS_ASSUME_NONNULL_END
@end
