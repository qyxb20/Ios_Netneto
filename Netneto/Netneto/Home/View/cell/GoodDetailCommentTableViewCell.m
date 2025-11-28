//
//  GoodDetailCommentTableViewCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "GoodDetailCommentTableViewCell.h"
#import "SDPhotoBrowser.h"
@interface GoodDetailCommentTableViewCell ()<SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodCommentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;

@end

@implementation GoodDetailCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (void)setModel:(GoodCommentModel *)model
{
    _model = model;

    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:self.model.pic]] placeholderImage:[UIImage imageNamed:@"椭圆 6"] ];
    self.userNameLabel.text = [NSString isNullStr:self.model.nickName];
    self.contentLabel.text = [NSString isNullStr:self.model.content];
    if (self.model.replyContent.length >0) {
        self.replyContentLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"掌柜回复"),[NSString isNullStr:self.model.replyContent]];
    }
    
    self.timeLabel.text = [NSString isNullStr:self.model.recTime];
    if (model.pics.length > 0 ) {
        NSArray *arr = [model.pics componentsSeparatedByString:@","];
        CGFloat space = 15;
        CGFloat imgw = (WIDTH - 15 * 4 ) / 3;
        CGFloat imgY = model.rowH + 30 - model.imgH - model.replyH ;
        for (int i = 0; i < arr.count; i++) {
            
            UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(space + (imgw + space) * (i % 3),  imgY + (imgw + 15) * (i / 3), imgw, imgw)];
            ima.tag = i;
            @weakify(self);
            
            [ima addTapAction:^(UIView * _Nonnull view) {
                @strongify(self);
//                ExecBlock(self.imgClickBlock,ima.tag,view);
                SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
                broser.currentImageIndex = i ;
                broser.tag = 3;
                broser.sourceImagesContainerView = self.contentView;
                broser.imageCount =arr.count  ;
                broser.delegate = self;
                [broser show];
            }];
            [ima sd_setImageWithURL:[NSURL URLWithString:arr[i]]];
            [self.contentView addSubview:ima];
        }
    }
   
    for (int i = 1; i < 6; i++) {
        UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(16 + 40 + (12 + 3) * (i-1), self.userNameLabel.bottom + 2, 12, 12)];
        if ( i <= [self.model.score intValue]) {
            ima.image = [UIImage imageNamed:@"星星2"];
        }else{
            ima.image = [UIImage imageNamed:@"星星3"];
        }
        [self.contentView addSubview:ima];
    }
}
#pragma mark - 图片预览
-(NSURL*)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    //网络图片（如果崩溃，可能是此图片地址不存在了）
    NSMutableArray *array;
   
    if (browser.tag == 3) {
        NSArray *imgArr = [self.model.pics componentsSeparatedByString:@","];
        array = [NSMutableArray arrayWithArray:imgArr];
    }

    NSString *imageName = array[index];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", imageName]];

    return url;
}

//大图占位图/或者本地图片展示
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
   
    UIImage *img = [UIImage imageNamed:@"zhanweitu"];
   
    return img;
}
-(void)setNumber:(NSString *)number{
    _number = number;
    if ([number intValue] == 0) {
        self.commentNumLabel.text  = TransOutput(@"该商品暂无评价");
    }else{
             self.commentNumLabel.text = [NSString stringWithFormat:@"%@(%@)",TransOutput(@"用户评价"),number];
    }
}

-(void)setPositiveRating:(NSString *)positiveRating{
    _positiveRating = positiveRating;
    if ([positiveRating intValue] >0) {
        self.goodCommentLabel.text = [NSString stringWithFormat:@"%@%@.0%%",TransOutput(@"好评率"),positiveRating];
    }
    else{
        self.goodCommentLabel.text = [NSString stringWithFormat:@"%@%@.0%%",TransOutput(@"好评率"),@"0"];

    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
