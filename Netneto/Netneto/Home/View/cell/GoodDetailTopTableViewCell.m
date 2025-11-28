//
//  GoodDetailTopTableViewCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "GoodDetailTopTableViewCell.h"
@interface GoodDetailTopTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sKuLabel;
@property (weak, nonatomic) IBOutlet UILabel *youLbel;
@property (weak, nonatomic) IBOutlet UIView *shopBgView;
@property (weak, nonatomic) IBOutlet UILabel *shouLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *choseSkuLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *indexPathArr;
@property(nonatomic, strong)UIScrollView *scrollView;
@end
@implementation GoodDetailTopTableViewCell

-(void)setModel:(GoodDetailModel *)model{
    self.indexPathArr = [NSMutableArray array];
    _model = model;
    self.titleNameLabel.text = [NSString isNullStr:_model.prodName];
    NSString *soldms = @"";
    soldms = [NSString stringWithFormat:@"%@",_model.soldNum];
    if ([NSString isNullStr:_model.soldNum].length == 0) {
        soldms = @"0";
    }
    self.shouLabel.text = [NSString stringWithFormat:@"%@%@",TransOutput(@"販売件数："),[NSString isNullStr:soldms]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:_model.skuList[0][@"price"]]];
    
    if ([_model.skuList[0][@"oriPrice"] floatValue] != [_model.skuList[0][@"price"] floatValue] && [_model.skuList[0][@"oriPrice"] floatValue] > 0) {
        NSString *oldPriceStr =[NSString stringWithFormat:@"¥%@%@",[NSString ChangePriceStr:_model.skuList[0][@"oriPrice"]],TransOutput(@"含税")];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPriceStr];
           [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPriceStr.length -[TransOutput(@"含税") length])];// 如果不加这个，横线的颜色跟随label字体颜色改变
        [attri addAttribute:NSStrikethroughColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange(0, oldPriceStr.length -[TransOutput(@"含税") length])];
        self.oldPriceLabel.textColor  = RGB(0xA1A0A0);
        self.oldPriceLabel.attributedText = attri;
    }
    if ([_model.skuList[0][@"stocks"] intValue] > 0) {
        self.sKuLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"库存"),[NSString isNullStr:_model.skuList[0][@"stocks"]]];
    }else{
        self.sKuLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"库存"),@"0"];
    }
   
    if ([_model.transport[@"isFreeFee"] isEqual:@0]) {
        self.youLbel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"是否包邮"),TransOutput(@"不包邮")];
    }
    else{
        self.youLbel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"是否包邮"),TransOutput(@"包邮")];
    }
    self.youLbel.textAlignment = NSTextAlignmentRight;
    self.shopNameLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"店铺"),[NSString isNullStr:_model.shopName]];
    self.choseSkuLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"已选择规格"),[NSString isNullStr:_model.skuList[0][@"skuName"]]];
    self.skuNumberLabel.text = [NSString stringWithFormat:@"%@%lu%@",TransOutput(@"有"),(unsigned long)_model.skuList.count,TransOutput(@"种规格可以选择")];
    
    [self.collectionBgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_offset(0);
    }];
    [self.collectionView reloadData];
    @weakify(self)
    [self.shopBgView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        ExecBlock(self.shopClickBlock,self.model.shopId);
    }];
    
    if (model.couponsList.count > 0) {
        self.scrollView = [[UIScrollView alloc] init];
        
         self.scrollView.scrollEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:self.scrollView];
         [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(0);
            make.trailing.mas_offset(-40);
    //        make.bottom.mas_offset(-76-15);
             make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(18);
            make.height.mas_offset(32);
        }];
        
        [self.scrollView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self)
            [self pushShow];
        }];
        UIImageView *button = [[UIImageView alloc] init];
        button.image =[UIImage imageNamed:@"push"];
        button.contentMode = UIViewContentModeScaleAspectFit;
        [button addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            [self pushShow];
        }];

        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.trailing.mas_offset(-16);
   //        make.bottom.mas_offset(-76-15);
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(22);
           make.height.mas_offset(15);
            make.width.mas_offset(15);
       }];
        CGFloat SW = 0;
        CGFloat BW = 0;
        CGFloat space = 10;
        for (int i = 0;i < model.couponsList.count ; i++) {
            NSDictionary *dic = model.couponsList[i];
            
            NSString *str;
            NSString *price = [NSString ChangePriceStr:[NSString stringWithFormat:@"%@",dic[@"value"]]];

            if ([dic[@"type"] intValue] == 2) {
                //        cell.nameLabel.font = [UIFont systemFontOfSize:10];
                
                str = [NSString stringWithFormat:@"%@%@引き",price,TransOutput(@"元")];
            }
            else  if ([dic[@"type"] intValue] == 0) {
                str = [NSString stringWithFormat:@"%@%@引き",price,TransOutput(@"元")];
            }
            else{
               str = [NSString stringWithFormat:@"%@%@引き",price,@"%"];
            }
            CGFloat w = [Tool getLabelWidthWithText:str height:32 font:14] + 20;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
           
            btn.layer.cornerRadius = 3;
            btn.clipsToBounds = YES;
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:RGB(0xF80402) forState:UIControlStateNormal];
            [btn.titleLabel setFont: [UIFont systemFontOfSize:14]];
            btn.layer.borderColor = RGB(0xF80402).CGColor;
            btn.layer.borderWidth = 1;
            btn.frame = CGRectMake(18 + space * i + BW , 0, w, 32);
            [self.scrollView addSubview:btn];
            BW += w;
            SW = btn.left + btn.width;
            self.scrollView.contentSize = CGSizeMake(SW + 20, 32);
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    
    
}
-(void)pushShow{
    ExecBlock(self.showCounponViewClickBlock);
}
-(void)btnClick:(UIButton *)sender{
    ExecBlock(self.showCounponViewClickBlock);
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(38,39);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsHorizontalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"GoodDetailTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodDetailTopCollectionViewCell"];
        
     
       
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.skuList.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodDetailTopCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
    cell = [[NSBundle mainBundle]loadNibNamed:@"GoodDetailTopCollectionViewCell" owner:self options:nil].lastObject;
      }
    NSDictionary *dic =self.model.skuList[indexPath.item];
    
    if ([_indexPathArr containsObject:indexPath]) {
        cell.im.layer.borderColor = [UIColor redColor].CGColor;
        cell.im.layer.borderWidth = 1;
    }
    else{
        cell.im.layer.borderColor = [UIColor clearColor].CGColor;
        cell.im.layer.borderWidth = 1;
    }
    if (_indexPathArr.count == 0 && indexPath.row == 0) {
        cell.im.layer.borderColor = [UIColor redColor].CGColor;
        cell.im.layer.borderWidth = 1;
    }
    [cell.im sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]  placeholderImage:[UIImage imageNamed:@"tupian"]];
    
return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.indexPathArr removeAllObjects];
    [self.indexPathArr addObject:indexPath];
    [self.collectionView reloadData];
    NSDictionary *dic =self.model.skuList[indexPath.item];
    
    self.choseSkuLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"已选择规格"),[NSString isNullStr:dic[@"skuName"]]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:dic[@"price"]]];
    if ([dic[@"oriPrice"] floatValue] != [dic[@"price"] floatValue] && [dic[@"oriPrice"] floatValue] != 0) {
        NSString *oldPriceStr =[NSString stringWithFormat:@"¥%@%@",[NSString ChangePriceStr:dic[@"oriPrice"]],TransOutput(@"含税")];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPriceStr];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPriceStr.length -[TransOutput(@"含税") length])];// 如果不加这个，横线的颜色跟随label字体颜色改变
        [attri addAttribute:NSStrikethroughColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange(0, oldPriceStr.length-[TransOutput(@"含税") length])];
        self.oldPriceLabel.textColor  = RGB(0xA1A0A0);
        self.oldPriceLabel.attributedText = attri;
    }
    else{
        self.oldPriceLabel.text = @"";
    }
    self.sKuLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"库存"),[NSString isNullStr:dic[@"stocks"]]];
    
//    NSString *soldms = @"";
//    soldms = [NSString stringWithFormat:@"%@",dic[@"soldNum"]];
//    if ([NSString isNullStr:soldms].length == 0) {
//        soldms = @"0";
//    }
//    self.shouLabel.text = [NSString stringWithFormat:@"%@%@",TransOutput(@"販売件数："),[NSString isNullStr:soldms]];
    ExecBlock(self.skuItemClickBlock,dic);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
