//
//  MineMessDetailViewController.m
//  Netneto
//
//  Created by apple on 2024/12/23.
//

#import "MineMessDetailViewController.h"
#define EmojiHeight 200
#define ShowSafeDis (iPhoneX ? 20: 10)

@interface MineMessDetailViewController ()
< UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate,GCDAsyncSocketDelegate,TMSEmojiViewDelegate>

@property (nonatomic, assign) UIEdgeInsets safeAreaInsets;
@property(nonatomic,strong)MineMsgBottomView *bottomView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)GCDAsyncSocket *clientSocket;
@property(nonatomic, assign)int page;
@property(nonatomic, assign)int imLabelId;
@property(nonatomic,strong)NSArray *labelMsgList;
@property(nonatomic, strong)UIImageView *bgHeaderView;

@property (nonatomic, strong) TMSInputView *inputView;
@property(nonatomic, assign)BOOL isHideBottom;
@property(nonatomic, assign)BOOL isShowKeyBoard;
@end

@implementation MineMessDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [account setIqkeyboardmanager:NO];
    
    [[UINavigationBar appearance]setBarTintColor:RGB_ALPHA(0xFFFFFF,1.0)];
    [[UINavigationBar appearance]setBackgroundColor:RGB_ALPHA(0xFFFFFF,1.0)];
    [UINavigationBar appearance].translucent=NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadMsg" object:nil userInfo:nil];

  
    self.dataArray = [NSMutableArray array];
    self.page = 1;
  
    ///加入房间
    [[Socket sharedSocketTool] JoinRoomReq:self.ImsgChannel shopId:self.dataDic[@"shopId"] userId:account.userInfo.userId toUserid:self.ToUserId fromUserId:self.FromUserId name:self.dataDic[@"shopName"] userImg:self.dataDic[@"pic"]];
    
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        [self receiveData:data];
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [account setIqkeyboardmanager:YES];
    // 避免手势返回的时候输入框往下掉
    [[UINavigationBar appearance]setBarTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance]setBackgroundColor:[UIColor clearColor]];
    [UINavigationBar appearance].translucent=YES;

    [[Socket sharedSocketTool] leaveRoom:self.ImsgChannel userId:account.userInfo.userId];
    
    
}
-(void)returnClick{
    [self popViewControllerAnimate];
}
- (void)initData{
    
    
    CGFloat w = [Tool getLabelWidthWithText:self.dataDic[@"shopName"] height:42 font:16];
    if ( w > WIDTH - 155) {
        w = WIDTH - 155;
        
    }
    
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85 + w, 50)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    [leftButtonView addSubview:returnBtn];
    [returnBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    
    UIButton *avatarBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 4, 36, 36)];
    [leftButtonView addSubview:avatarBtn];
    NSString *avaUrl = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.dataDic[@"shopImg"]]];
    
    [avatarBtn sd_setImageWithURL:[NSURL URLWithString:avaUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"组合 257"]];
    
    avatarBtn.layer.cornerRadius = 18;
    avatarBtn.clipsToBounds = YES;
    
    
    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(85, 4, w, 42)];
    [leftButtonView addSubview:nameBtn];
    [nameBtn setTitle:self.dataDic[@"shopName"] forState:UIControlStateNormal];
    [nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nameBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    self.navigationItem.leftBarButtonItems = @[leftCunstomButtonView];
    
    
    
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButtonView addSubview:rightBtn];
    [rightBtn setImage:[UIImage imageNamed:@"path-25"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    
    //    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 30, 30)];
    //       [rightButtonView addSubview:setBtn];
    //       [setBtn setImage:[UIImage imageNamed:@"svg"] forState:UIControlStateNormal];
    //      [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
}
#pragma mark -跳转店铺
-(void)rightBtnClick{
    HomeShopViewControll *vc = [[HomeShopViewControll alloc] init];
    vc.shopId = self.dataDic[@"shopId"];
    [self pushController:vc];
}
#pragma mark -收到消息
-(void)receiveData:(NSData *)data{
    ImMsgBody *body = [ImMsgBody parseFromData:data error:nil];
    int msgType = body.msgType;
     if (msgType == 104) {
         //聊天记录
        MsgRecordResp *recordArr = [MsgRecordResp parseFromData:body.bytesData error:nil];
        
        
        if (self.page == 1) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self.dataArray removeAllObjects];
                
                [self.dataArray addObjectsFromArray:recordArr.imMsgRecordArray];
                
                if (self.dataArray.count == 0) {
                    NSString *FromUserId =self.FromUserId;
                    NSString *ToUserId =self.ToUserId;
                    if ([account.userInfo.userId isEqual:self.ToUserId]) {
                        
                        ToUserId = self.FromUserId;
                    }
                    ImMsg *msg = [[ImMsg alloc] init];
                    msg.content = TransOutput(@"欢迎您光临本店");
                    msg.createTime =[Tool getCurtenTimeStrWithString];
                    msg.fromUserId = ToUserId;
                    msg.toUserId =account.userInfo.userId;
                    msg.imChannel = self.ImsgChannel;
                    [self.dataArray addObject:msg];
                    
                }
                
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                       [self scrollTableToFoot:YES];
                    
                });
            });
          }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (ImMsg *msg in recordArr.imMsgRecordArray) {
                    [self.dataArray insertObject:msg atIndex:0];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                });
            });
            
            
        }
        
        
        
    }
    if (msgType == 107 ||  msgType == 106) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            ImMsg *recordArr = [ImMsg parseFromData:body.bytesData error:nil];
            if ([recordArr.imChannel isEqual:self.ImsgChannel]) {
                [self.dataArray addObject:recordArr];
                [self.tableView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [self scrollTableToFoot:YES];
                });
            }
        });
        
        
    }
    if (msgType == 110 ) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            prodMsg *recordArr = [prodMsg parseFromData:body.bytesData error:nil];
            if ([recordArr.imChannel isEqual:self.ImsgChannel]) {
                [self.dataArray addObject:recordArr];
                [self.tableView reloadData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self scrollTableToFoot:YES];
                });
            }
        });
    }
    if (msgType == 7) {
        //加入房间
        RoomJoinResp *roomJoinResp = [RoomJoinResp parseFromData:body.bytesData error:nil];
        self.ImsgChannel = roomJoinResp.imChannel;
        self.labelMsgList = roomJoinResp.labelMsgListArray;
        [self creatBtnCitiao];
        [self getMsgRecord];
    }
    if (msgType == 112) {
//        获取词条详情
        MsgLabelInfoResp *roomJoinResp = [MsgLabelInfoResp parseFromData:body.bytesData error:nil];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (int i = 0; i < roomJoinResp.labelInfoListArray.count; i++) {
            labelInfoMsg *infoMsg =roomJoinResp.labelInfoListArray[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:infoMsg.labelInfoValue style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 点击后的操作
                
                [self sendMsg:infoMsg.labelInfoValue contentType:0];
            }];
            [alertController addAction:action];
            
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    
}
#pragma mark - 滚动到最新的row
- (void)scrollTableToFoot:(BOOL)animated
{
  
    if (self.dataArray.count>0) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];

                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    }

}

#pragma mark - 获取聊天记录
-(void)getMsgRecord{
    [[Socket sharedSocketTool] getMsgRecordList:self.ImsgChannel page:self.page userid:account.userInfo.userId];
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        [self receiveData:data];
    }];
}
#pragma mark - 发送消息
-(void)sendMsg:(NSString *)content contentType:(int)contentType{
    
    NSString *trimedString = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
      
    if (content.length!= 0 && [trimedString length] !=0) {
        NSString *FromUserId =self.FromUserId;
        NSString *ToUserId =self.ToUserId;
        if (![account.userInfo.userId isEqual:self.FromUserId]) {
            FromUserId = self.ToUserId;
            ToUserId = self.FromUserId;
        }
        [[Socket sharedSocketTool] sendMess:content FromUserId:FromUserId toUserId:ToUserId contentType:contentType imsgChannel:self.ImsgChannel];
        self.page = 1;
        [self getMsgRecord];
    }
    
}
#pragma mark - 发送链接
-(void)sendLink{
    NSString *FromUserId =self.FromUserId;
    NSString *ToUserId =self.ToUserId;
    if (![account.userInfo.userId isEqual:self.FromUserId]) {
        FromUserId = self.ToUserId;
        ToUserId = self.FromUserId;
    }
    [[Socket sharedSocketTool] sendLink:self.dataDic FromUserId:FromUserId toUserId:ToUserId imsgChannel:self.ImsgChannel selDic:self.selDic];
    [self getMsgRecord];
}


-(void)setBtnClick{
    
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
    
        _bgHeaderView.image = [UIImage imageNamed:@""];
        
    }
    return _bgHeaderView;
}
-(void)viewDidLoad{
   
    [super viewDidLoad];
    [self initData];
    self.view.backgroundColor = RGB(0xF9F9F9);

    self.inputView = [[TMSInputView alloc] init];
    
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_offset(67);
    }];
    @weakify(self);
    [self.inputView setSendMsgText:^(NSString *text) {
        @strongify(self);
        [self sendMsg:text contentType:0];
    }];
    self.tableView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeShowContentViewPosition:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeContentViewPosition:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.view addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self.inputView stickerButttonBackToOriginalState];
    }];
}
#pragma mark - 隐藏键盘
- (void)changeContentViewPosition:(NSNotification *)notification{
    self.isShowKeyBoard = NO;
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        
    }];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
       

        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-5);
    }];
    if (self.isDetail) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            

            make.bottom.mas_equalTo(self.inputView.mas_top).offset(-5);
        }];
    }
    if (self.isHideBottom) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            

            make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-10);
        }];
    }
    else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            

            make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-10);
        }];
    }
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height ) animated:YES];

}
#pragma mark - 展示键盘
- (void)changeShowContentViewPosition:(NSNotification *)notification{
    
    self.isShowKeyBoard = YES;
    NSValue *keyboardFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
      CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-keyboardFrame.size.height + 15);
        
    }];
    
    if (self.isDetail) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.mas_equalTo(self.inputView.mas_top).offset(-5);
        }];
    }
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-5);
        
    }];
    
    if (self.isHideBottom) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
          
            make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-10);
        }];
    }
    else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-10);

            
        }];
    }

        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height + keyboardFrame.size.height) animated:YES];

      // 打印键盘高度
      NSLog(@"Keyboard height: %f", keyboardFrame.size.height);
}

#pragma mark - 创建词条
-(void)creatBtnCitiao{
    CGFloat space = 10;
    
    self.scrollView = [[UIScrollView alloc] init];
    
     self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    CGFloat SW = 0;
    CGFloat BW = 0;
     [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(0);
        make.trailing.mas_offset(0);

        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-5);
        make.height.mas_offset(32);
    }];
    for (int i = 0;i < self.labelMsgList.count ; i++) {
        labelMsg *labmsg = self.labelMsgList[i];
        CGFloat w = [Tool getLabelWidthWithText:labmsg.labelName height:32 font:14] + 20;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        btn.layer.cornerRadius = 16;
        btn.clipsToBounds = YES;
        [btn setTitle:labmsg.labelName forState:UIControlStateNormal];
        [btn setTitleColor:RGB(0x666666) forState:UIControlStateNormal];
        [btn.titleLabel setFont: [UIFont systemFontOfSize:14]];
        btn.layer.borderColor = RGB(0xCCCCCC).CGColor;
        btn.layer.borderWidth = 1;
        btn.frame = CGRectMake(18 + space * i + BW , 0, w, 32);
        [self.scrollView addSubview:btn];
        BW += w;
        SW = btn.left + btn.width;
        self.scrollView.contentSize = CGSizeMake(SW + 20, 32);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (self.isDetail) {
        self.isHideBottom = NO;
        self.bottomView.dic = self.dataDic;
        self.bottomView.seldic = self.selDic;
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(17);
            make.trailing.mas_offset(-17);
            make.bottom.mas_equalTo(self.inputView.mas_top).offset(-5);
            make.height.mas_offset(88);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-10);
        }];
    }
    else{
        self.isHideBottom = YES;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-10);
        }];
    }
}
#pragma mark - 词条点击
-(void)btnClick:(UIButton *)sender{
    labelMsg *labmsg = self.labelMsgList[sender.tag];
    [[Socket sharedSocketTool] sendLabelInfo:labmsg.imLabelId];
    [[Socket sharedSocketTool] setDidReceiveMessageBlock:^(NSData * _Nonnull data) {
        [self receiveData:data];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArray[indexPath.row] isKindOfClass:[ImMsg class]]) {
        ImMsg * model = self.dataArray[indexPath.row];
        if ([model.fromUserId isEqual:account.userInfo.userId]) {
            if (model.contentType == 1) {
                
                MsgLinkRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgLinkRightTableViewCell"];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MsgLinkRightTableViewCell" owner:self options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
                NSData *jsonData = [model.content dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                
                
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:dict[@"prodImg"]]];
                cell.name.text = dict[@"prodName"];
                cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:[dict[@"price"] floatValue]]];
                cell.skuNameLabel.text = dict[@"skuName"];
                [cell.bgView addTapAction:^(UIView * _Nonnull view) {
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId =dict[@"prodId"];
                    [self pushController:vc];
                }];
                return cell;
            }else{
                MsgRightTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (!cell) {
                    cell = [[MsgRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    cell.timeLabel.text = model.createTime;
                }
                else{
                    if ([self.dataArray[indexPath.row-1] isKindOfClass:[ImMsg class]]) {
                        ImMsg *modelFirst = self.dataArray[indexPath.row-1];
                        NSInteger timeNum =[Tool getTimeStrWithString:modelFirst.createTime];
                        NSInteger timeNumNext =[Tool getTimeStrWithString:model.createTime];
                        if (timeNumNext - timeNum > 300) {
                            cell.timeLabel.text = model.createTime;
                        }
                        else{
                            cell.timeLabel.hidden = YES;
                        }
                    }
                    else{
                        cell.timeLabel.hidden = YES;
                       
                    }
                }
               
                cell.contentLabel.text = model.content;
                return cell;
            }
        }else{
            if (model.contentType == 1) {
                
                MsgLinkLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgLinkLeftTableViewCell"];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MsgLinkLeftTableViewCell" owner:self options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
                NSData *jsonData = [model.content dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                
                [cell.bgView addTapAction:^(UIView * _Nonnull view) {
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId =dict[@"prodId"];
                    [self pushController:vc];
                }];
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:dict[@"prodImg"]]];
                cell.name.text = dict[@"prodName"];
                cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:[dict[@"price"] floatValue]]];
                cell.skuNameLabel.text = dict[@"skuName"];
                return cell;
            }else{
                MsgLeftTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (!cell) {
                    cell = [[MsgLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    cell.timeLabel.text = model.createTime;
                }
                else{
                    if ([self.dataArray[indexPath.row-1] isKindOfClass:[ImMsg class]]) {
                        ImMsg *modelFirst = self.dataArray[indexPath.row-1];
                        NSInteger timeNum =[Tool getTimeStrWithString:modelFirst.createTime];
                        NSInteger timeNumNext =[Tool getTimeStrWithString:model.createTime];
                        if (timeNumNext - timeNum > 300) {
                            cell.timeLabel.text = model.createTime;
                        }
                        else{
                            cell.timeLabel.hidden = YES;
                        }
                    }
                    else{
                        cell.timeLabel.hidden = YES;
                       
                    }
                    
                }
                cell.contentLabel.text = model.content;
                return cell;
            }
        }
        
    }
    
    else{
        prodMsg * model = self.dataArray[indexPath.row];
        if ([model.fromUserId isEqual:account.userInfo.userId]) {
                
                MsgLinkRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgLinkRightTableViewCell"];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MsgLinkRightTableViewCell" owner:self options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
            
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:model.prodImg]];
            cell.name.text = model.prodName;
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:model.price ]];
            cell.skuNameLabel.text = model.skuName;
            [cell.bgView addTapAction:^(UIView * _Nonnull view) {
                HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                vc.prodId =[NSString stringWithFormat:@"%lld",model.prodId] ;
                [self pushController:vc];
            }];
                return cell;
            
        }else{
                
                MsgLinkLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgLinkLeftTableViewCell"];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MsgLinkLeftTableViewCell" owner:self options:nil].lastObject;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
               
            [cell.bgView addTapAction:^(UIView * _Nonnull view) {
                HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                vc.prodId =[NSString stringWithFormat:@"%lld",model.prodId] ;
                [self pushController:vc];
            }];
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:model.prodImg]];
            cell.name.text = model.prodName;
            cell.skuNameLabel.text = model.skuName;
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:model.price ]];
                return cell;
            
        }
      
    }
    

   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([self.dataArray[indexPath.row] isKindOfClass:[ImMsg class]]) {
        
        ImMsg *model = self.dataArray[indexPath.row];
        if (model.contentType == 1) {
            return 105;
        }else{
            CGFloat h = [Tool getLabelHeightWithText:model.content width:272 font:14] + 15;
            if (indexPath.row == 0) {
                return h + 57;
            }
            else{
                if ([self.dataArray[indexPath.row-1] isKindOfClass:[ImMsg class]]) {
                    ImMsg *modelFirst = self.dataArray[indexPath.row-1];
                    NSInteger timeNum =[Tool getTimeStrWithString:modelFirst.createTime];
                    NSInteger timeNumNext =[Tool getTimeStrWithString:model.createTime];
                    if (timeNumNext - timeNum > 300) {
                        return h + 57;
                    }
                    else{
                        return h + 27;
                    }
                }
                else{
                    return h + 27;
                   
                }
            }
           
        }
    }
    else{
        return 105;
    }
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
            self.page++;
            [self getMsgRecord];
        }];

    }
    return _tableView;
}
-(MineMsgBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [MineMsgBottomView initViewNIB];
        _bottomView.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        [_bottomView setCloseBlock:^{
            @strongify(self);
            self.isHideBottom = YES;
            self.bottomView.hidden = YES;
            if (self.isShowKeyBoard) {
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                  

                    make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-10);
                }];
            }else{
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    

                    make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-10);
                }];
            }
        }];
        [_bottomView setSendGoodBlock:^(NSDictionary * _Nonnull dic) {
            @strongify(self);
            [self sendLink];

            self.isHideBottom = YES;
            self.bottomView.hidden = YES;
            if (self.isShowKeyBoard) {
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                  

                    make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-10);
                }];
            }else{
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    

                    make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-10);
                }];
            }
        }];
    }
    return _bottomView;
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
