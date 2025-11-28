//
//  CheckWuLiuViewController.m
//  Netneto
//
//  Created by apple on 2024/10/18.
//

#import "CheckWuLiuViewController.h"

@interface CheckWuLiuViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UITextView *nameWuLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoBottomHeight;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray*dataArr;
@property (nonatomic, strong) NSDictionary*dataDic;
@end

@implementation CheckWuLiuViewController
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
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}

-(void)CreateView{
  
  
  
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"查看物流");
    [self.infoView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(16);
        make.bottom.mas_offset(-16);
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void)GetData{
    [NetwortTool getYamatoWithParm:@{@"orderNumber":self.orderNumber} Success:^(id  _Nonnull responseObject) {
        NSLog(@"物流信息%@",responseObject);
        self.dataDic =responseObject;
        if ([responseObject[@"companyName"] length] >0) {
            self.tableView.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"%@ %@",[NSString isNullStr:responseObject[@"companyName"]],[NSString isNullStr:responseObject[@"dvyFlowId"]]];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
            [att addAttributes:@{NSForegroundColorAttributeName:RGB(0x1684CF)} range:NSMakeRange(0, [[NSString isNullStr:responseObject[@"companyName"]] length])];
            
            self.nameWuLabel.attributedText = att;
            self.dataArr  = responseObject[@"details"];
            [self.tableView reloadData];
        }
        else{
            NSString *str = [NSString stringWithFormat:@"%@\n%@ | %@",TransOutput(@"其他运输"),responseObject[@"dvyFlowId"],TransOutput(@"复制")];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
//            [att addAttributes:@{NSForegroundColorAttributeName:RGB(0x1684CF)} range:NSMakeRange(str.length - [TransOutput(@"复制") length] - 2, [TransOutput(@"复制") length] + 2)];
            [att addAttributes:@{NSForegroundColorAttributeName:RGB(0x0F7CFD)} range:NSMakeRange(0, [TransOutput(@"其他运输") length])];
            [att addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(0, [TransOutput(@"其他运输") length])];
            
            [att addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:NSMakeRange([TransOutput(@"其他运输") length], [responseObject[@"dvyFlowId"] length] + 1)];
            
            NSString *valueString = [[NSString stringWithFormat:@"firstPerson://1"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            
            [att addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(str.length - [TransOutput(@"复制") length]-2, [TransOutput(@"复制") length] + 2)];
            
            [att addAttribute:NSLinkAttributeName value:valueString range:NSMakeRange(str.length - [TransOutput(@"复制") length] - 2, [TransOutput(@"复制") length] + 2)];
            self.nameWuLabel.attributedText = att;
            
            self.nameWuLabel.delegate = self;
            self.infoBottomHeight.constant = 400;
            self.tableView.hidden = YES;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, WIDTH - 64, 200)];
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = RGB(0x4B4B4B);
            label.text = TransOutput(@"本网站目前无法对大和运输以外的配送发票号码进行状况确认。 很抱歉给您带来不便，请您谅解。");
            [self.infoView addSubview:label];
            
        }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
 
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.dataDic[@"dvyFlowId"]];
        ToastShow(TransOutput(@"复制成功"), @"chenggong", RGB(0x36D053));
        return NO;
    }
 
    return YES;
 
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckWuLiuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckWuLiuTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CheckWuLiuTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.ima.image = [UIImage imageNamed:@"组合 132"];
    }else{
        cell.ima.image = [UIImage imageNamed:@"组合 219"];
    }
    NSDictionary *dic = self.dataArr[indexPath.row];
    
    cell.dayLabel.text =[NSString isNullStr:dic[@"day"]];
    cell.infoLabel.text =[NSString stringWithFormat:@"%@ %@",[NSString isNullStr:dic[@"time"]],[NSString isNullStr:dic[@"status"]]];
    if (indexPath.row == self.dataArr.count - 1) {
        cell.line.hidden = YES;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        _tableView.showsVerticalScrollIndicator = NO;
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
