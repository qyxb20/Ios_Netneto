//
//  DDBlendBannerView.m
//  duck
//
//  Created by lll on 2022/1/14.
//

#import "DDBlendBannerView.h"
#import "FSPagerViewObjcCompat.h"
#import "DDVideoViewModel.h"
#import "Netneto-Swift.h"/*替换成项目名-Swift*/
#import <SDWebImage/SDWebImage.h>

@interface DDBlendBannerView()<FSPagerViewDataSource,FSPagerViewDelegate>

@property (nonatomic, strong) FSPagerView *pagerView;
@property (nonatomic, strong) FSPageControl *pageControl;
@end

@implementation DDBlendBannerView
{
    NSMutableArray<DDBannerModel *> *sourceImageArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        sourceImageArray = [[NSMutableArray alloc] init];
        
        [self addSubview:self.pagerView];
        self.pagerView.delegate = self;
        self.pagerView.dataSource = self;
        [self.pagerView registerClass:[DDPVBannerViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.pagerView.itemSize = FSPagerViewAutomaticSize;
        self.pagerView.automaticSlidingInterval = 5;
        self.pagerView.isInfinite = YES;
        
        [self addSubview:self.pageControl];
        self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        // Ring
        [self.pageControl setStrokeColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.pageControl setStrokeColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [self.pageControl setFillColor:[UIColor orangeColor] forState:UIControlStateSelected];
    }
    
    return self;
}

- (void)setShowArray:(NSArray<DDBannerModel *> *)showArray
{
    _showArray = showArray;
    [sourceImageArray removeAllObjects];
    [sourceImageArray addObjectsFromArray:showArray];
    [self.pagerView reloadData];
    
    self.pageControl.numberOfPages = [sourceImageArray count];
    self.pageControl.currentPage = 0;
}

- (FSPagerView *)pagerView
{
    if (!_pagerView){
        _pagerView = [[FSPagerView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    return _pagerView;
}

- (FSPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[FSPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    }
    return _pageControl;
}


- (NSInteger)numberOfItemsInPagerView:(FSPagerView * _Nonnull)pagerView {
    return [sourceImageArray count];
}

- (FSPagerViewCell * _Nonnull)pagerView:(FSPagerView * _Nonnull)pagerView cellForItemAtIndex:(NSInteger)index {
    
    DDPVBannerViewCell *cell = (DDPVBannerViewCell *)[pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    
    DDBannerModel *model = sourceImageArray[index];
    //充值滚动时间以及移除播放器
    self.pagerView.automaticSlidingInterval = 5;
    [cell removePlayer];
    if (model.type == DDBannerTypeLocalImage) {
        cell.imageView.image = [UIImage imageNamed:model.filePath];
    }else if(model.type == DDBannerTypeNetImage) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.filePath] placeholderImage:nil];
    }else if(model.type == DDBannerTypeLocalVideo ||
             model.type == DDBannerTypeNetVideo) {
        
        [cell showLoad];
        __weak typeof(self) weakSelf = self;
        //指定动画开始
        [[DDVideoViewModel shareVideoModel] getVideoInfo:model with:^(DDVideoModel * _Nonnull ffModel) {
            //动画结束
            cell.imageView.image = ffModel.firstFrameImage;
            [cell stopLoad];
            
            //开始播放视频
            weakSelf.pagerView.automaticSlidingInterval = ffModel.videoDuration;
            [cell addPlayer];
            if (model.type == DDBannerTypeNetVideo) {
                [cell playUrlWithUrl:ffModel.videoPath];
            }else{
                [cell playFileVideoWithUrl:ffModel.videoPath];
            }
        }];
    }
    
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    
    [cell removeSomeView];//移除下边label
    return cell;
}

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
{
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
  
}

//- (void)pagerView:(FSPagerView *)pagerView willDisplayCell:(FSPagerViewCell *)cell forItemAtIndex:(NSInteger)index
//{
//    DDPVBannerViewCell *bCell = (DDPVBannerViewCell *)cell;
//
//    [bCell removePlayer];
//}

- (void)pagerView:(FSPagerView *)pagerView didEndDisplayingCell:(FSPagerViewCell *)cell forItemAtIndex:(NSInteger)index
{
    DDBannerModel *model = sourceImageArray[index];
    if(model.type == DDBannerTypeLocalVideo ||
       model.type == DDBannerTypeNetVideo) {
        DDPVBannerViewCell *bCell = (DDPVBannerViewCell *)cell;
        [bCell stop];
        [bCell removePlayer];
    }
}
- (void)pagerViewDidScroll:(FSPagerView *)pagerView targetIndex:(NSInteger)targetIndex{
    
    self.pageControl.currentPage = targetIndex;
}
- (void)pagerViewWillEndDragging:(FSPagerView *)pagerView targetIndex:(NSInteger)targetIndex {
    self.pageControl.currentPage = targetIndex;
}

@end
