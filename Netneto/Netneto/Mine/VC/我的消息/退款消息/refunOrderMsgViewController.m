//
//  refunOrderMsgViewController.m
//  Netneto
//
//  Created by apple on 2025/2/24.
//

#import "refunOrderMsgViewController.h"
#import "refunOrderMsgTableViewCell.h"
@interface refunOrderMsgViewController ()<UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;

@end

@implementation refunOrderMsgViewController
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(void)returnClick{
    [self popViewControllerAnimate];
}
- (void)initData{
     UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
    
}


-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.title = self.titleStr;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.top.mas_offset(109);
    }];
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    [self getListData];
    // Do any additional setup after loading the view.
}
-(void)getListData{
  
//    self.dataArray = @[@"1",@"1"];
//    [self.tableView reloadData];
//
    
    [[Socket sharedSocketTool] ImRefundMsgInfo:self.page pagesize:10 channel:self.imchannel];
    @weakify(self);
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        @strongify(self);
        [self receiveData:data];
    }];
}
#pragma mark - 接收消息
-(void)receiveData:(NSData *)data{
    ImMsgBody *body = [ImMsgBody parseFromData:data error:nil];
    int msgType = body.msgType;


    if (msgType == 11005 ) {
        ImRefundMsgInfoResp *resp = [ImRefundMsgInfoResp parseFromData:body.bytesData error:nil];
        
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
        [self.dataArray addObjectsFromArray:resp.imRefundMsgInfoArray];

                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
              

        

       
        NSLog(@"收到退款详情消息%@",resp.imRefundMsgInfoArray);
        
    }
    
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImRefundMsgInfo *dic = self.dataArray[indexPath.row];
    if (dic.refundType == 1) {
        
        refunOrderMsgTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"refunOrderMsgTableViewCellTwo"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"refunOrderMsgTableViewCellTwo" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        cell.model = dic;
       
        return cell;
    }else{
        refunOrderMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refunOrderMsgTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"refunOrderMsgTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        cell.model = dic;
       
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImRefundMsgInfo *model = self.dataArray[indexPath.row];
    CGFloat wName = [Tool getLabelWidthWithText:TransOutput(@"商品名称") height:17 font:12];
    CGFloat shopNameW = WIDTH - 32 - 12 - wName -10;
    CGFloat shopNameH = [Tool getLabelHeightWithText:model.prodName width:shopNameW font:12];
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@  %@",model.returnProvince,model.returnCity,model.returnArea,model.returnAddress];
    
    CGFloat addH = [Tool getLabelHeightWithText:str width:shopNameW font:12];
    if (shopNameH < 17) {
        shopNameH = 17;
//        return 355;
    }
    if (addH < 17) {
        addH = 17;
    }
    if (model.refundType == 1) {
        return 255 + shopNameH - 57;
    }else{
        return 275 + shopNameH + addH + 10 + 17;
        
    }
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImRefundMsgInfo *model = self.dataArray[indexPath.row];
    OrderDetailInfoRefunViewController *vc = [[OrderDetailInfoRefunViewController alloc] init];
    vc.refundId =[NSString stringWithFormat:@"%lld",model.refundId];
    vc.orderNumber = model.orderNumber;
    [self pushController:vc];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        _tableView.showsVerticalScrollIndicator = NO;
        @weakify(self)
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            
                self.page = 1;
                
            [self getListData];
           
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            
                self.page++;
                [self getListData];
            
        }];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
