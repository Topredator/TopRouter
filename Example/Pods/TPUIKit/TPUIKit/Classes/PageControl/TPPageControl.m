//
//  TPPageControl.m
//  TPUIKit
//
//  Created by Topredator on 2020/11/6.
//

#import "TPPageControl.h"
#import <Masonry/Masonry.h>
static CGFloat const kTPSpaceBetweenPages = 8.0;

@interface TPPageControl ()
/// 视图容器
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSMutableArray *pages;
@end

@implementation TPPageControl
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}
/// 默认值
- (void)initialization {
    self.currentPage = 0;
    self.numberOfPages = 0;
    self.spaceBetweenPages = kTPSpaceBetweenPages;
    self.hideForSinglePage = NO;
    [self addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.pages indexOfObject:touch.view];
        if ([self.delegate respondsToSelector:@selector(tp_pageControl:didSelectedPageAtIndex:)]) {
            [self.delegate tp_pageControl:self didSelectedPageAtIndex:index];
        }
    }
}
- (void)setCurrentPage:(NSInteger)currentPage {
    if (self.numberOfPages == 0 || _currentPage == currentPage) return;
    /// 先改变当前
    [self changeActivity:NO atIndex:_currentPage];
    _currentPage = currentPage;
    /// 在改变赋值的
    [self changeActivity:YES atIndex:_currentPage];
}
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self resetContainer];
}
- (void)setPageImage:(UIImage *)pageImage {
    _pageImage = pageImage;
    [self resetContainer];
}
- (void)setCurrentPageImage:(UIImage *)currentPageImage {
    _currentPageImage = currentPageImage;
    [self resetContainer];
}
- (void)setSpaceBetweenPages:(CGFloat)spaceBetweenPages {
    _spaceBetweenPages = spaceBetweenPages;
    [self resetContainer];
}
- (void)setPosition:(TPPageControlPosition)position {
    _position = position;
    [self resetContainer];
}
/// 重置操作
- (void)resetContainer {
    for (UIImageView *page in self.container.subviews) {
        [page removeFromSuperview];
    }
    [self.pages removeAllObjects];
    [self updatePages];
}
- (void)updatePages {
    if (self.numberOfPages == 0) return;
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        switch (self.position) {
            case TPPageControlPositionCenter: {
                make.centerX.mas_equalTo(0);
                make.top.bottom.mas_equalTo(0);
            }
                break;
            case TPPageControlPositionLeft: {
                make.left.mas_equalTo(0);
                make.top.bottom.mas_equalTo(0);
                make.right.mas_lessThanOrEqualTo(0);
            }
                break;
            default: {
                make.right.mas_equalTo(0);
                make.top.bottom.mas_equalTo(0);
                make.left.mas_greaterThanOrEqualTo(0);
            }
                break;
        }
    }];
    UIImageView *lastView = nil;
    CGSize size = self.pageImage.size;
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        UIImageView *pageView = [[UIImageView alloc] initWithImage:self.pageImage];
        [self.container addSubview:pageView];
        [self.pages addObject:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(size);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(self.spaceBetweenPages);
            } else {
                make.left.equalTo(self.container.mas_left).offset(self.spaceBetweenPages / 2);
            }
        }];
        lastView = pageView;
    }
    if (lastView) {
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right).offset(self.spaceBetweenPages / 2);
        }];
    }
    [self changeActivity:YES atIndex:self.currentPage];
    [self hideForSinglePageIfNeed];
    
}
- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index {
    if (self.pageImage && self.currentPageImage) {
        CGSize pageSize = self.pageImage.size;
        CGSize currentSize = self.currentPageImage.size;
        UIImageView *pageImage = [self.pages objectAtIndex:index];
        pageImage.image = active ? self.currentPageImage : self.pageImage;
        [pageImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(active ? currentSize : pageSize);
        }];
    }
}
- (void)hideForSinglePageIfNeed {
    if (self.pages.count <= 1 && self.hideForSinglePage) {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
}
- (void)sizeToFit {
    [self resetContainer];
}
#pragma mark ------------------------  lazy method ---------------------------
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _container;
}
- (NSMutableArray *)pages {
    if (!_pages) {
        _pages = @[].mutableCopy;
    }
    return _pages;
}
@end
