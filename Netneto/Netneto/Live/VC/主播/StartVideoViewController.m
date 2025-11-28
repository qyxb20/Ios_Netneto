//
//  StartVideoViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/8.
//

#import "StartVideoViewController.h"

@interface StartVideoViewController ()<UITableViewDelegate,UITableViewDataSource,TMSEmojiViewDelegate>
{
    //开始动画倒计时123
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UIView *backView;
    
    
}
@property (nonatomic, strong) UIView *videoPreview;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *onLineLabel;
@property (nonatomic, strong) LiveBottomView*bottomView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *msgListArray;
@property (nonatomic, strong) LiveShopCartView *shopCarView;
@property (nonatomic, strong) LiveAddShopGoodsView *addShopCarView;
@property (nonatomic, strong) LiveMoreView*moreView;
@property (nonatomic, strong) LiveSetView*setView;
@property (nonatomic, strong) NSString*selectUserId;
@property (nonatomic, strong) NSString*selectUserNickName;
@property (nonatomic, strong) addManagerListView *addManaListView;
@property (nonatomic, strong) NSString *jinTimeJson;
@property (nonatomic, strong) UIView *noticView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) TMSStickerView *stickerView;
@property (nonatomic, assign) UIEdgeInsets safeAreaInsets;

@end

@implementation StartVideoViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
  
   [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
        [self.view addSubview:self.videoPreview];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.msgListArray = [NSMutableArray array];
        [RTC sharedRTCTool].localPreview = self.videoPreview;
        [[RTC sharedRTCTool] startPreview];
        [[RTM sharedRtmTool] loginRtm:NO channel:self.channel];
    
}
-(void)returnClick{
    
    CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"确定结束直播？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
        [self closeLive];
    } cancelBlock:^{
        
    }];
    [alert show];
    
}
-(void)closeLive{
    NSDictionary *dic;
    dic= @{
        @"notice":self.getLiveDic[@"notice"],
        @"shopLogo":self.getLiveDic[@"shopLogo"],
        @"shopName":self.getLiveDic[@"shopName"],
        @"userId":self.getLiveDic[@"userId"],
        @"channel":self.getLiveDic[@"channel"],
        @"shopId":self.getLiveDic[@"shopId"],
        @"showRole":self.getLiveDic[@"showRole"],
        @"showRoleId":[NSString isNullStr:self.getLiveDic[@"showRoleId"]],
        @"userCount":self.getLiveDic[@"userCount"],
        @"imgPath":self.getLiveDic[@"imgPath"],
        @"msg":self.getLiveDic[@"msg"],
        @"showStatus":@"0",
        @"showType":@"1",
    };
    
    [NetwortTool getAddRoomMsgWithParm:dic Success:^(id  _Nonnull responseObject) {
        [[RTC sharedRTCTool] stopPreview];
        [[RTC sharedRTCTool] leaveChannel];
        [[RTM sharedRtmTool] signoutRtm];

        [self popViewControllerAnimate];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)closeLiveBei{
    NSDictionary *dic;
    dic= @{
        @"notice":self.getLiveDic[@"notice"],
        @"shopLogo":self.getLiveDic[@"shopLogo"],
        @"shopName":self.getLiveDic[@"shopName"],
        @"userId":self.getLiveDic[@"userId"],
        @"channel":self.getLiveDic[@"channel"],
        @"shopId":self.getLiveDic[@"shopId"],
        @"showRole":self.getLiveDic[@"showRole"],
        @"showRoleId":[NSString isNullStr:self.getLiveDic[@"showRoleId"]],
        @"userCount":self.getLiveDic[@"userCount"],
        @"imgPath":self.getLiveDic[@"imgPath"],
        @"msg":self.getLiveDic[@"msg"],
        @"showStatus":@"0",
        @"showType":@"1",
    };
    
    [NetwortTool getIndexAddRoomMsgWithParm:dic Success:^(id  _Nonnull responseObject) {
       
       
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)appactive{
    //进入前台
    [[RTC sharedRTCTool].rtcKit  enableLocalVideo:YES];
    [[RTC sharedRTCTool].rtcKit  enableLocalAudio:YES];
    [self sendMessage:TransOutput(@"主播回来了") msgType:6];

}

-(void)appnoactive{
    //进入后台
    [[RTC sharedRTCTool].rtcKit  enableLocalVideo:NO];
    [[RTC sharedRTCTool].rtcKit  enableLocalAudio:NO];

    [self sendMessage:TransOutput(@"主播已离开") msgType:5];
   
}

-(void)initData{
    self.view.backgroundColor = [UIColor blackColor];
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
 
    [notification addObserver:self
           selector:@selector(appactive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    [notification addObserver:self
           selector:@selector(appnoactive)
               name:UIApplicationWillResignActiveNotification
             object:nil];
    [NetwortTool getRoomRtcTokenWithChannel:self.channel uid:account.userInfo.uid Success:^(id  _Nonnull responseObject) {
        [self initRtcWithRtm:[NSString stringWithFormat:@"%@",responseObject[@"rtcToken"]]];
        [self createAnmiaUI];
    } failure:^(NSError * _Nonnull error) {
        
    }];
  
    self.timer = [NSTimer timerWithTimeInterval:1.0
                                           target:self
                                         selector:@selector(updateOnlineLabel)
                                         userInfo:nil
                                          repeats:YES];
      // 将定时器添加到运行循环
      [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"closeLive" object:nil queue:nil usingBlock:^(NSNotification *notification) {
      
            [self closeLiveBei];
    
    }];

}
#pragma mark - 初始化RTC
-(void)initRtcWithRtm:(NSString *)rtcToken{
    [[RTC sharedRTCTool] joinChannel:self.channel token:rtcToken role:AgoraClientRoleBroadcaster codeBloc:^(NSInteger code, NSString * _Nonnull msg) {
        if (code != 0) {
            NSString *str = [NSString stringWithFormat:@"channel：%@ code:%ld",msg,(long)code];
            ToastShow(str, errImg,RGB(0xFF830F));
        }
    }];
   
    [[RTC sharedRTCTool] setJoinChannelSuccessBlock:^(NSInteger uid) {
     
    }];
    [[RTC sharedRTCTool] setLeaveChannelSuccessBlock:^(NSInteger uid) {
            
    }];
    [[RTC sharedRTCTool] setRemoteUserJoinChannelBlock:^(NSInteger uid) {
//        [self sendMessage:TransOutput(@"主播回来了") msgType:6];
  
    }];
    [[RTC sharedRTCTool] setActorLeaveBlock:^{
//        [self sendMessage:TransOutput(@"主播已离开") msgType:5];
  
    }];
    [[RTC sharedRTCTool] setRtcChangeToStateBlock:^(AgoraConnectionChangedReason reason) {
       
        
        if (reason == AgoraChannelMediaRelayErrorServerConnectionLost) {
            //结束直播
            [[RTC sharedRTCTool] stopPreview];
            [[RTC sharedRTCTool] leaveChannel];
            [[RTM sharedRtmTool] signoutRtm];

            [self popViewControllerAnimate];
            
        }
    }];
     /// RTM
    [self initRTM];
    
}
-(void)initRTM{
    @weakify(self)
//    [[RTM sharedRtmTool] joinChannel:self.channel];
    [[RTM sharedRtmTool] setJoinChannelSuccessBlock:^(NSString * _Nonnull channel) {
        @strongify(self)
        NSLog(@"我来了");
    }];
    [[RTM sharedRtmTool] setLeaveChannelSuccessBlock:^(NSString * _Nonnull channel) {
            
    }];
   [[RTM sharedRtmTool] setDidReceiveMessageBlock:^(MessageModel * _Nonnull model) {
            @strongify(self)
       if (!self) {
           return;
       }
       [self receiveMessage:model];
        }];
}
-(void)updateOnlineLabel{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @weakify(self);
        [[RTM sharedRtmTool] getOnlineUserCountWithChannel:self.channel Success:^(NSString * _Nonnull num) {
            
            @strongify(self);
            self.onLineLabel.text = num;
        }];
    });
}
- (void)dealloc {
    // 清理定时器
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)receiveMessage:(MessageModel *)model{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.msgListArray addObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self jumpLast:self.tableView];
        });
        
    });
    
    if (model.messageType == 1 || model.messageType == 2) {
       
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 在延迟3秒后执行代码
            // ...
            [self.msgListArray removeObject:model];
            [self.tableView reloadData];
            [self jumpLast:self.tableView];
        });
    }
}

-(void)sendMessage:(NSString *)msg msgType:(NSInteger)messageType{
   
    if (msg.length <= 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        bool bool_true;
       
            bool_true= false;
        NSDictionary *msgDic;
        if (messageType == 8 || messageType == 9) {
         msgDic = @{
                @"isAdmin":@(bool_true),
                @"message":msg,
                @"messageType":@(messageType),
                @"senderUser":@{@"userId":account.userInfo.userId,@"userName":account.userInfo.nickName},
                @"recipientUserList":@[@{@"userId":self.selectUserId,@"userName":self.selectUserNickName}]
            };
        }
        
        else if (messageType == 3){
            msgDic = @{@"extension":self.jinTimeJson,
                       @"extensionClassName" : @"com.qyx.live.model.SpeechTimeModel",
                       @"isAdmin":@(bool_true),
                       @"message":msg,
                       @"messageType":@(messageType),
                       @"senderUser":@{@"userId":account.userInfo.userId,@"userName":account.userInfo.nickName},
                       @"recipientUserList":@[@{@"userId":self.selectUserId,@"userName":self.selectUserNickName}]
            };
            
        }
        else{
            msgDic= @{
                @"isAdmin":@(bool_true),
                @"message":msg,
                @"messageType":@(messageType),
                @"senderUser":@{@"userId":account.userInfo.userId,@"userName":account.userInfo.nickName}
            };
        }
        if (messageType != 5 && messageType != 6) {
            MessageModel *model = [MessageModel mj_objectWithKeyValues:msgDic];
         
            [self.msgListArray addObject:model];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self jumpLast:self.tableView];
            });
            
            if (messageType == 8 || messageType == 9 || messageType == 3) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 在延迟3秒后执行代码
                    // ...
                    [self.msgListArray removeObject:model];
                    [self.tableView reloadData];
                    [self jumpLast:self.tableView];
                });
            }
        }
        
        [[RTM sharedRtmTool] sendMessageWithDictionary:msgDic withChannel:self.channel];
       
        
       
        
    });
    
    
}
#pragma -mark 创建321 UI
-(void)createAnmiaUI{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.opaque = YES;
    [self.view addSubview:backView];
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2 -100, HEIGHT/2-200, 100, 100)];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:90];
    label1.text = @"3";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.center = backView.center;
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2 -100, HEIGHT/2-200, 100, 100)];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:90];
    label2.text = @"2";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = backView.center;
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2 -100, HEIGHT/2-200, 100, 100)];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:90];
    label3.text = @"1";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.center = backView.center;
    label1.hidden = YES;
    label2.hidden = YES;
    label3.hidden = YES;
    [backView addSubview:label3];
    [backView addSubview:label1];
    [backView addSubview:label2];
    [self kaishidonghua];
}
-(void)createContentUI:(NSDictionary *)infoDic{
    
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 46, 44, 35, 35)];
    [returnBtn setImage:[UIImage imageNamed:@"closeH"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:returnBtn];
    
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(16, 44, 35, 35)];
    avatar.layer.cornerRadius = 17.5;
    avatar.clipsToBounds = YES;
    [avatar sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:infoDic[@"shopLogo"]]] placeholderImage:[UIImage imageNamed:@"椭圆 6"]] ;
    [self.contentView addSubview:avatar];
    
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(avatar.right + 5, 44, 160, 35)];
    
    nickName.text = [NSString isNullStr:infoDic[@"shopName"]];
    nickName.font = [UIFont systemFontOfSize:18];
    nickName.textColor = [UIColor whiteColor];
    [self.contentView addSubview:nickName];
    
    self.onLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 46 - 60, 44, 55, 35)];
    self.onLineLabel.font = [UIFont systemFontOfSize:13];
    self.onLineLabel.textColor = [UIColor whiteColor];
    self.onLineLabel.text = @"1";
    self.onLineLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.onLineLabel];
    CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"管理员列表") height:30 font:12];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor gradientColorArr:@[RGB(0xFB5A9E),RGB(0xF180D6),RGB(0xF180D6),RGB(0xFFFFFF)] withWidth:w + 65];
    [button setTitle:TransOutput(@"管理员列表") forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"path-3 1"] forState:UIControlStateNormal];
    [button layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
    
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.layer.cornerRadius = 15;
    button.clipsToBounds = YES;
    [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(15);
        make.top.mas_offset(90);
        make.width.mas_equalTo(w + 65);
        make.height.mas_offset(30);
    }];
    @weakify(self);
    [button addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        
        [self.view addSubview:self.addManaListView];
        [self.addManaListView loadData];
        [self.addManaListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_offset(0);
        }];
        
    }];
    [self.bottomView.contentTF addPlachColor:TransOutput(@"说点什么") color:RGB(0xA5A5A5)];
    self.bottomView.contentTF.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bottomView];
   
    [self.bottomView setSendMessageBlock:^(NSString * _Nonnull message) {
        @strongify(self);
        [self.bottomView.contentTF resignFirstResponder];
        self.bottomView.contentTF.text = @"";
        [self sendMessage:message msgType:0];
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(-20);
        make.height.mas_offset(60);
    }];
    
    [self.bottomView.shopCarBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self showShopView];
    }];
    
    [self.bottomView.moreBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.moreView.isActor = YES;
        [self.view addSubview: self.moreView];
        [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_offset(0);
        }];
    }];
    [self.bottomView.faceBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        @weakify(self);
        [self.bottomView.contentTF resignFirstResponder];
        self.stickerView.sendActionBlock = ^(id emoji) {
            @strongify(self);
            [self sendMessage:self.bottomView.contentTF.text msgType:0];
            [self.bottomView.contentTF resignFirstResponder];
            self.bottomView.contentTF.text = nil;
            self.stickerView.textView = nil;
           
            self.bottomView.contentTF.inputView = nil;
            
        };
        [self.stickerView setTextView:self.bottomView.contentTF];
        [self.bottomView.contentTF becomeFirstResponder];
    }];
    if ([self.getLiveDic[@"notice"] length] != 0) {
        CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"直播公告") height:20 font:12];
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, -1.5, w + 14, 17);
        label.text =TransOutput(@"直播公告");
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = RGB(0xFE9803);
        label.layer.cornerRadius = 8;
        label.clipsToBounds = YES;
       
        UIImage *image = [Tool imageWithUIView:label];

        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2.5, w + 14, 16); //这个-2.5是为了调整下标签跟文字的位置
        attach.image = image;
        //添加到富文本对象里
        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        CGFloat nameW = [Tool getLabelWidthWithText:[NSString stringWithFormat:@"%@:%@",TransOutput(@"直播公告"),[NSString isNullStr:self.getLiveDic[@"notice"]]] height:20 font:16];
        NSString *str = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.getLiveDic[@"notice"]]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [str length])];
        NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@"  "];
        [att insertAttributedString:speaceString atIndex:0];//加入文字前面

        
        [att insertAttributedString:imageStr atIndex:0];//加入文字前面

   
        NSString *string = [NSString stringWithFormat:@"%@:%@",TransOutput(@"直播公告"),[NSString isNullStr:self.getLiveDic[@"notice"]]];
    CGFloat ws = [Tool getLabelWidthWithText:string height:40 font:14] +20;
    if (nameW  > WIDTH - 150 - 32) {
        nameW = WIDTH - 150-32;
    }
        CGFloat h = [Tool getLabelHeightWithText:string width:nameW font:16];
    self.noticView = [[UIView alloc] initWithFrame:CGRectMake(16, HEIGHT - 400 - h - 8 - 16, nameW + 30, h + 8)];
    self.noticView.backgroundColor = RGB_ALPHA(0xDF864A, 0.7);
        self.noticView.layer.borderColor = RGB(0xFE9803).CGColor;
        self.noticView.layer.borderWidth = 0.5;
        if (h + 8 < 28) {
            self.noticView.layer.cornerRadius = (h + 8) / 2;
        }else{
            self.noticView.layer.cornerRadius = 5;
        }
    self.noticView.clipsToBounds = YES;
    [self.contentView addSubview:self.noticView];
   
    
        TYAttributedLabel *labelt = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(10, 10,nameW , h)];
        [labelt appendView:label];
        [labelt appendText:@" "];
        labelt.backgroundColor = [UIColor clearColor];
        labelt.textColor = [UIColor whiteColor];
        labelt.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString isNullStr:self.getLiveDic[@"notice"]]];
        [attributedString addAttributeTextColor:[UIColor whiteColor]];
        [labelt appendTextAttributedString:attributedString];
        labelt.numberOfLines = 0;
        [labelt sizeToFit];
        self.noticView.frame = CGRectMake(16, HEIGHT - 400 - CGRectGetMaxY(labelt.frame) -10 - 16, nameW + 30, CGRectGetMaxY(labelt.frame) + 10);
    [self.noticView addSubview:labelt];
    
        
        
    UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonC setImage:[UIImage imageNamed:@"wclose"] forState:UIControlStateNormal];
        buttonC.frame = CGRectMake(labelt.right , 10, 16, 16);
  
    [buttonC addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        [self.noticView removeFromSuperview];
        [view removeFromSuperview];
    }];
    [self.noticView addSubview:buttonC];
    
    }
    
    [self.contentView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.stickerView.textView = nil;
        [self.bottomView.contentTF resignFirstResponder];
        self.bottomView.contentTF.inputView = nil;
    }];
    self.contentView.userInteractionEnabled = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, HEIGHT - 400, WIDTH - 32, 300)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.clipsToBounds = YES;

    [self.contentView addSubview:self.tableView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *systemDic = @{@"isAdmin":@(false),@"message":TransOutput(@"欢迎来到直播间,我们倡导绿色直播。直播内容和封面有违法违规、色情低俗、抽烟喝酒、诱导欺诈、聚众闹事等行为账号会被封禁,网警24小时在线巡查哦！"),@"messageType":@11,@"senderUser":@{@"userId":account.userInfo.userId,@"userName":account.userInfo.nickName}};
        MessageModel *model = [MessageModel mj_objectWithKeyValues:systemDic];
        [self.msgListArray addObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self jumpLast:self.tableView];
        });
        
    });
   
    
    
    
}
-(void)showShopView{
    [self.view addSubview:self.shopCarView];
    [self.shopCarView updataList:self.channel isadmin:@"1"];
    [self.shopCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.mas_offset(0);
    }];
    @weakify(self)
    [self.shopCarView setAddShopBlock:^{
        @strongify(self);
        [self.shopCarView removeFromSuperview];
        [self.view addSubview:self.addShopCarView];
        [self.addShopCarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.mas_offset(0);
        }];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.msgListArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
     
    ChatTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ChatTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.bgview.backgroundColor = RGB_ALPHA(0x010101, 0.3);
    MessageModel *model = self.msgListArray[indexPath.section];
    cell.zhuboID = account.userInfo.userId;
  
    cell.model = model;
    @weakify(self)
    [cell addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        MessageModel *model = self.msgListArray[indexPath.section];
     
        if (![model.senderUser[@"userId"] isEqual:account.userInfo.userId]) {
            self.selectUserId = [NSString isNullStr:model.senderUser[@"userId"]];
            self.selectUserNickName = [NSString isNullStr:model.senderUser[@"userName"]];
            [_setView show];
            [self.view addSubview: self.setView];
            [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.top.bottom.mas_offset(0);
            }];
        }
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.msgListArray[indexPath.section];
    if (model.messageType == 11) {
        CGFloat h = [Tool getLabelHeightWithText:model.message width:WIDTH - 40-120 font:15];
      
        return h + 18;
    }
    else
    {
        
        if ([model.senderUser[@"userId"] isEqual:account.userInfo.userId]  ){
            NSString *str = [NSString stringWithFormat:@"%@     ：%@",TransOutput(@"主播"),[NSString isNullStr:model.message]];
        
            CGFloat h = [Tool getLabelHeightWithText:str width:WIDTH - 48-120 font:15];
            return  h + 18;
        }
        else if (model.isAdmin) {
            //管理员
            NSString *str = [NSString stringWithFormat:@"%@     %@：%@",TransOutput(@"管理员"),[NSString isNullStr:model.senderUser[@"userName"]],[NSString isNullStr:model.message]];
            CGFloat h = [Tool getLabelHeightWithText:str width:WIDTH - 48-120 font:15];
            return  h + 18;
        }else{
            NSString *str = [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:model.senderUser[@"userName"]],[NSString isNullStr:model.message]];
            
            CGFloat h = [Tool getLabelHeightWithText:str width:WIDTH - 48-120 font:15];
            return  h + 18;
        }

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MessageModel *model = self.msgListArray[indexPath.section];
// 
//    if (![model.senderUser[@"userId"] isEqual:account.userInfo.userId]) {
//        self.selectUserId = [NSString isNullStr:model.senderUser[@"userId"]];
//        self.selectUserNickName = [NSString isNullStr:model.senderUser[@"userName"]];
//        [_setView show];
//        [self.view addSubview: self.setView];
//        [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.top.bottom.mas_offset(0);
//        }];
//    }
}
-(void)jumpLast:(UITableView *)tableView
{

    
     [tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
     [tableView reloadData];
}
#pragma mark-开始动画
- (void)kaishidonghua {
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->label1.hidden = NO;
        [self donghua:self->label1];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->label1.hidden = YES;
        self->label2.hidden = NO;
        [self donghua:self->label2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->label2.hidden = YES;
        self->label3.hidden = NO;
        [self donghua:self->label3];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->backView.hidden = YES;
        [self->backView removeFromSuperview];
        [self.view addSubview:self.contentView];
        [self getShopName];
    });
}
-(void)getShopName{
    [NetwortTool getShopApplyListWithParm:@{} Success:^(id  _Nonnull responseObject) {
        NSArray *arr =responseObject;
        if (arr.count > 0) {
            [self createContentUI:arr.firstObject];
        }
      
    } failure:^(NSError * _Nonnull error) {
        
      
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)donghua:(UILabel *)labels{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(4.0, 4.0, 4.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 3.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.removedOnCompletion = NO;//是不是移除动画的效果
    animation.fillMode = kCAFillModeForwards;//保持最新状态
    [labels.layer addAnimation:animation forKey:nil];
}
-(void)CreateView{
     
}
-(void)GetData{
   
}
- (UIView *)videoPreview {
    if (!_videoPreview) {
        _videoPreview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _videoPreview;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
-(LiveBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [LiveBottomView initViewNIB];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}
-(LiveShopCartView *)shopCarView{
    if (!_shopCarView) {
        _shopCarView = [LiveShopCartView initViewNIB];
        _shopCarView.backgroundColor = [UIColor clearColor];
        _shopCarView.pubHeight.constant = 44;
        _shopCarView.isShowDown = YES;
        [_shopCarView setPushGoodDetailBlock:^(NSDictionary * _Nonnull dic) {
       
        }];
    }
    return _shopCarView;
}
-(LiveAddShopGoodsView *)addShopCarView{
    if (!_addShopCarView) {
        _addShopCarView = [LiveAddShopGoodsView initViewNIB];
        _addShopCarView.backgroundColor = [UIColor clearColor];
        _addShopCarView.channel = self.channel;
    }
    return _addShopCarView;
}
-(LiveMoreView *)moreView{
    if (!_moreView) {
        _moreView = [LiveMoreView initViewNIB];
        _moreView.backgroundColor = [UIColor clearColor];
        _moreView.isActor = YES;
        
        [_moreView setChangeCamerClickBlock:^{
            
            [[RTC sharedRTCTool] switchCamera];
        }];
    }
    return _moreView;
}
- (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        static CGFloat statusBarFrameHeight;
        dispatch_once(&onceToken, ^{
            statusBarFrameHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        });
        if (statusBarFrameHeight == 20) {
            return UIEdgeInsetsZero;
        }
        return [AppDelegate sharedDelegate].window.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (TMSStickerView *)stickerView {
    
    if (!_stickerView) {
      
        _stickerView = [TMSStickerView showEmojiViewWithoutCustomEmoji];
        _stickerView.frame = CGRectMake(0, 0, WIDTH, 190 + self.safeAreaInsets.bottom + 5);
    }
    _stickerView.delegate = self;
    
    return _stickerView;
}
-(LiveSetView *)setView{
    if (!_setView) {
        _setView = [LiveSetView initViewNIB];
        _setView.backgroundColor = [UIColor clearColor];
        
        [_setView updateJinStr:@"10"];
        [_setView updateKitStr:@"10"];
        @weakify(self);
        [_setView setJinTimeClickBlock:^{
            @strongify(self);
            [self choseTime:1];
        }];
        [_setView setKitTimeClickBlock:^{
         
            @strongify(self);
            [self choseTime:2];
        }];
        [_setView setSureClickBlock:^(NSString * _Nonnull timeStr, NSString * _Nonnull choseWho) {
           
            @strongify(self);
            [self.setView removeFromSuperview];
            if ([choseWho isEqual:@"0"]) {
                [self forbiddenSpeech:timeStr];
            }
            if ([choseWho isEqual:@"1"]) {
                [self outRoom:timeStr];
            }
            if([choseWho isEqual:@"2"]){
                [self addManager];
            }
        }];
    }
    
    return _setView;
}
-(addManagerListView *)addManaListView{
    if (!_addManaListView) {
        _addManaListView  = [addManagerListView initViewNIB];
        _addManaListView.backgroundColor = [UIColor clearColor];
        _addManaListView.shopId = self.shopId;
        @weakify(self);
        [_addManaListView setSetManagerBlock:^(NSDictionary * _Nonnull dic) {
            @strongify(self);
            self.selectUserId = [NSString isNullStr:dic[@"userId"]];
            self.selectUserNickName = [NSString isNullStr:dic[@"nickName"]];
            [self addManager];
        }];
    }
    return _addManaListView;
}
#pragma mark - 禁言
-(void)forbiddenSpeech:(NSString *)time{
    
    [NetwortTool getForbiddenSpeechWithParm:@{@"userId":self.selectUserId,@"channel":self.channel,@"times":time} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dic = @{@"speechTime":time};
            
            self.jinTimeJson = [Tool DictionaryToJsonStr:dic];
            ToastShow(TransOutput(@"设置成功"), @"chenggong",RGB(0x36D053));
            
            [self sendMessage:[NSString stringWithFormat:@"%@%@",self.selectUserNickName,TransOutput(@"被禁言")] msgType:3];
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
#pragma mark - 踢出直播间
-(void)outRoom:(NSString *)time{
    [NetwortTool getOutRoomWithParm:@{@"userId":self.selectUserId,@"channel":self.channel,@"times":time} Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"踢出成功"), @"chenggong",RGB(0x36D053));
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)addManager{
    
    [NetwortTool getAddManagerWithParm:@{@"userId":self.selectUserId,@"shopId":self.shopId} Success:^(id  _Nonnull responseObject) {
        NSLog(@"设置管理员数据：%@",responseObject);
        NSString *str = [NSString stringWithFormat:@"%@",[NSString isNullStr:responseObject[@"data"][@"isManager"]]];
        if ([str isEqual:@"1"]) {
            ToastShow(TransOutput(@"管理员添加成功"), @"chenggong",RGB(0x36D053));
            [self sendMessage:[NSString stringWithFormat:@"%@%@",self.selectUserNickName,TransOutput(@"被设置为管理员")] msgType:8];
        }
        else{
            ToastShow(TransOutput(@"取消管理员"), @"chenggong",RGB(0x36D053));
            [self sendMessage:[NSString stringWithFormat:@"%@%@",self.selectUserNickName,TransOutput(@"被取消管理员")] msgType:9];
        }
        
        
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}

-(void)choseTime:(NSInteger)tg{
    NSArray *arr = @[@{@"title":TransOutput(@"10分钟"),@"time":@"10"},@{@"title":TransOutput(@"60分钟"),@"time":@"60"},@{@"title":TransOutput(@"永久"),@"time":@"-1"}];
  
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     
    for (int i = 0; i < arr.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:arr[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 点击后的操作
            NSLog(@"点击了%@", action.title);
            if (tg == 1) {
                [self.setView updateJinStr:arr[i][@"time"] ];
            }else{
                [self.setView updateKitStr:arr[i][@"time"] ];
              }
           
        }];
        [alertController addAction:action];
      
    }
     
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self presentViewController:alertController animated:YES completion:nil];
    });
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
