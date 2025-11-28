//
//  bankNameSearchView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "bankNameSearchView.h"
@interface bankNameSearchView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *backiew;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *searchTf;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (nonatomic, strong)NSArray *dataArray;
@end
@implementation bankNameSearchView
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
    self.searchTf.delegate = self;
    self.searchTf.returnKeyType = UIReturnKeySearch;
    [self.cancleBtn setTitle:TransOutput(@"取消") forState:UIControlStateNormal];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tipLabel.text  = TransOutput(@"向下述以外的金融机构汇款时，请输入金融机构名的1个字以上进行检索");

    
    
}
-(void)getBankCustomList{
    self.searchTf.text = @"";
    self.dataArray = account.bankArray;
    [self.tableView reloadData];

}
-(void)loadData{
    [HudView showHudForView:self];
    [NetwortTool getBankInfoWithParm:@{@"bankName":self.searchTf.text,@"bankCode":@""} Success:^(id  _Nonnull responseObject) {
        NSLog(@"银行名：%@",responseObject);
        [HudView hideHudForView:self];
        self.dataArray = responseObject;
        if (self.dataArray.count == 0) {
            ToastShow(TransOutput(@"没有银行信息"),@"矢量 20",RGB(0xFF830F)); 
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self];
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
    cell.textLabel.text = [NSString isNullStr:self.dataArray[indexPath.row][@"fullName"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExecBlock(self.sureBlock,self.dataArray[indexPath.row]);
    [self removeFromSuperview];
}
- (IBAction)cancelClick:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)searchClick:(id)sender {
    if(self.searchTf.text.length == 0){
        ToastShow(TransOutput(@"请输入想搜索的金融机构的一个字以上"), errImg, RGB(0xFF830F));
        return;
    }else{
        [self loadData];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.searchTf.text.length == 0){
        ToastShow(TransOutput(@"请输入想搜索的金融机构的一个字以上"), errImg, RGB(0xFF830F));
        return NO;
    }else{
        [self.searchTf resignFirstResponder];
        [self loadData];
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
