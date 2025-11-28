//
//  LiveShopCartView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "LiveShopCartView.h"
@interface LiveShopCartView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, strong)NSString *channel;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSString *isadmin;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation LiveShopCartView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
    self.titleLabel.text = TransOutput(@"商品列表");
    self.publishBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    [self.publishBtn setTitle:TransOutput(@"添加商品") forState:UIControlStateNormal];
    [self.publishBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
        ExecBlock(self.addShopBlock);
    }];
  
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无商品");
    }
    return _nothingView;
}
-(void)updataList:(NSString *)Channel isadmin:(NSString *)isadmin{
    self.channel = Channel;
    self.isadmin = isadmin;
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    [self.collectionView removeFromSuperview];
    [self addSubview:self.collectionView];
    if ([isadmin isEqual:@"1"]) {
        self.publishBtn.hidden = NO;
        self.pubHeight.constant = 44;
        self.isShowDown = YES;
    }
    else{
        self.publishBtn.hidden = YES;
        self.pubHeight.constant = 0;
        self.isShowDown = NO;
    }
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.publishBtn.mas_top).offset(-10);
    }];
   
    [NetwortTool getLiveShopCarListWithParm:@{@"channel":Channel,@"pageNum":@(self.page),@"pageSize":@(10)} Success:^(id  _Nonnull responseObject) {
        NSArray *arr = responseObject;
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
            
        }
        [self.dataArr addObjectsFromArray:arr];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.nothingView.topCustom.constant = 80;
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, 200);
        
      if (self.dataArr.count == 0) {
          self.collectionView.backgroundView = self.nothingView;
         
      }
      else{
         
          self.collectionView.backgroundView = nil;
      }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
     
    }];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((WIDTH - 64) / 2,260);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"LiveShopCarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LiveShopCarCollectionViewCell"];
        
        @weakify(self);
        _collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self updataList:self.channel isadmin:self.isadmin];
        }];
        _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self updataList:self.channel isadmin:self.isadmin];
        }];
       
        }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LiveShopCarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveShopCarCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveShopCarCollectionViewCell" owner:self options:nil].lastObject;
    }

    if (self.dataArr.count > 0) {
        NSDictionary *dic = self.dataArr[indexPath.item];
       
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
        
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
        cell.titleLabel.text = [NSString isNullStr:dic[@"prodName"]];
        
        
        
        NSString *priceStr = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:[NSString isNullStr:dic[@"price"]]]];
        
        NSString *oldPriceStr =[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:[NSString isNullStr:dic[@"oriPrice"]]]];
        
        NSString *newPriStr = [NSString stringWithFormat:@"%@ %@",priceStr,oldPriceStr];
        if (![oldPriceStr isEqual:priceStr]) {
            
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:newPriStr];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(priceStr.length, oldPriceStr.length)];// 如果不加这个，横线的颜色跟随label字体颜色改变
        [attri addAttribute:NSStrikethroughColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange(priceStr.length, oldPriceStr.length)];
            [attri addAttribute:NSForegroundColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange(priceStr.length +1, oldPriceStr.length)];
                [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(priceStr.length +1, oldPriceStr.length)];
                [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0 , priceStr.length)];
        
            cell.priceLabel.attributedText = attri;
        }
        else{
            cell.priceLabel.text =priceStr;
            cell.priceLabel.font = [UIFont systemFontOfSize:14];
     
     }

        cell.oripriceLabel.font = [UIFont systemFontOfSize:11];
  NSString *soldNum = [NSString stringWithFormat:@"%@",dic[@"soldNum"]];
  if ([[NSString isNullStr:soldNum] length] > 0) {
      cell.oripriceLabel.text =[NSString stringWithFormat:@"%@%@",[NSString isNullStr:soldNum],TransOutput(@"件 販売済み") ];

  }else{
      cell.oripriceLabel.text =[NSString stringWithFormat:@"%@%@",@"0",TransOutput(@"件 販売済み")];

  }
    
    if (_isShowDown) {
            cell.jiaBtn.hidden = NO;
            @weakify(self)
            [cell.jiaBtn addTapAction:^(UIView * _Nonnull view) {
                @strongify(self);
                CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否确定下架？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
                    [self downShopGoods:dic];
                } cancelBlock:^{
                    
                }];
                [alert show];
                
                
            }];
        }
        else{
            cell.jiaBtn.hidden = YES;
        }
    }
   
    
        return cell;
}
-(void)downShopGoods:(NSDictionary*)dic{
    [NetwortTool getDownShowShopCarListWithParm:@{@"cartId":dic[@"cartId"]} Success:^(id  _Nonnull responseObject) {
        NSLog(@"下架信息：%@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            ToastShow(TransOutput(@"下架成功"), @"chenggong",RGB(0x36D053));
            [self.dataArr removeObject:dic];
            [self.collectionView reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ExecBlock(self.pushGoodDetailBlock,self.dataArr[indexPath.item]);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
