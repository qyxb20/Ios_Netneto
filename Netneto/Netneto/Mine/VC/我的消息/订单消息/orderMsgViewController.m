//
//  orderMsgViewController.m
//  Netneto
//
//  Created by apple on 2025/2/24.
//

#import "orderMsgViewController.h"

@interface orderMsgViewController ()<UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;

@end

@implementation orderMsgViewController
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
    
    [[Socket sharedSocketTool] getImDvyMsgInfo:self.page pagesize:10 channel:self.imchannel];
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


    if (msgType == 10005 ) {
        ImDvyMsgInfoResp *resp = [ImDvyMsgInfoResp parseFromData:body.bytesData error:nil];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            self.dataOrderArray = [NSMutableArray array];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:resp.imDvyMsgInfoListArray];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
              
//            });
//            
//        });
        

       
        NSLog(@"收到订单详情消息%@",resp.imDvyMsgInfoListArray);
        
    }
    
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return self.dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    orderMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderMsgTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"orderMsgTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    ImDvyMsgInfo *dic = self.dataArray[indexPath.row];
    cell.model = dic;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImDvyMsgInfo *model = self.dataArray[indexPath.row];
    CGFloat wName = [Tool getLabelWidthWithText:TransOutput(@"商品名称") height:17 font:12];
    CGFloat shopNameW = WIDTH - 32 - 12 - wName -10;
    
  
    CGFloat shopNameH = [Tool getLabelHeightWithText:model.prodName width:shopNameW font:12];
   
    
    if (shopNameH < 17) {
        shopNameH = 17;
        return 180 ;
    }
    else{
        return 163 + shopNameH ;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImDvyMsgInfo *model = self.dataArray[indexPath.row];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderNumber =model.orderNumber;
//    vc.staus = @"3";
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
