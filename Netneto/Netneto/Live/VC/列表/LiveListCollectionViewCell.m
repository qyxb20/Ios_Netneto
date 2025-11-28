//
//  LiveListCollectionViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/14.
//

#import "LiveListCollectionViewCell.h"

@implementation LiveListCollectionViewCell
-(void)setDataDic:(NSDictionary *)dataDic{
   
    
    _dataDic = dataDic;
    if ([[NSString stringWithFormat:@"%@",dataDic[@"imgPath"]] isEqualToString:@"<null>"]) {
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dataDic[@"shopLogo"]]]];
       
    }else{
        [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dataDic[@"imgPath"]]]];
    }
    self.title.text = [NSString stringWithFormat:@"%@\n%@",[NSString isNullStr:dataDic[@"msg"]],[NSString isNullStr:dataDic[@"notice"]]];
    
    self.onlineNum.text = [NSString stringWithFormat:@"%@",[NSString isNullStr:dataDic[@"showCategoryName"]]];

    self.onlineNum.font = [UIFont systemFontOfSize:11];
    
    CGFloat w = [Tool getLabelWidthWithText:[NSString isNullStr:dataDic[@"shopName"]] height:23 font:10];
    
    CGFloat shopW = 10 + 11 + 5 + w + 10;
    if (shopW > (WIDTH - 64) / 2 - 20) {
        shopW = (WIDTH - 64) / 2 - 20;
    }
        [self.shopView removeFromSuperview];
    self.shopView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH - 64) / 2 - shopW  , 263 - 23 - 17, shopW, 23)];
    self.shopView.backgroundColor = RGB(0xE1EEFA);
    [self.contentView addSubview:self.shopView];
    UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 11, 9)];
    ima.image = [UIImage imageNamed:@"path 1"];
    [self.shopView addSubview:ima];
    if (w > shopW - 10 -21) {
        w = shopW - 10 -21;
    }
    self.shopName = [[UILabel alloc] initWithFrame:CGRectMake(ima.right + 5, 0, w, 23)];
    self.shopName.font = [UIFont systemFontOfSize:10];
    self.shopName.textColor = RGB(0x5D84A8);
    self.shopName.text = [NSString isNullStr:dataDic[@"shopName"]];
    [self.shopView addSubview:self.shopName];
    [self.shopView addDiagonalCornerPath:5];
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
