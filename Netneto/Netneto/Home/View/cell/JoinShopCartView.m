//
//  JoinShopCartView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/8.
//

#import "JoinShopCartView.h"
@interface JoinShopCartView ()<PPNumberButtonDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *shopPic;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinCar;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PPNumberButton *numberButton;
@property (nonatomic, strong) UILabel *limitSumLabel;

@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,assign) NSInteger idx1;
@property (nonatomic,assign) NSInteger idx2;
@property (nonatomic,assign) NSInteger idx3;
@property (nonatomic,assign) NSInteger idx4;
@property (nonatomic,strong) NSString *jsonStr;
@property (nonatomic,strong) NSString *jsonStrPer;
@property (weak, nonatomic) IBOutlet UILabel *choseLabel;
@property (nonatomic,strong) NSDictionary *selDic;
@end
static NSString *cellID = @"JoinShopCartTableViewCell";
@implementation JoinShopCartView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
   
    self.joinCar.backgroundColor =[UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
   
    [self.topView addSubview:self.numberButton];
    [self.topView addSubview:self.limitSumLabel];
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-16);
        make.bottom.mas_equalTo(-32);
        make.height.mas_offset(22);
        make.width.mas_offset(90);
    }];
    [self.limitSumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-5);
        make.bottom.mas_equalTo(-12);
        make.height.mas_offset(14);
    }];
    self.numberButton.currentNumber = 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
}
#pragma mark - 数量
- (PPNumberButton *)numberButton {
    if (!_numberButton) {
        _numberButton = [[PPNumberButton alloc] initWithFrame:CGRectZero];
        _numberButton.backgroundColor = [UIColor whiteColor];
        _numberButton.borderColor = [UIColor whiteColor];
        _numberButton.increaseImage = [UIImage imageNamed:@"add-01"];
        _numberButton.decreaseImage = [UIImage imageNamed:@"munus"];
        _numberButton.currentNumber = 1;
        _numberButton.editing = YES;
        _numberButton.isCar = NO;
        _numberButton.delegate = self;
        @weakify(self);
        [_numberButton setTipBlock:^(NSString *str) {
            @strongify(self);
                 ToastShow(TransOutput(str), errImg,RGB(0xFF830F));
 
        }];
    }
    return _numberButton;
}
#pragma mark -限制文字label
-(UILabel *)limitSumLabel{
    if (!_limitSumLabel) {
        _limitSumLabel = [[UILabel alloc] init];
        _limitSumLabel.font = [UIFont systemFontOfSize:10];
        _limitSumLabel.textColor = RGB(0x838383);
        _limitSumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _limitSumLabel;
}
#pragma mark - 更新数据
-(void)updataWithDic:(NSDictionary *)dataDic{
    self.dataDic = dataDic;
    self.selDic = self.selecSkuDic;
    NSString *limitSum = [NSString isNullStr:dataDic[@"limitSum"]];
    self.shopNameLabel.text = [NSString isNullStr:dataDic[@"prodName"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:self.selecSkuDic[@"price"]]];
    self.stockLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"库存"),[NSString isNullStr:self.selecSkuDic[@"stocks"]]];
    [self.shopPic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:self.selecSkuDic[@"pic"]]] placeholderImage:[UIImage imageNamed:@"tupian"]];
    self.dataSource = [NSMutableArray array];
    self.dataSource = [NSMutableArray arrayWithArray:dataDic[@"skuVos"]];
    NSString *strPer =[NSString isNullStr:self.selecSkuDic[@"properties"]];
    self.numberButton.stockValue =[self.selecSkuDic[@"stocks"] intValue];
    self.numberButton.limValue =[limitSum floatValue];
    self.numberButton.currentNumber = 1;
    self.numberButton.minValue = 1;
    if ([self.selecSkuDic[@"stocks"] intValue] == 0) {
 
        self.numberButton.maxValue = 1;
    }else{
 
        if ([self.selecSkuDic[@"stocks"] floatValue] < [limitSum floatValue]) {
            self.numberButton.maxValue = [self.selecSkuDic[@"stocks"] floatValue];
 
            self.limitSumLabel.text = @"";
 
        }
        else{
            if ([limitSum floatValue] == 0) {
                self.numberButton.maxValue = [self.selecSkuDic[@"stocks"] floatValue];
                self.limitSumLabel.text =@"";
            }else{
                self.numberButton.maxValue = [limitSum floatValue];
                self.limitSumLabel.text =[NSString stringWithFormat:@"(1回の購入は%.0f点まで)",[limitSum floatValue] ];}
        }
    }
    
    if (self.dataSource.count == 1) {
        NSArray *arr = self.dataSource[0][@"skuVos"];
        for (int i = 0; i< arr.count;i++) {
            if ([strPer containsString:arr[i]]) {
                self.idx1 = i;
             }
        }
    }
    
    if (self.dataSource.count == 2) {
        NSArray *arr = self.dataSource[0][@"skuVos"];
        for (int i = 0; i< arr.count;i++) {
            if ([strPer containsString:arr[i]]) {
                self.idx1 = i;
             }
        }
        NSArray *arrT = self.dataSource[1][@"skuVos"];
        for (int i = 0; i< arrT.count;i++) {
            if ([strPer containsString:arrT[i]]) {
                self.idx2 = i;
             }
        }
    }
    if (self.dataSource.count == 3) {
        NSArray *arr = self.dataSource[0][@"skuVos"];
        for (int i = 0; i< arr.count;i++) {
            if ([strPer containsString:arr[i]]) {
                self.idx1 = i;
             }
        }
        NSArray *arrT = self.dataSource[1][@"skuVos"];
        for (int i = 0; i< arrT.count;i++) {
            if ([strPer containsString:arrT[i]]) {
                self.idx2 = i;
             }
        }
        NSArray *arrTh = self.dataSource[2][@"skuVos"];
        for (int i = 0; i< arrTh.count;i++) {
            if ([strPer containsString:arrTh[i]]) {
                self.idx3 = i;
             }
        }
    }
    if (self.dataSource.count == 4) {
        NSArray *arr = self.dataSource[0][@"skuVos"];
        for (int i = 0; i< arr.count;i++) {
            if ([strPer containsString:arr[i]]) {
                self.idx1 = i;
             }
        }
        NSArray *arrT = self.dataSource[1][@"skuVos"];
        for (int i = 0; i< arrT.count;i++) {
            if ([strPer containsString:arrT[i]]) {
                self.idx2 = i;
             }
        }
        NSArray *arrTh = self.dataSource[2][@"skuVos"];
        for (int i = 0; i< arrTh.count;i++) {
            if ([strPer containsString:arrTh[i]]) {
                self.idx3 = i;
             }
        }
        NSArray *arrTF = self.dataSource[3][@"skuVos"];
        for (int i = 0; i< arrTF.count;i++) {
            if ([strPer containsString:arrTF[i]]) {
                self.idx4 = i;
             }
        }
    }
    [self.tableView reloadData];
    
    if (self.dataSource.count == 1) {
        self.jsonStr = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]]];
        
    }
    if (self.dataSource.count == 2) {
        self.jsonStr = [NSString stringWithFormat:@"%@、%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]]];
    }
    if (self.dataSource.count == 3) {
        self.jsonStr = [NSString stringWithFormat:@"%@、%@、%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]],[NSString isNullStr:self.dataSource[2][@"skuVos"][self.idx3]]];
    }
    if (self.dataSource.count == 4) {
        self.jsonStr = [NSString stringWithFormat:@"%@、%@、%@、%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]],[NSString isNullStr:self.dataSource[2][@"skuVos"][self.idx3]],[NSString isNullStr:self.dataSource[3][@"skuVos"][self.idx4]]];
    }
//    self.choseLabel.text = [NSString stringWithFormat:@"%@：%@",TransOutput(@"已选择"),[NSString isNullStr:self.selecSkuDic[@"properties"]]];
    self.jsonStrPer =[NSString stringWithFormat:@"%@：%@",TransOutput(@"已选择"),[NSString isNullStr:self.selecSkuDic[@"properties"]]];
    self.choseLabel.text = [NSString stringWithFormat:@"%@：%@",TransOutput(@"已选择"),self.jsonStr];
  
    @weakify(self);
    if (self.isJoin) {
        [self.joinCar setTitle:TransOutput(@"加入购物车") forState:UIControlStateNormal];
        [self.joinCar addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            
            if ([self.selDic[@"stocks"] intValue] == 0){
                ToastShow(TransOutput(@"库存不足"), errImg,RGB(0xFF830F));
                
            }else{
                ExecBlock(self.joinItemClickBlock,self.selDic,self.numberButton.currentNumber);
            }
        }];
    }
    else{
       
        [self.joinCar setTitle:TransOutput(@"立即购买") forState:UIControlStateNormal];
        [self.joinCar addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            if ([self.selDic[@"stocks"] intValue] == 0){
                ToastShow(TransOutput(@"库存不足"), errImg,RGB(0xFF830F));
                
            }else{
                ExecBlock(self.NowBuyClickBlock,self.selDic,self.numberButton.currentNumber);
            }
        }];
    }
}

- (IBAction)closeClick:(UIButton *)sender {
    [self removeFromSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JoinShopCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self congifCell:cell indexpath:indexPath];
    return cell;
}
#pragma mark - 切换规格
- (void)congifCell:(JoinShopCartTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    if (indexpath.row < self.dataSource.count) {
        UIColor *selectedColor = RGB(0x5D84A8);
        cell.leftTitleLabel.text = [NSString stringWithFormat:@"%@:",[NSString isNullStr:self.dataSource[indexpath.row][@"sku"]]];
        [cell.tagView removeAllTags];
        // 这东西非常关键
        cell.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 70;
        cell.tagView.padding = UIEdgeInsetsMake(5, 10, 5, 10);
        cell.tagView.lineSpacing = 20;
        cell.tagView.interitemSpacing = 11;
        
        NSArray *arr = self.dataSource[indexpath.row][@"skuVos"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SKTag *tag = [[SKTag alloc] initWithText:arr[idx]];
            tag.font = [UIFont boldSystemFontOfSize:13];
//
//            tag.bgImg = [UIImage imageNamed:@"FE9C970DA8AD4263ABA40AFA572A0538.jpg"];
            tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
            tag.cornerRadius = 5;
            tag.borderWidth = 0;
            if (indexpath.row == 0) {
                if (idx == self.idx1) {
                    tag.textColor = selectedColor;
                    tag.bgColor = RGB(0xE1EEFA);
                }

            }
            else if (indexpath.row == 1)
            {
                if (idx == self.idx2) {
                    tag.textColor = selectedColor;
                    tag.bgColor = RGB(0xE1EEFA);
                }

            }
            else if (indexpath.row == 2)
            {
                if (idx == self.idx3) {
                    tag.textColor = selectedColor;
                    tag.bgColor = RGB(0xE1EEFA);
                }

            }
            else if (indexpath.row == 3)
            {
                if (idx == self.idx4) {
                    tag.textColor = selectedColor;
                    tag.bgColor = RGB(0xE1EEFA);
                }

            }
            [cell.tagView addTag:tag];
            
            
        }];
        
        cell.tagView.didTapTagAtIndex = ^(NSUInteger idx,SKTagView *tagView)
        {
            
            JoinShopCartTableViewCell *cell = (JoinShopCartTableViewCell *)[[tagView superview] superview];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath.row == 0) {
                self.idx1 = idx;
            }
            else if (indexPath.row == 1)
            {
                self.idx2 = idx;
            }
            else if (indexPath.row == 2)
            {
                self.idx3 = idx;
            }
            else if (indexPath.row == 3)
            {
                self.idx4 = idx;
            }
            NSLog(@"点击了第%ld行，第%ld个",indexPath.row,idx);
            if (self.dataSource.count == 1) {
                self.jsonStr = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][idx]]];
                
                self.jsonStrPer =[NSString stringWithFormat:@"%@:%@",[NSString isNullStr:self.dataSource[0][@"sku"]],[NSString isNullStr:self.dataSource[0][@"skuVos"][idx]]];
            }
            if (self.dataSource.count == 2) {
                self.jsonStr = [NSString stringWithFormat:@"%@、%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]]];
                
                self.jsonStrPer =[NSString stringWithFormat:@"%@:%@;%@:%@",[NSString isNullStr:self.dataSource[0][@"sku"]],[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"sku"]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]]];
            }
            if (self.dataSource.count == 3) {
                self.jsonStr = [NSString stringWithFormat:@"%@、%@、%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]],[NSString isNullStr:self.dataSource[2][@"skuVos"][self.idx3]]];
                self.jsonStrPer =[NSString stringWithFormat:@"%@:%@;%@:%@;%@:%@",[NSString isNullStr:self.dataSource[0][@"sku"]],[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"sku"]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]],[NSString isNullStr:self.dataSource[2][@"sku"]],[NSString isNullStr:self.dataSource[2][@"skuVos"][self.idx3]]];
            }
            if (self.dataSource.count == 4) {
                self.jsonStr = [NSString stringWithFormat:@"%@、%@、%@、%@",[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]],[NSString isNullStr:self.dataSource[2][@"skuVos"][self.idx3]],[NSString isNullStr:self.dataSource[3][@"skuVos"][self.idx4]]];
                self.jsonStrPer =[NSString stringWithFormat:@"%@:%@;%@:%@;%@:%@;%@:%@",[NSString isNullStr:self.dataSource[0][@"sku"]],[NSString isNullStr:self.dataSource[0][@"skuVos"][self.idx1]],[NSString isNullStr:self.dataSource[1][@"sku"]],[NSString isNullStr:self.dataSource[1][@"skuVos"][self.idx2]],[NSString isNullStr:self.dataSource[2][@"sku"]],[NSString isNullStr:self.dataSource[2][@"skuVos"][self.idx3]],[NSString isNullStr:self.dataSource[3][@"sku"]],[NSString isNullStr:self.dataSource[3][@"skuVos"][self.idx4]]];
            }
            NSArray *arr = self.dataDic[@"skuList"];
            for (NSDictionary *dic in arr) {
                if ([dic[@"properties"] isEqual:self.jsonStrPer]) {
                    [self.shopPic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
                    self.stockLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"库存"),[NSString isNullStr:dic[@"stocks"]]];
                    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:dic[@"price"]]];
                    self.numberButton.minValue = 1;
                    self.numberButton.currentNumber = 1;
//                    self.numberButton.maxValue = [dic[@"stocks"] floatValue];
                    NSString *limitSum = [NSString isNullStr:self.dataDic[@"limitSum"]];
                    
                    self.numberButton.stockValue =[dic[@"stocks"] floatValue];
                    self.numberButton.limValue =[limitSum floatValue];
                    if ([dic[@"stocks"] floatValue] < [limitSum floatValue]) {
//                        self.numberButton.maxValue = [dic[@"stocks"] floatValue];
                        if ([dic[@"stocks"] floatValue] == 0) {
                            self.numberButton.maxValue =1 ;
                        }else{
                            self.numberButton.maxValue = [dic[@"stocks"] floatValue];
                        }
                        self.limitSumLabel.text = @"";
//                        self.limitSumLabel.text =[NSString stringWithFormat:@"(1回の購入は%.0f点まで)",[self.selecSkuDic[@"stocks"] floatValue] ];
                        
                    }
                    else{
                        if ([limitSum floatValue] == 0) {
                            if ([dic[@"stocks"] floatValue] == 0) {
                                self.numberButton.maxValue = 1;
                            }
                            else{
                                self.numberButton.maxValue = [dic[@"stocks"] floatValue];
                            }
                            self.limitSumLabel.text =@"";
                        }else{
                            self.numberButton.maxValue = [limitSum floatValue];
                            self.limitSumLabel.text =[NSString stringWithFormat:@"(1回の購入は%.0f点まで)",[limitSum floatValue] ];}
                    }
                    self.selDic = dic;
                }
            }
            NSLog(@"选择了：%@",self.jsonStr);
            self.choseLabel.text = [NSString stringWithFormat:@"%@：%@",TransOutput(@"已选择"),self.jsonStr];
           
//            if (![self.jsonArr containsObject:self.jsonStr]) {
//                [self.jsonArr addObject:self.jsonStr];
//            }
            
//            = [NSString stringWithFormat:@"%@:%@,%@:%@",[self.dataSource[0] allKeys][0],[self.dataSource[0] allValues][0][self.idx1],[self.dataSource[1] allKeys][0],[self.dataSource[1] allValues][0][self.idx2]];
            [self.tableView reloadData];

        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return [tableView fd_heightForCellWithIdentifier:cellID cacheByIndexPath:indexPath configuration:^(id cell) {
           
            [self congifCell:cell indexpath:indexPath];
        }];
    
}
- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus {
    if (self.updateGoodsQuantityBlock) {
        self.updateGoodsQuantityBlock(number);
    }
}
-(void)pp_CustomNumberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus{
    if (self.updateGoodsQuantityBlock) {
        self.updateGoodsQuantityBlock(number);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
