//
//  bankZhiNameView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/10.
//

#import "bankZhiNameView.h"
@interface bankZhiNameView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backiew;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *nameSearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeSearchBtn;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSDictionary *datadDic;
@property (nonatomic, strong)NSString *valueRequest;
@end
@implementation bankZhiNameView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    @weakify(self)
    [self.backiew addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    [self.bottomView addTopCornerPath:20];
    [self.searchBtn setTitle:TransOutput(@"银行搜索") forState:UIControlStateNormal];
    self.searchBtn.backgroundColor =[UIColor gradientColorArr:MainColorArr withWidth:100];
    self.searchTf.placeholder = TransOutput(@"请输入");
    [self.cancleBtn setTitle:TransOutput(@"取消") forState:UIControlStateNormal];
    self.tipLabel.text =TransOutput(@"指定查找方法后，请输入要汇款的分行/办事处名称或3位数字的分行编号");
    self.nameSearchBtn.backgroundColor =[UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 100];
    [self.nameSearchBtn setTitle:TransOutput(@"按照分行名称搜索") forState:UIControlStateNormal];
    [self.codeSearchBtn setTitle:TransOutput(@"按照分行编号搜索") forState:  UIControlStateNormal];
    
    self.valueRequest = @"bankName";
   
    [self.nameSearchBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.valueRequest =@"bankName";
        self.nameSearchBtn.backgroundColor =[UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 100];
        self.codeSearchBtn.backgroundColor = [UIColor opaqueSeparatorColor];
    }];
    [self.codeSearchBtn addTapAction:^(UIView * _Nonnull view) {
        self.valueRequest =@"bankCode";
        self.codeSearchBtn.backgroundColor =[UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 100];
        self.nameSearchBtn.backgroundColor = [UIColor opaqueSeparatorColor];

    }];
    
    
}
-(void)updateWithDatadic:(NSDictionary *)dic{
    self.datadDic = dic;
    self.bankNameLabel.text = [NSString isNullStr:dic[@"fullName"]];
    self.searchTf.text = @"";
    self.dataArray = @[];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}
-(void)loadData{
    
//    NSString *str = [NSString stringWithFormat:@"bankId=%@&%@=%@",self.datadDic[@"id"],self.valueRequest,self.searchTf.text];
    
    [NetwortTool getBankZhiInfoWithParm:@{@"bankId":self.datadDic[@"id"],self.valueRequest:self.searchTf.text} Success:^(id  _Nonnull responseObject) {
        NSLog(@"支行名：%@",responseObject);
        self.dataArray = responseObject;
        if (self.dataArray.count == 0) {
            ToastShow(TransOutput(@"没有银行信息"),@"矢量 20",RGB(0xFF830F));
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString isNullStr:self.dataArray[indexPath.row][@"name"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExecBlock(self.sureBlock,self.dataArray[indexPath.row]);
    [self removeFromSuperview];
}

- (IBAction)sechClick:(id)sender {
    if(self.searchTf.text.length == 0){
        ToastShow(TransOutput(@"支行名或者支行编码不可为空"), errImg, RGB(0xFF830F));
        return;
    }
    [self loadData];
}
- (IBAction)cancleClick:(id)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
