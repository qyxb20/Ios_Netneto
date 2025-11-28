//
//  MineMsgViewController.m
//  Netneto
//
//  Created by apple on 2025/2/24.
//

#import "MineMsgViewController.h"

@interface MineMsgViewController ()<UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *refunBtn;
@property (weak, nonatomic) IBOutlet UILabel *keNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *refunNumber;

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic,strong)SRWebSocket *socket;
@property (nonatomic, strong) NothingView *nothingView;

@property(nonatomic, assign)NSInteger pageOrder;
@property(nonatomic, strong)NSMutableArray *dataOrderArray;

@property(nonatomic, assign)NSInteger pageRefun;
@property(nonatomic, strong)NSMutableArray *dataRefunArray;
 
@end

@implementation MineMsgViewController
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
    self.pageOrder = 1;
    self.pageRefun = 1;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    
}
#pragma mark - 接收消息
-(void)receiveData:(NSData *)data{
    [HudView hideHudForView:self.view];
    ImMsgBody *body = [ImMsgBody parseFromData:data error:nil];
    int msgType = body.msgType;

if (msgType == 101) {
    /**
         * 获取聊天列表
         */
//        int IM_MSG_LIST_REQ = 100;
//        int IM_MSG_LIST_RESP = 101;

    MsgListResp *resp = [MsgListResp parseFromData:body.bytesData error:nil];
    if (resp.msgUnReadCount > 0) {
        self.keNumber.hidden = NO;
        self.keNumber.text = [NSString stringWithFormat:@"%d",resp.msgUnReadCount];
    }else{
        self.keNumber.hidden = YES;
    }
    if (resp.dvyUnReadCount > 0) {
        self.orderNumLabel.hidden = NO;
        self.orderNumLabel.text = [NSString stringWithFormat:@"%d",resp.dvyUnReadCount];
    }else{
        self.orderNumLabel.hidden = YES;
    }
    if (resp.refundUnReadCount > 0) {
        self.refunNumber.hidden = NO;
        self.refunNumber.text = [NSString stringWithFormat:@"%d",resp.refundUnReadCount];
    }else{
        self.refunNumber.hidden = YES;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.dataArray = [NSMutableArray array];
        
        [self.dataArray addObjectsFromArray:resp.imMsgListArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.dataArray.count == 0) {
                self.nothingView.titleLabel.text = TransOutput(@"暂无消息");
                self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
                self.nothingView.topCustom.constant = 80;
                  self.tableView.backgroundView = self.nothingView;
                 
              }
              else{
                 
                  self.tableView.backgroundView = nil;
              }
        });
        
    });
    

   
    NSLog(@"收到消息%@",resp.imMsgListArray);
    
}
    if (msgType == 10007) {
        /**
             * 清除发货列表
             * 修改时间 2025/03/05 （发货、退款信息推送）
             */
//            int IM_DELETE_DVYMSG_INFO_REQ = 10006;
//            int IM_DELETE_DVYMSG_INFO_RESP = 10007;

        DvyListDeleteResp *resp = [DvyListDeleteResp parseFromData:body.bytesData error:nil];
        if (resp.msgUnReadCount > 0) {
            self.keNumber.hidden = NO;
            self.keNumber.text = [NSString stringWithFormat:@"%d",resp.msgUnReadCount];
        }else{
            self.keNumber.hidden = YES;
        }
        if (resp.dvyUnReadCount > 0) {
            self.orderNumLabel.hidden = NO;
            self.orderNumLabel.text = [NSString stringWithFormat:@"%d",resp.dvyUnReadCount];
        }else{
            self.orderNumLabel.hidden = YES;
        }
        if (resp.refundUnReadCount > 0) {
            self.refunNumber.hidden = NO;
            self.refunNumber.text = [NSString stringWithFormat:@"%d",resp.refundUnReadCount];
        }else{
            self.refunNumber.hidden = YES;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            ImDvyMsgList *model =resp.imDvyMsgList;
            if (model.imChannel.length > 0) {
                [self.dataOrderArray addObject:resp.imDvyMsgList];
            
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                if (self.dataOrderArray.count == 0) {
                    self.nothingView.titleLabel.text = TransOutput(@"现在没有订单发送通知");
                    self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
                    self.nothingView.topCustom.constant = 80;
                      self.tableView.backgroundView = self.nothingView;
                     
                  }
                  else{
                     
                      self.tableView.backgroundView = nil;
                  }
            });
            
           
        });
    }
    if (msgType == 10003) {
        /**
             * 获取发货列表
             * 修改时间 2025/02/27 （发货、退款信息推送）
             */
//            int IM_DVYMSG_LIST_REQ = 10002;
//            int IM_DVYMSG_LIST_RESP = 10003;
        DvyMsgListResp *resp = [DvyMsgListResp parseFromData:body.bytesData error:nil];
        if (resp.msgUnReadCount > 0) {
            self.keNumber.hidden = NO;
            self.keNumber.text = [NSString stringWithFormat:@"%d",resp.msgUnReadCount];
        }else{
            self.keNumber.hidden = YES;
        }
        if (resp.dvyUnReadCount > 0) {
            self.orderNumLabel.hidden = NO;
            self.orderNumLabel.text = [NSString stringWithFormat:@"%d",resp.dvyUnReadCount];
        }else{
            self.orderNumLabel.hidden = YES;
        }
        if (resp.refundUnReadCount > 0) {
            self.refunNumber.hidden = NO;
            self.refunNumber.text = [NSString stringWithFormat:@"%d",resp.refundUnReadCount];
        }else{
            self.refunNumber.hidden = YES;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            if (self.pageOrder == 1) {
                [self.dataOrderArray removeAllObjects];
            }
            
            if (resp.imDvyMsgListsArray.count == 0 && self.pageOrder > 1) {
                self.pageOrder --;
            }
            [self.dataOrderArray addObjectsFromArray:resp.imDvyMsgListsArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                if (self.dataOrderArray.count == 0) {
                    self.nothingView.titleLabel.text = TransOutput(@"现在没有订单发送通知");
                    self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
                    self.nothingView.topCustom.constant = 80;
                      self.tableView.backgroundView = self.nothingView;
                     
                  }
                  else{
                     
                      self.tableView.backgroundView = nil;
                  }
            });
            
        });
        

       
        NSLog(@"收到订单消息%@",resp.imDvyMsgListsArray);
        
    }
    
    if (msgType == 11003) {
        /**
            * 获取退货列表
            * 修改时间 2025/02/27 （发货、退款信息推送）
            */
//           int IM_REFUNDMSG_LIST_REQ = 11002;
//           int IM_REFUNDMSG_LIST_RESP = 11003;
        RefundMsgListResp *resp = [RefundMsgListResp parseFromData:body.bytesData error:nil];
        if (resp.msgUnReadCount > 0) {
            self.keNumber.hidden = NO;
            self.keNumber.text = [NSString stringWithFormat:@"%d",resp.msgUnReadCount];
        }else{
            self.keNumber.hidden = YES;
        }
        if (resp.dvyUnReadCount > 0) {
            self.orderNumLabel.hidden = NO;
            self.orderNumLabel.text = [NSString stringWithFormat:@"%d",resp.dvyUnReadCount];
        }else{
            self.orderNumLabel.hidden = YES;
        }
        if (resp.refundUnReadCount > 0) {
            self.refunNumber.hidden = NO;
            self.refunNumber.text = [NSString stringWithFormat:@"%d",resp.refundUnReadCount];
        }else{
            self.refunNumber.hidden = YES;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            self.dataRefunArray = [NSMutableArray array];
            if (self.pageRefun == 1) {
                [self.dataRefunArray removeAllObjects];
            }
            if (resp.imRefundMsgListsArray.count == 0 && self.pageRefun > 1) {
                self.pageRefun --;
            }
            [self.dataRefunArray addObjectsFromArray:resp.imRefundMsgListsArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                if (self.dataRefunArray.count == 0) {
                    self.nothingView.titleLabel.text = TransOutput(@"现在没有退款通知");
                    
                    self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
                    self.nothingView.topCustom.constant = 80;
                      self.tableView.backgroundView = self.nothingView;
                     
                  }
                  else{
                     
                      self.tableView.backgroundView = nil;
                  }
            });
            
        });
        

       
        NSLog(@"收到退款消息%@",resp.imRefundMsgListsArray);
        
    }
    
    if (msgType == 11007) {
        /**
             * 清除退货列表
             * 修改时间 2025/03/05 （发货、退款信息推送）
             */
//            int IM_DELETE_REFUND_LIST_REQ = 11006;
//            int IM_DELETE_REFUND_LIST_RESP = 11007;
        RefundListDeleteResp *resp = [RefundListDeleteResp parseFromData:body.bytesData error:nil];
        if (resp.msgUnReadCount > 0) {
            self.keNumber.hidden = NO;
            self.keNumber.text = [NSString stringWithFormat:@"%d",resp.msgUnReadCount];
        }else{
            self.keNumber.hidden = YES;
        }
        if (resp.dvyUnReadCount > 0) {
            self.orderNumLabel.hidden = NO;
            self.orderNumLabel.text = [NSString stringWithFormat:@"%d",resp.dvyUnReadCount];
        }else{
            self.orderNumLabel.hidden = YES;
        }
        if (resp.refundUnReadCount > 0) {
            self.refunNumber.hidden = NO;
            self.refunNumber.text = [NSString stringWithFormat:@"%d",resp.refundUnReadCount];
        }else{
            self.refunNumber.hidden = YES;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            ImRefundMsgList *model =resp.imRefundMsgList;
            if (model.imChannel.length > 0) {
                [self.dataRefunArray addObject:resp.imRefundMsgList];
            
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                if (self.dataRefunArray.count == 0) {
                    self.nothingView.titleLabel.text = TransOutput(@"现在没有退款通知");
                    self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
                    self.nothingView.topCustom.constant = 80;
                      self.tableView.backgroundView = self.nothingView;
                     
                  }
                  else{
                     
                      self.tableView.backgroundView = nil;
                  }
            });
            
        });
    }
if (msgType == 107 || msgType == 110) {
    //给用户端发送消息
//        int C2B_SEND_MSG_REQ = 107;
//    int C2B_SEND_LING_REQ = 110;
        [self loadData];

}

}

#pragma  mark - 获取消息数据
-(void)getListData{
    
    [[Socket sharedSocketTool] getImmsgList];
    @weakify(self);
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        @strongify(self);
        
        [self receiveData:data];
    }];
}

-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.title = TransOutput(@"我的消息");
    self.keNumber.hidden = YES;
    self.orderNumLabel.hidden = YES;
    self.refunNumber.hidden = YES;
    self.kefuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
   
    self.kefuBtn.titleLabel.numberOfLines = 0;
    self.kefuBtn.selected = YES;
    [self.kefuBtn setTitle:TransOutput(@"客服") forState:UIControlStateNormal];
    [self.kefuBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:5];
   
     self.orderMsgBtn.titleLabel.numberOfLines = 0;
    [self.orderMsgBtn setTitle:TransOutput(@"订单发送通知") forState:UIControlStateNormal];
    self.orderMsgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.orderMsgBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
   
    self.refunBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.refunBtn.titleLabel.numberOfLines = 0;
    [self.refunBtn setTitle:TransOutput(@"退款退货申请通知") forState:UIControlStateNormal];
    [self.refunBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
   
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.top.mas_offset(109 + 130);
    }];
    self.dataOrderArray = [NSMutableArray array];
    self.dataRefunArray = [NSMutableArray array];
    self.pageOrder = 1;
    self.pageRefun = 1;
    [HudView showHudForView:self.view];
    [self getListData];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadOrderMsg" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.pageOrder = 1;
            [self loadDataOrder];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadRefunMsg" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.pageRefun = 1;
            [self loadDataRefun];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadSixinMsg" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.page = 1;
            [self loadData];
        });
    }];
//    UISwipeGestureRecognizer *turnLeft =
//
//        [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnToLeft)];
//
//    turnLeft.direction=UISwipeGestureRecognizerDirectionLeft;//控制方向向左
//
//        [[self tableView] addGestureRecognizer:turnLeft];
//    UISwipeGestureRecognizer *turnRight =
//
//         [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(TurnToRight)];
//
//          turnRight.direction=UISwipeGestureRecognizerDirectionRight;//控制方向向右
//
//    [self.tableView addGestureRecognizer:turnRight];


   
    // Do any additional setup after loading the view from its nib.
}
-(void)turnToLeft{

    //添加手指向右滑动屏幕时执行的操作
        if (self.kefuBtn.selected) {
            self.orderMsgBtn.selected = YES;
            self.kefuBtn.selected = NO;
            self.refunBtn.selected = NO;
            self.nothingView.titleLabel.text = TransOutput(@"现在没有退款通知");
            [HudView showHudForView:self.view];
            [self loadDataOrder];
        }
      else  if (self.orderMsgBtn.selected) {
            self.refunBtn.selected = YES;
            self.kefuBtn.selected = NO;
            self.orderMsgBtn.selected = NO;
            self.nothingView.titleLabel.text = TransOutput(@"现在没有退款通知");
            [HudView showHudForView:self.view];
            [self loadDataOrder];
        }
}

-(void)TurnToRight{

    
    
    //添加手指向左滑动屏幕时执行的操作
        if (self.refunBtn.selected) {
            self.orderMsgBtn.selected = YES;
            self.kefuBtn.selected = NO;
            self.refunBtn.selected = NO;
            self.nothingView.titleLabel.text = TransOutput(@"现在没有退款通知");
            [HudView showHudForView:self.view];
            [self loadDataOrder];
        }
     else   if (self.orderMsgBtn.selected) {
            self.kefuBtn.selected = YES;
            self.refunBtn.selected = NO;
            self.orderMsgBtn.selected = NO;
            self.nothingView.titleLabel.text = TransOutput(@"暂无消息");
            [HudView showHudForView:self.view];
            [self loadData];
        }
    

}

#pragma mark -获取聊天列表
-(void)loadData{

    [[Socket sharedSocketTool] getImmsgList];
    @weakify(self);
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        @strongify(self);
        
        [self receiveData:data];
    }];
  
}
#pragma mark -获取发货列表列表
-(void)loadDataOrder{
    @weakify(self);
    [[Socket sharedSocketTool] getDvyMsgList:self.pageOrder pagesize:10];
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        @strongify(self);
        
        [self receiveData:data];
    }];
  
}
#pragma mark -获取退货列表
-(void)loadDataRefun{
    @weakify(self);
    [[Socket sharedSocketTool] getRefundMsgList:self.pageRefun pagesize:1];
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        @strongify(self);
        
        [self receiveData:data];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.kefuBtn.selected) {
        return self.dataArray.count;
    }
    else if (self.orderMsgBtn.selected){
        return self.dataOrderArray.count;
    }
    else{
        return self.dataRefunArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineMessageTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MineMessageTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (self.kefuBtn.selected) {
        
    
    ImMsgList *dic = self.dataArray[indexPath.row];
    
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:dic.userImg] placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
    cell.nameLabel.text = dic.name;
    cell.timeLabel.text = dic.endMsgTime;
    if (dic.contentType == 1) {

        NSData *jsonData = [dic.endMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        cell.desLabel.text =dict[@"prodName"];
    }else{
        cell.desLabel.text = dic.endMsg;
    }
    if (dic.unReadSize > 0) {
        cell.numlabel.hidden = NO;
        cell.numlabel.text = [NSString stringWithFormat:@"%d",dic.unReadSize];
    }
    else{
        cell.numlabel.hidden =YES;
    }
    }
    else if(self.orderMsgBtn.selected){
        ImDvyMsgList *dic = self.dataOrderArray[indexPath.row];
        
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:dic.shopImg] placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
        cell.nameLabel.text = dic.shopName;
        cell.timeLabel.text = dic.endMsgTime;
        
//        cell.desLabel.text = TransOutput(@"订单已发货");
        cell.desLabel.text = [NSString isNullStr:dic.endMsg];
        if (dic.unReadSize > 0) {
            cell.numlabel.hidden = NO;
            cell.numlabel.text = [NSString stringWithFormat:@"%d",dic.unReadSize];
        }
        else{
            cell.numlabel.hidden =YES;
        }
    }
    else{
        ImRefundMsgList *dic = self.dataRefunArray[indexPath.row];
        
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:dic.shopImg] placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
        cell.nameLabel.text = dic.shopName;
        cell.timeLabel.text = dic.endMsgTime;
        
        cell.desLabel.text = [NSString isNullStr:dic.endMsg];
        if (dic.unReadSize > 0) {
            cell.numlabel.hidden = NO;
            cell.numlabel.text = [NSString stringWithFormat:@"%d",dic.unReadSize];
        }
        else{
            cell.numlabel.hidden =YES;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.kefuBtn.selected) {
        MineMessDetailViewController *vc = [[MineMessDetailViewController alloc] init];
        ImMsgList *dic = self.dataArray[indexPath.row];
        if ([self.keNumber.text intValue] - dic.unReadSize >0) {
            self.keNumber.text = [NSString stringWithFormat:@"%d",[self.keNumber.text intValue] - dic.unReadSize];
            
        }
        else{
            self.keNumber.hidden = YES;
        }
        dic.unReadSize = 0;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.tableView reloadData];
        
        NSString *shopUserId;
        if ([dic.toUserId isEqual:account.userInfo.userId]) {
            shopUserId = dic.fromUserId;
        }
        else{
            shopUserId = dic.toUserId;
        }
        
        NSDictionary *dataDic = @{@"shopImg":dic.userImg,@"shopName":dic.name,@"shopUserId":shopUserId,@"shopId":[NSString stringWithFormat:@"%lld",dic.shopId]};
        vc.dataDic = dataDic;
        vc.ImsgChannel = dic.imChannel;
        vc.FromUserId = dic.fromUserId;
        vc.ToUserId = dic.toUserId;
        [self pushController:vc];
    }
    else if(self.orderMsgBtn.selected){
        ImDvyMsgList *dic = self.dataOrderArray[indexPath.row];
        if ([self.orderNumLabel.text intValue] - dic.unReadSize >0) {
            self.orderNumLabel.text = [NSString stringWithFormat:@"%d",[self.orderNumLabel.text intValue] - dic.unReadSize];
            
        }
        else{
            self.orderNumLabel.hidden = YES;
        }
        dic.unReadSize = 0;
        [self.dataOrderArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.tableView reloadData];
        orderMsgViewController *vc = [[orderMsgViewController alloc] init];
        vc.imchannel = dic.imChannel;
        vc.titleStr = dic.shopName;
        [self pushController:vc];
    }
    else{
        ImRefundMsgList *dic = self.dataRefunArray[indexPath.row];
        if ([self.refunNumber.text intValue] - dic.unReadSize >0) {
            self.refunNumber.text = [NSString stringWithFormat:@"%d",[self.refunNumber.text intValue] - dic.unReadSize];
            
        }
        else{
            self.refunNumber.hidden = YES;
        }
        
        dic.unReadSize = 0;
        [self.dataRefunArray replaceObjectAtIndex:indexPath.row withObject:dic];
        [self.tableView reloadData];
        refunOrderMsgViewController *vc = [[refunOrderMsgViewController alloc] init];
        vc.imchannel = dic.imChannel;
        vc.titleStr = dic.shopName;
        [self pushController:vc];
        
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete; // 指定侧滑出现的按钮类型为删除
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建一个删除按钮
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
           // 执行删除操作
        @weakify(self);
        if (self.kefuBtn.selected) {
            CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
                @strongify(self)
                ImMsgList *imMsgList = self.dataArray[indexPath.row];
                [[Socket sharedSocketTool] deleMsgList:imMsgList.imChannel userId:account.userInfo.userId];
               
              [self.dataArray removeObjectAtIndex:indexPath.row];
              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
               
            } cancelBlock:^{
                
            }];
            [alert show];
        }
        if (self.orderMsgBtn.selected) {
            CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
                @strongify(self)
                ImDvyMsgList *dic = self.dataOrderArray[indexPath.row];
                [[Socket sharedSocketTool] DvyListDelete:dic.imChannel userId:account.userInfo.userId page:self.pageOrder pagesize:10];
               
              [self.dataOrderArray removeObjectAtIndex:indexPath.row];
              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
               
            } cancelBlock:^{
                
            }];
            [alert show];
        }
        
        if (self.refunBtn.selected) {
            CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
                @strongify(self)
                ImRefundMsgList *dic = self.dataRefunArray[indexPath.row];
                [[Socket sharedSocketTool] RefundListDelete:dic.imChannel userId:account.userInfo.userId page:self.pageRefun pagesize:10];
               
                [self.dataRefunArray removeObjectAtIndex:indexPath.row];
              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
               
            } cancelBlock:^{
                
            }];
            [alert show];
        }
          }];
    deleteAction.backgroundColor = [UIColor clearColor];
    return @[deleteAction];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

        return YES; // 允许所有行侧滑删除

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
            if (self.kefuBtn.selected) {
                self.page = 1;
                
                [self loadData];
            }
            else if(self.orderMsgBtn.selected){
                self.pageOrder = 1;
                [self loadDataOrder];
            }
            else{
                self.pageRefun = 1;
                [self loadDataRefun];
            }
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            if (self.kefuBtn.selected) {
                self.page++;
                [self loadData];
            }
            else if(self.orderMsgBtn.selected){
                self.pageOrder ++;
                [self loadDataOrder];
            }
            else{
                self.pageRefun ++;
                [self loadDataRefun];
            }
            
        }];
    }
    return _tableView;
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无消息");
    }
    return _nothingView;
}
- (IBAction)kefuClick:(UIButton *)sender {
//    if (!sender.selected) {
        sender.selected = YES;
        self.orderMsgBtn.selected = NO;
        self.refunBtn.selected = NO;
    
    [HudView showHudForView:self.view];
    [self loadData];
//    }
}

- (IBAction)orderClick:(UIButton *)sender {
    sender.selected = YES;
    self.kefuBtn.selected = NO;
    self.refunBtn.selected = NO;
//    self.dataOrderArray = @[@"1",@"3"];
//    [self.tableView reloadData];
    
    [HudView showHudForView:self.view];
    [self loadDataOrder];
}
- (IBAction)refunClick:(UIButton *)sender {
    sender.selected = YES;
    self.orderMsgBtn.selected = NO;
    self.kefuBtn.selected = NO;
//    self.dataRefunArray = @[@"1",@"3",@"1",@"3"];
//    [self.tableView reloadData];
    
    [HudView showHudForView:self.view];
    [self loadDataRefun];
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
