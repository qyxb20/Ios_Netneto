//
//  TSVideoPlayback.m


#import "TSVideoPlayback.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
//#import "JPVideoPlayerKit.h"
#import "SJVideoPlayer.h"
#import "SJEdgeControlLayer.h"
//#import "SVProgressHUD.h"

@interface TSVideoPlayback ()<UIScrollViewDelegate,SJVideoPlayerControlLayerDelegate,SJEdgeControlLayerDelegate>
{
    BOOL isReadToPlay;
    BOOL isEndPlay;
    BOOL isCliakVIew;
    NSInteger imgIndex;
    UIView *bgView;
}

@property (nonatomic,strong) UILabel *indexLab;//当前播放页数
@property (nonatomic,strong) UIButton *playBtn;//播放按钮
@property (nonatomic,strong) UIButton *muteBtn;//播放按钮
@property (nonatomic,strong) UIButton *videoBtn;//切换到视频
@property (nonatomic,strong) UIButton *imgBtn;//切换到图片
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIImageView *placeholderImg;//占位图img
@property (nonatomic,strong) SJVideoPlayer *player;//占位图img

@property (nonatomic,assign) BOOL isFinsh;

@end

@implementation TSVideoPlayback

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialControlUnit];
    }
    return self;
}

-(void)setWithIsVideo:(TSDETAILTYPE)type andDataArray:(NSArray *)array
{
    self.dataArray = array;
    self.isFinsh = NO;
    self.scrolView.contentSize = CGSizeMake(self.dataArray.count*self.frame.size.width, self.frame.size.height);
    self.type = type;
    if (type == TSDETAILTYPEVIDEO) {
                [self.playBtn setHidden:NO];
        [self.videoBtn setHidden:NO];
        [self.imgBtn setHidden:NO];
        [self.muteBtn setHidden:NO];
    }else{
                [self.playBtn setHidden:YES];
        [self.videoBtn setHidden:YES];
        [self.imgBtn setHidden:NO];
        [self.muteBtn setHidden:YES];
        bgView.frame = CGRectMake(self.frame.size.width - 21 -60, self.frame.size.height - 60, 60, 26);
        [self.imgBtn setBackgroundColor:RGB_ALPHA(0xFFFFFF, 0.45)];
        self.imgBtn.frame =CGRectMake(2, 2, 56, 22);
    }
    for (int i = 0; i < _dataArray.count; i ++) {
        if (type == TSDETAILTYPEVIDEO) {
            if (i == 0) {
                NSURL *url = [NSURL URLWithString:self.dataArray[0]];
                _player.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                _player.view.backgroundColor = [UIColor clearColor];
                [self.scrolView addSubview:_player.view];
                // 设置资源进行播放
                _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:url];
                _player.defaultEdgeControlLayer.fixesBackItem = NO;
                _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
                __weak typeof(self) _self = self;
                //滑动手势
                _player.gestureController.panHandler = ^(id<SJGestureController>  _Nonnull control, SJPanGestureTriggeredPosition position, SJPanGestureMovingDirection direction, SJPanGestureRecognizerState state, CGPoint translate) {
                    
                __strong typeof(_self) self = _self;
                    
                if ( !self ) return ;
                /// ....
                    
                    [self changeBtnClick:self.imgBtn];
                };
                [_player pause];
            }
            else{
                UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
                img.userInteractionEnabled = YES;
                [img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
                [self.scrolView addSubview:img];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
                [img addGestureRecognizer:tap];
                
            }
            
            if (_dataArray.count > 1) {
                self.indexLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)self.dataArray.count - 1];
                self.indexLab.hidden = YES;
                self.videoBtn.selected = YES;
                self.imgBtn.selected = NO;
                self.imgBtn.userInteractionEnabled = YES;
                [self.imgBtn setTitle:TransOutput(@"图片") forState:UIControlStateNormal];
            }
        }else{//全图片
            UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
            img.userInteractionEnabled = YES;
            [self.scrolView addSubview:img];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
            [img addGestureRecognizer:tap];
            

            NSString *imgStr = [NSString stringWithFormat:@"%@ %d/%d",TransOutput(@"图片"),1,(int)self.dataArray.count];
            self.indexLab.hidden = NO;
            self.videoBtn.selected = YES;

            self.imgBtn.userInteractionEnabled = NO;
            [self.imgBtn setTitle:imgStr forState:UIControlStateNormal];
        }
    }
}

- (void)changeBtnClick:(UIButton *)btn{
    if (btn.tag == 1) {
        self.videoBtn.selected = YES;
        self.imgBtn.selected = NO;
        _muteBtn.hidden = NO;
        self.videoBtn.backgroundColor = RGB_ALPHA(0xFFFFFF, 0.45);
        [self.videoBtn setImage:[UIImage imageNamed:@"多边形 2"] forState:UIControlStateSelected];
       
        self.imgBtn.backgroundColor = [UIColor clearColor];
        
        if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
            
            [self.scrolView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self scrollViewDidEndDecelerating:self.scrolView];
        }
    }
    else{
        if (self.dataArray.count < 2) {
            return;
        }
        self.videoBtn.selected = NO;
        self.imgBtn.selected = YES;
        _muteBtn.hidden = YES;
        self.videoBtn.backgroundColor = [UIColor clearColor];
        [self.videoBtn setImage:[UIImage imageNamed:@"多边形 2-2"] forState:UIControlStateNormal];
       
        self.imgBtn.backgroundColor = RGB_ALPHA(0xFFFFFF, 0.45);
        if (self.scrolView.contentOffset.x < self.frame.size.width) {
            if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
                [self.scrolView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
                [self scrollViewDidEndDecelerating:self.scrolView];
            }
        }
    }
    return;
}
-(void)imgTapClick
{
    
    if ([self.delegate respondsToSelector:@selector(videoView:didSelectItemAtIndexPath:)]) {
        if (self.type == TSDETAILTYPEVIDEO) {
            [self.delegate videoView:self didSelectItemAtIndexPath:imgIndex];
        }else{
            [self.delegate imgView:self didSelectItemAtIndexPath:imgIndex+1];
        }
    }
}
#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    imgIndex = index;
    if (self.type == TSDETAILTYPEVIDEO) {
        if (self.scrolView.contentOffset.x < self.frame.size.width) {
            self.indexLab.hidden = YES;
                        
            if (self.isFinsh) {
                [self.playBtn setHidden:YES];
            }else{
                [self.playBtn setHidden:NO];
            }
            [self.imgBtn setTitle:TransOutput(@"图片") forState:UIControlStateNormal];
            _muteBtn.hidden = NO;
        }
        else{
            self.indexLab.hidden = NO;
                        [self.playBtn setHidden:YES];
            [self.player pause];
            _muteBtn.hidden = YES;
            NSString*str = [NSString stringWithFormat:@"%@ %d/%d",TransOutput(@"图片") ,(int)index,(int)self.dataArray.count - 1];
            [self.imgBtn setTitle:str forState:UIControlStateNormal];
            
            
        }
        
    }else{
        
        _muteBtn.hidden = YES;
        [self.player pause];
        
        self.indexLab.hidden = NO;

        NSString*str = [NSString stringWithFormat:@"%@ %d/%d",TransOutput(@"图片") ,(int)index+1,(int)self.dataArray.count];
        [self.imgBtn setTitle:str forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.type == TSDETAILTYPEVIDEO) {
        if (self.scrolView.contentOffset.x < self.frame.size.width/2) {
            self.videoBtn.selected = YES;
            self.imgBtn.selected = NO;
            self.videoBtn.backgroundColor = RGB_ALPHA(0xFFFFFF, 0.45);
            self.imgBtn.backgroundColor = [UIColor clearColor];
            [self.videoBtn setImage:[UIImage imageNamed:@"多边形 2"] forState:UIControlStateSelected];
            if (self.isFinsh) {
                self.playBtn.hidden = YES;
            }else{
                self.playBtn.hidden = NO;
            }
             _muteBtn.hidden = NO;
            
        } else{
            self.videoBtn.selected = NO;
            self.imgBtn.selected = YES;
            self.videoBtn.backgroundColor = [UIColor clearColor];
            [self.videoBtn setImage:[UIImage imageNamed:@"多边形 2-2"] forState:UIControlStateNormal];
           
            self.imgBtn.backgroundColor = RGB_ALPHA(0xFFFFFF, 0.45);
            _muteBtn.hidden = YES;
        }
    }else{
        return;
    }
}
-(void)initialControlUnit
{
    isEndPlay = NO;
    _scrolView = [[UIScrollView alloc]init];
    _scrolView.pagingEnabled  = YES;
    _scrolView.delegate = self;
    _scrolView.showsVerticalScrollIndicator = NO;
    _scrolView.showsHorizontalScrollIndicator = NO;
    _scrolView.userInteractionEnabled = YES;
    [self addSubview:_scrolView];
    self.scrolView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    self.placeholderImg = [[UIImageView alloc]init];
    self.placeholderImg.image = [UIImage imageNamed:@"zhanweitu"];
    self.placeholderImg.contentMode = UIViewContentModeScaleAspectFill;
    self.placeholderImg.userInteractionEnabled = YES;
    self.placeholderImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.scrolView addSubview:self.placeholderImg];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 114 - 21, self.frame.size.height - 60, 114, 26)];
    bgView.backgroundColor = RGB_ALPHA(0x000000, 0.2);
    bgView.layer.cornerRadius = 13;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    _videoBtn = [[UIButton alloc]init];
    [_videoBtn setTitle:TransOutput(@"视频") forState:UIControlStateNormal];
    [_videoBtn setTitleColor:RGB(0x4B4B4B) forState:UIControlStateSelected];
    [_videoBtn setImage:[UIImage imageNamed:@"多边形 2"] forState:UIControlStateSelected];
    [_videoBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:0];
    [_videoBtn setBackgroundColor:RGB_ALPHA(0xFFFFFF, 0.45)];
    _videoBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _videoBtn.layer.cornerRadius = 11;
    _videoBtn.layer.masksToBounds = YES;
    self.videoBtn.tag = 1;
    [bgView addSubview:_videoBtn];
    self.videoBtn.frame = CGRectMake(2, 2, 52, 22);
    
    _imgBtn = [[UIButton alloc]init];
    [_imgBtn setTitle:TransOutput(@"图片") forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_imgBtn setTitleColor:RGB(0x4B4B4B) forState:UIControlStateSelected];
    _imgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    _imgBtn.backgroundColor = [UIColor clearColor];
    _imgBtn.layer.cornerRadius = 22/2;
    _imgBtn.layer.masksToBounds = YES;
    self.imgBtn.tag = 2;
    [bgView addSubview:_imgBtn];
    self.imgBtn.frame = CGRectMake(56, 2, 114-58, 22);
    
    
    _playBtn = [[UIButton alloc]init];
    [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self addSubview:_playBtn];
    self.playBtn.frame = CGRectMake(self.center.x -22.5, self.center.y - 22.5, 45,45);
    
    
    _muteBtn = [[UIButton alloc]init];
    [_muteBtn setImage:[UIImage imageNamed:@"组合 624"] forState:UIControlStateNormal];
    [self addSubview:_muteBtn];
    self.muteBtn.frame = CGRectMake(self.frame.size.width - 45,  bgView.top - 35, 24, 24);
    
    [self.videoBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.muteBtn addTarget:self action:@selector(muteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _player = [SJVideoPlayer player];
    _player.defaultEdgeControlLayer.delegate = self;
    [_player setMuted:YES];

    _player.needsFitOnScreenFirst = YES;


}
-(void)playFinshForControlLayer:(BOOL)isPlay{
    self.isFinsh = isPlay;
        
    
}
-(void)muteClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [_player setMuted:NO];
        
        [_muteBtn setImage:[UIImage imageNamed:@"组合 623"] forState:UIControlStateNormal];
    }
    else{
        sender.selected = NO;
        [_player setMuted:YES];
        [_muteBtn setImage:[UIImage imageNamed:@"组合 624"] forState:UIControlStateNormal];
    }
}
-(void)playClick:(UIButton *)sender{
    [self.player play];
    _playBtn.hidden = YES;

}
-(void)backItemWasTappedForControlLayer:(id<SJControlLayer>)controlLayer{
    [self.player _backButtonWasTapped];
    
}
- (void)playItemWasTappedForControlLayer:(BOOL)isPlay{
    _playBtn.hidden = YES;

}

- (void)clearCache {
    [self.player stop];
}
- (void)pausePlayVideo{
    [self.player pause];
}
@end
