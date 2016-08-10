# GoAutoSlideView

[![Version](https://img.shields.io/cocoapods/v/GoAutoSlideView.svg?style=flat)](http://cocoapods.org/pods/GoAutoSlideView)
[![License](https://img.shields.io/cocoapods/l/GoAutoSlideView.svg?style=flat)](http://cocoapods.org/pods/GoAutoSlideView)
[![Platform](https://img.shields.io/cocoapods/p/GoAutoSlideView.svg?style=flat)](http://cocoapods.org/pods/GoAutoSlideView)


`GoAutoSlideView` extends `UIScrollView` by featuring *infinitely* and *automatically* slide.

#ScreenShot
![Screenshot](./Screenshots/screenshot.gif "screenshot")

## Installation
###CocoaPods
```ruby

pod 'GoAutoSlideView', '~> 0.7'

```

###Manually
1. Downloads the source files in directory `GoAutoSlideView/Classes`.
2. Add the source files to your project.
3. import `"GoAutoSlideView.h"` in your files.

## Usage
#### Create GoAutoSlideView

```objc

GoAutoSlideView *slideView = [[GoAutoSlideView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
slideView.slideDuration = 5;
slideView.slideDelegate = self;
slideView.slideDataSource = self;
slideView.currentPageIndicatorColor = [UIColor blueColor];
[self.view addSubView:slideView];
[slideView reloadData];

```

#### Implement GoSlideViewDataSource

```objc

- (NSInteger)numberOfPagesInGoAutoSlideView:(GoAutoSlideView *)goAutoSlideView{
    return 5;
}

- (UIView *)goAutoSlideView:(GoAutoSlideView *)goAutoSlideView viewAtPage:(NSInteger)page{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
	[image setImage:[UIImage imageNamed:images[page]]]
    return imageView;
}

```

#### Implement GoSlideViewDelegate

```objc

- (void)goAutoSlideView:(GoAutoSlideView *)goAutoSlideView didTapViewPage:(NSInteger)page{
	NSLog(@"didTapViewPage at index: %@", @(page));
}

```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits

* zjmdp

## License

MIT license
