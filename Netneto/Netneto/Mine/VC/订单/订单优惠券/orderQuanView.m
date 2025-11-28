//
//  orderQuanView.m
//  Netneto
//
//  Created by apple on 2025/2/5.
//

#import "orderQuanView.h"
@interface orderQuanView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic, strong)NSMutableArray *indexPathArr;
@property(nonatomic, strong)NSMutableArray *quanIdArray;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end
@implementation orderQuanView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
   
   
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    [self.sureBtn setTitle:TransOutput(@"确认") forState:UIControlStateNormal];
    self.titleLabel.text = TransOutput(@"优惠券");
    self.tableVIew.delegate = self;
    self.tableVIew.dataSource = self;
    self.tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.whiteView.layer.cornerRadius = 10;
    self.whiteView.clipsToBounds = YES;
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    ExecBlock(self.sureBlock,self.quanIdArray);
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    self.indexPathArr = [NSMutableArray array];

  
}
- (void)setSelCouponId:(NSString *)selCouponId{
    
    self.quanIdArray = [NSMutableArray array];
    if (selCouponId.length > 0) {
        [self.quanIdArray addObject:selCouponId];
    }
    [self.tableVIew reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderquanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderquanTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderquanTableViewCell" owner:self options:nil].lastObject;
    }

    
    NSDictionary *itemDic = self.dataArray[indexPath.row];
    cell.dic = itemDic;
    cell.img1.image = [UIImage imageNamed:@"矩形 5127-2"];
    cell.img2.image = [UIImage imageNamed:@"矩形 5128-2"];
    cell.nameLabel.textColor = RGB(0xFF3344);
    cell.title.textColor = RGB(0x333333);
    cell.timeLabel.textColor = RGB(0xFF3344);
    NSString *price = [NSString ChangePriceStr:[NSString stringWithFormat:@"%@",itemDic[@"value"]]];

    if ([itemDic[@"type"] intValue] == 2) {

        NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,TransOutput(@"元")];
        cell.nameLabel.text = str;
    }
  else  if ([itemDic[@"type"] intValue] == 0) {
      NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,TransOutput(@"元")];
        cell.nameLabel.text =str;
      
    }
    
  else{
      NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,@"%"];
      cell.nameLabel.text =str;
//      cell.nameLabel.text =itemDic[@"title"];
  }
    cell.timeLabel.text = [NSString stringWithFormat:@"%@%@",itemDic[@"endTime"],TransOutput(@"到期")];
    cell.title.text = itemDic[@"name"];
   
    cell.desLabel.text = itemDic[@"description"];
    NSString *str = [NSString stringWithFormat:@"%@",itemDic[@"couponId"]];
    if ([self.quanIdArray containsObject:str]) {
        cell.lingBtn.selected = YES;
    }
    [cell setAddQuanBlock:^(NSDictionary * _Nonnull dic) {
        if ([self.quanIdArray containsObject:[NSString stringWithFormat:@"%@",dic[@"couponId"]]]) {
            [self.quanIdArray removeObject:[NSString stringWithFormat:@"%@",dic[@"couponId"]]];
        }else{
            if (self.quanIdArray.count > 0) {
                [self.quanIdArray removeAllObjects];
                [self.quanIdArray addObject:[NSString stringWithFormat:@"%@",dic[@"couponId"]]];
               
            }else{
                [self.quanIdArray addObject:[NSString stringWithFormat:@"%@",dic[@"couponId"]]];
            }
        }
        [self.tableVIew reloadData];
    }];
    
    if ([_indexPathArr containsObject:indexPath]) {
        [cell openCell:YES];
        [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
        [cell.indureBtn setImage:[UIImage imageNamed:@"path-29"] forState:UIControlStateNormal];
        [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    }else {
        [cell openCell:NO];
        [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
        [cell.indureBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
        [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    }
    
    
    __block UITableView *tempTable = _tableVIew;
       __block NSIndexPath *tempIndexPath = indexPath;
    @weakify(self);
       cell.moreInfo = ^(BOOL open){
           @strongify(self);
           if (open) {
               [self.indexPathArr addObject:tempIndexPath];
           }else
           {
               [self.indexPathArr removeObject:tempIndexPath];
           }
           [tempTable reloadData];
       };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //这里应该做高度缓存的，我这里只是demo就省略了，你自己做高度缓存
    
    if ([_indexPathArr containsObject:indexPath]) {
        NSDictionary *itemDic = self.dataArray[indexPath.row];
        
        CGFloat h = [Tool getLabelHeightWithText:itemDic[@"description"] width:WIDTH - 58 font:8];
        
        return 120 + h;
       
    }else {
        return 93;
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
