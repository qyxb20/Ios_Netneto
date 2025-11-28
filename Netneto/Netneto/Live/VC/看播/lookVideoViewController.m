//
//  lookVideoViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/9.
//

#import "lookVideoViewController.h"

@interface lookVideoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TMSEmojiViewDelegate>
{
    UIButton *returnBtnL;
    UIButton *quitBtnL;
    UILabel *zanlabel;
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
@property(nonatomic, strong)NSString *isadmin;
@property(nonatomic, strong)NSString *isFollow;
@property(nonatomic, strong)UIButton *followBtn;
@property(nonatomic, strong)UILabel *nickName;
@property(nonatomic, strong)NSString *speechStatus;
@property(nonatomic, strong)UIScrollView *backScrollView;
@property(nonatomic, strong)UIView *noticView;
@property (nonatomic, strong) LiveSetView*setView;
@property (nonatomic, strong) NSString*selectUserId;
@property (nonatomic, strong) NSString*selectUserNickName;
@property (nonatomic, strong) NSString *jinTimeJson;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) TMSStickerView *stickerView;
@property (nonatomic, assign) UIEdgeInsets safeAreaInsets;
@end

@implementation lookVideoViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self.backScrollView setContentOffset:CGPointMake(WIDTH,0) animated:YES];
}
-(void)returnClick{

  
    [self logoutRoom];
}
-(void)logoutRoom{

        [[RTC sharedRTCTool] stopPreview];
        [[RTC sharedRTCTool] leaveChannel];
      
        [[RTM sharedRtmTool] leaveChannel:self.channel];
        [[RTM sharedRtmTool] signoutRtm];
        [self popViewControllerAnimate];

}
-(void)initData{
    self.view.backgroundColor = [UIColor blackColor];
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
   UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
      [leftButtonView addSubview:returnBtn];
      [returnBtn setImage:[UIImage imageNamed:@"closeH"] forState:UIControlStateNormal];
      [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
   UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
     self.navigationItem.rightBarButtonItem = leftCunstomButtonView;

    [NetwortTool getRoomRtcTokenWithChannel:self.channel uid:self.uid Success:^(id  _Nonnull responseObject) {
        [self initRtcWithRtm:[NSString stringWithFormat:@"%@",responseObject[@"rtcToken"]]];
      
    } failure:^(NSError * _Nonnull error) {
        
    }];
    [self.view addSubview:self.videoPreview];
    self.videoPreview.backgroundColor = [UIColor clearColor];
    [RTC sharedRTCTool].localPreview = self.videoPreview;
    
    [[RTM sharedRtmTool] loginRtm:NO channel:self.channel];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.msgListArray = [NSMutableArray array];
    [self loadData];
    self.timer = [NSTimer timerWithTimeInterval:1.0
                                           target:self
                                         selector:@selector(updateOnlineLabel)
                                         userInfo:nil
                                          repeats:YES];
      // 将定时器添加到运行循环
      [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

}
-(void)initRtcWithRtm:(NSString *)rtcToken{
    [[RTC sharedRTCTool] joinChannel:self.channel token:rtcToken role:AgoraClientRoleAudience codeBloc:^(NSInteger code, NSString * _Nonnull msg) {
        if (code != 0) {
            NSString *str = [NSString stringWithFormat:@"channel：%@ code:%ld",msg,(long)code];
            ToastShow(str, errImg,RGB(0xFF830F));
        }
        
    }];
    @weakify(self);
    [[RTC sharedRTCTool] setJoinChannelSuccessBlock:^(NSInteger uid) {
        [self CreateViewUI];
    }];
    
    [[RTC sharedRTCTool] setRtcChangeToStateBlock:^(AgoraConnectionChangedReason reason) {

    }];
    
    [[RTC sharedRTCTool] setLeaveChannelSuccessBlock:^(NSInteger uid) {
        //主播结束直播
        [[RTC sharedRTCTool] stopPreview];
        [[RTC sharedRTCTool] leaveChannel];
      
        [[RTM sharedRtmTool] leaveChannel:self.channel];
        [[RTM sharedRtmTool] signoutRtm];
        [self.videoPreview removeFromSuperview];
        [self->zanlabel removeFromSuperview];
        self.noticView.hidden = YES;
        self.tableView.hidden = YES;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, WIDTH, 65)];
        label.numberOfLines = 3;
        label.text = TransOutput(@"直播已结束");
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];

    }];
    [[RTC sharedRTCTool] setRemoteUserJoinChannelBlock:^(NSInteger uid) {
        [[RTC sharedRTCTool] setRemoteViewWithUid:uid view:[RTC sharedRTCTool].localPreview showType:self.showtype];
    }];
    [[RTC sharedRTCTool] setKitOutBlock:^{
       //被踢出房间
        ToastShow(TransOutput(@"あなたのアカウントは、現在ライブ配信者に追い出されました。"),@"矢量 20",RGB(0xFF830F));
   
        [self popViewControllerAnimate];
    }];
    [self initRTM];
    
    self.backScrollView.userInteractionEnabled = YES;
    self.backScrollView.contentSize = CGSizeMake(WIDTH*2,0);
}
-(void)initRTM{
    @weakify(self)

    
    NSDictionary *systemDic = @{@"isAdmin":@(false),@"message":TransOutput(@"欢迎来到直播间,我们倡导绿色直播。直播内容和封面有违法违规、色情低俗、抽烟喝酒、诱导欺诈、聚众闹事等行为账号会被封禁,网警24小时在线巡查哦！"),@"messageType":@11,@"senderUser":@{@"userId":self.userId,@"userName":@""}};
    
    MessageModel *model = [MessageModel mj_objectWithKeyValues:systemDic];
    [self.msgListArray addObject:model];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self jumpLast:self.tableView];
    });
    
  
    [[RTM sharedRtmTool] setJoinChannelSuccessBlock:^(NSString * _Nonnull channel) {
        @strongify(self)

        NSLog(@"我来了");

        [self sendMessage:TransOutput(@"来了") msgType:1];
        [self updateFollowTitle];
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
}
-(void)receiveMessage:(MessageModel *)model{
   
    if (model.messageType != 5 && model.messageType != 6)
    { [self.msgListArray addObject:model];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self jumpLast:self.tableView];
    });
}
    if (model.messageType == 1 || model.messageType == 2) {
       

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 在延迟3秒后执行代码
            // ...
            [self.msgListArray removeObject:model];
            [self.tableView reloadData];
            [self jumpLast:self.tableView];
        });
    }
    if (model.messageType == 3 || model.messageType == 8 || model.messageType == 9) {
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 在延迟3秒后执行代码
                // ...
                [self.msgListArray removeObject:model];
                [self.tableView reloadData];
                [self jumpLast:self.tableView];
            });
        [self loadData];
    }
    if (model.messageType == 5) {
        self.videoPreview.hidden = YES;
        [zanlabel removeFromSuperview];
        zanlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, WIDTH, 40)];
        zanlabel.text = TransOutput(@"配信者がただいま席を外しております。");
        zanlabel.textColor = [UIColor whiteColor];
        zanlabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:zanlabel];
        
    }
    if (model.messageType == 6) {
        [zanlabel removeFromSuperview];
        self.videoPreview.hidden = NO;
    }
}

-(void)jumpLast:(UITableView *)tableView
{
    NSUInteger sectionCount = [tableView numberOfSections];
   
    [tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    [tableView reloadData];


  
}
-(void)quitBtnClick{
    
    [self.backScrollView setContentOffset:CGPointMake(WIDTH,0) animated:NO];
    returnBtnL.hidden = YES;
    quitBtnL.hidden = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 这里你可以获取scrollView的滑动信息，例如contentOffset
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"Content is scrolled to %@", NSStringFromCGPoint(offset));
    if (offset.x == 0) {
        returnBtnL.hidden = NO;
        quitBtnL.hidden = NO;
    }
    else {
        returnBtnL.hidden = YES;
        quitBtnL.hidden = YES;
    }
}
-(void)CreateViewUI{
    
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT)];
    self.backScrollView.delegate = self;
    self.backScrollView.contentSize = CGSizeMake(WIDTH*2,0);
    [self.backScrollView setContentOffset:CGPointMake(WIDTH,0) animated:YES];
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.01];// [UIColor clearColor];
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.contentView];

    returnBtnL = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 46, 59, 35, 35)];
    [returnBtnL setImage:[UIImage imageNamed:@"closeH"] forState:UIControlStateNormal];
    [returnBtnL addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    returnBtnL.hidden = YES;
    [self.backScrollView addSubview:returnBtnL];
    quitBtnL = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 46, HEIGHT - 60, 35, 35)];
    [quitBtnL setImage:[UIImage imageNamed:@"tuichuqingping"] forState:UIControlStateNormal];
    [quitBtnL addTarget:self action:@selector(quitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    quitBtnL.hidden = YES;
    [self.backScrollView addSubview:quitBtnL];
    
        UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 46, 59, 35, 35)];
        [returnBtn setImage:[UIImage imageNamed:@"closeH"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:returnBtn];
        
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(16, 59, 35, 35)];
        avatar.layer.cornerRadius = 17.5;
        avatar.clipsToBounds = YES;
        [avatar sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:self.dataDic[@"shopLogo"]]] placeholderImage:[UIImage imageNamed:@"椭圆 6"]] ;
        [self.contentView addSubview:avatar];
        
    CGFloat nickNameW = [Tool getLabelWidthWithText:[NSString isNullStr:self.dataDic[@"shopName"]] height:35 font:18];
    if (nickNameW > 180) {
        nickNameW = 180;
    }
        self.nickName = [[UILabel alloc] initWithFrame:CGRectMake(avatar.right + 5, 59, nickNameW, 35)];
        
    self.nickName.text = [NSString isNullStr:self.dataDic[@"shopName"]];
        self.nickName.font = [UIFont systemFontOfSize:18];
        self.nickName.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.nickName];
        
        self.onLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 46 - 60, 59, 55, 35)];
        self.onLineLabel.font = [UIFont systemFontOfSize:13];
        self.onLineLabel.textColor = [UIColor whiteColor];
        self.onLineLabel.text = @"1";
        self.onLineLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.onLineLabel];
      self.followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.followBtn.backgroundColor = [UIColor redColor];
    self.followBtn.layer.cornerRadius = 15;
    self.followBtn.clipsToBounds = YES;
    
    self.followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.followBtn];
    @weakify(self);
    [self.followBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self updateFollow];
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
            self.moreView.isActor = NO;
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
    
    if ([self.dataDic[@"notice"] length] != 0) {
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
        CGFloat nameW = [Tool getLabelWidthWithText:[NSString stringWithFormat:@"%@:%@",TransOutput(@"直播公告"),[NSString isNullStr:self.dataDic[@"notice"]]] height:20 font:16];
        NSString *str = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.dataDic[@"notice"]]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [str length])];
        NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@"  "];
        [att insertAttributedString:speaceString atIndex:0];//加入文字前面

        
        [att insertAttributedString:imageStr atIndex:0];//加入文字前面

   
        NSString *string = [NSString stringWithFormat:@"%@:%@",TransOutput(@"直播公告"),[NSString isNullStr:self.dataDic[@"notice"]]];
    CGFloat ws = [Tool getLabelWidthWithText:string height:40 font:14] +20;
    if (nameW  > WIDTH - 182) {
        nameW = WIDTH - 182;
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
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString isNullStr:self.dataDic[@"notice"]]];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, HEIGHT - 400, WIDTH - 32, 300) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.clipsToBounds = YES;

        [self.contentView addSubview:self.tableView];
      
    [self.contentView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.stickerView.textView = nil;
        [self.bottomView.contentTF resignFirstResponder];
        self.bottomView.contentTF.inputView = nil;
    }];
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  }
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = kbFrame.size.height ;
  
   
    CGRect begin = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat curkeyBoardHeight = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        CGFloat keyBoardHeight = curkeyBoardHeight ;
         NSLog(@"第三次：%f",keyBoardHeight);
        // 调整视图位置
        self.backScrollView.frame = CGRectMake(0, -keyBoardHeight, self.backScrollView.size.width, self.backScrollView.size.height);
       }
    else{
        self.backScrollView.frame = CGRectMake(0, -curkeyBoardHeight, self.backScrollView.size.width, self.backScrollView.size.height);
    }
}
- (void)keyboardWillHide:(NSNotification*)aNotification {
    self.backScrollView.frame = CGRectMake(0, 0, self.backScrollView.size.width, self.backScrollView.size.height);
}
-(void)updateFollowTitle{
    NSString *folStr;
    if ([self.isFollow isEqual:@"0"]) {
        folStr =TransOutput(@"关注");
        
    }else{
        folStr = TransOutput(@"取消关注");
    }
    
    CGFloat foW = [Tool getLabelWidthWithText:folStr height:35 font:14];
 
    self.followBtn.frame = CGRectMake(self.nickName.right +5, self.nickName.top + 2.5, foW + 20, 30);
    [self.followBtn setTitle:folStr forState:UIControlStateNormal];
  
}
-(void)updateFollow{
    if (!account.isLogin) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self pushController:vc];
        return;
    }
    [NetwortTool getUpdateFollowWithParm:@{@"shopId":self.dataDic[@"shopId"]} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.isFollow isEqual:@"1"]) {
                self.isFollow = @"0";
                
            }else{
                self.isFollow = @"1";
            }
            [self updateFollowTitle];
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
}
-(void)sendMessage:(NSString *)msg msgType:(NSInteger)messageType{
    if (msg.length <= 0) {
        return;
    }
    if (!account.isLogin) {
        ToastShow(TransOutput(@"未登录"), errImg,RGB(0xFF830F));
        return;
    }
    if ([self.speechStatus isEqual:@"0"]) {
        ToastShow(TransOutput(@"你已被禁言"), errImg,RGB(0xFF830F));
        return;
    }
    bool bool_true;
    if ([self.isadmin isEqual:@"1"]) {
        bool_true= true;
    }
    else{
        bool_true= false;
    
    }

      
    
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
        msgDic = @{
            @"isAdmin":@(bool_true),
            @"message":msg,
            @"messageType":@(messageType),
            @"senderUser":@{@"userId":self.userId,@"userName":account.userInfo.nickName}
        };
    }
    MessageModel *model = [MessageModel mj_objectWithKeyValues:msgDic];
    [self.msgListArray addObject:model];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self jumpLast:self.tableView];
    });
    
    
    [[RTM sharedRtmTool] sendMessageWithDictionary:msgDic withChannel:self.channel];
    if ( messageType == 1 || messageType == 2 ||  messageType == 3 || messageType == 8 || messageType == 9) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 在延迟3秒后执行代码
            // ...
            [self.msgListArray removeObject:model];
            [self.tableView reloadData];
            [self jumpLast:self.tableView];
        });
    }
}
-(void)showShopView{
    [self.view addSubview:self.shopCarView];
    [self.shopCarView updataList:self.channel isadmin:self.isadmin];
    
    [self.shopCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.mas_offset(0);
    }];
    @weakify(self)
    [self.shopCarView setAddShopBlock:^{
        @strongify(self);
        [self.shopCarView removeFromSuperview];
        [self.view addSubview:self.addShopCarView];
        [self.addShopCarView updataData];
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
    
    ChatTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ChatTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.bgview.backgroundColor = RGB_ALPHA(0x010101, 0.3);
    if (self.msgListArray.count > 0) {
        MessageModel *model = self.msgListArray[indexPath.section];
        cell.zhuboID = self.dataDic[@"userId"];
        cell.model = model;
    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.msgListArray[indexPath.section];
 
    if ([self.isadmin isEqual:@"1"] && ![model.senderUser[@"userId"] isEqual:account.userInfo.userId]) {
        self.selectUserId = model.senderUser[@"userId"];
        self.selectUserNickName = [NSString isNullStr:model.senderUser[@"userName"]];
        [_setView show];
        [self.view addSubview: self.setView];
        [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_offset(0);
        }];
    }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.msgListArray.count > 0) {
        
    
    MessageModel *model = self.msgListArray[indexPath.section];
    if (model.messageType == 11) {
        CGFloat h = [Tool getLabelHeightWithText:[NSString isNullStr:model.message] width:WIDTH - 40-120 font:15];
      
        return h + 18;
    }
    else
    {
        if ([model.senderUser[@"userId"] isEqual:self.dataDic[@"userId"]]  ){
            NSString *str = [NSString stringWithFormat:@"%@     ：%@",TransOutput(@"主播"),[NSString isNullStr:model.message]];
           
            CGFloat h = [Tool getLabelHeightWithText:str width:WIDTH - 48-120 font:15];
            return  h + 18;
        }
        else if (model.isAdmin) {
            //管理员
            NSString *str = [NSString stringWithFormat:@"%@     %@：%@",TransOutput(@"管理员"),[NSString isNullStr:model.senderUser[@"userName"]],[NSString isNullStr:model.message]];
            CGFloat h = [Tool getLabelHeightWithText:str width:WIDTH - 48-120 font:15];
            return  h + 18;
        }
        else{
            
                NSString *str = [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:model.senderUser[@"userName"]],[NSString isNullStr:model.message]];
                
                CGFloat h = [Tool getLabelHeightWithText:str width:WIDTH - 48-120 font:15];
                return  h + 18;
            
        }
    }
    }
    else{
        return 0;
    }
}

-(void)sendEnterRoom{
    
}
-(void)loadData{
    
    [NetwortTool getRtmInfoUserWithParm:@{@"userId":self.userId,@"uid":self.uid,@"channel":self.channel} Success:^(id  _Nonnull responseObject) {
            
        self.isFollow = [NSString stringWithFormat:@"%@",responseObject[@"isFollow"]];
        self.isadmin = [NSString stringWithFormat:@"%@",responseObject[@"isManager"]];
        self.speechStatus = [NSString stringWithFormat:@"%@",responseObject[@"speechStatus"]];
        [self.shopCarView updataList:self.channel isadmin:self.isadmin];
       
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        
        }];
}
- (UIView *)videoPreview {
    if (!_videoPreview) {
        _videoPreview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _videoPreview;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
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
        self.shopCarView.pubHeight.constant = 44;
        _shopCarView.isShowDown = NO;
        @weakify(self);
        [_shopCarView setPushGoodDetailBlock:^(NSDictionary * _Nonnull dic) {
            @strongify(self);
            
            HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
            vc.prodId = dic[@"prodId"];
            [self pushController:vc];
            
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
        _moreView.isActor = NO;
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
    
    [NetwortTool getAddManagerWithParm:@{@"userId":self.selectUserId,@"shopId":self.dataDic[@"shopId"]} Success:^(id  _Nonnull responseObject) {
        NSLog(@"设置管理员数据：%@",responseObject);
        NSString *str = [NSString stringWithFormat:@"%@",[NSString isNullStr:responseObject[@"data"][@"isManager"]]];
        if ([str isEqual:@"1"]) {
            
            [self sendMessage:[NSString stringWithFormat:@"%@%@",self.selectUserNickName,TransOutput(@"被设置为管理员")] msgType:8];
        }
        else{
            [self sendMessage:[NSString stringWithFormat:@"%@%@",self.selectUserNickName,TransOutput(@"被取消管理员")] msgType:9];
        }
        
        ToastShow(TransOutput(@"操作成功"), @"chenggong",RGB(0x36D053));
        
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
