//
//  LiveStartShowView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/7.
//

#import "LiveStartShowView.h"
@interface LiveStartShowView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *liveNameTF;
@property (weak, nonatomic) IBOutlet UILabel *liveNoticLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextView *liveNotiTX;
@property (weak, nonatomic) IBOutlet UIView *liveClass;
@property (weak, nonatomic) IBOutlet UILabel *liveClassLabel;
@property (weak, nonatomic) IBOutlet UIButton *liveClassTypeBtn;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *del;
@property (nonatomic, strong) RoomInfoModel*model;
@property (nonatomic, strong)UIButton *Agree;
@property (nonatomic, strong)UITextView *agreeTx;
@property (nonatomic, strong)NSString *isAgree;
@property (nonatomic, strong)NSString *categoryId;
@end
@implementation LiveStartShowView
-(void)setPic:(NSString *)pic{
    _pic = pic;
    if (pic.length != 0 ) {
        self.del.hidden = NO;
    }
    else{
        self.del.hidden = YES;
    }
}
- (void)setCategoryNameDic:(NSDictionary *)categoryNameDic{
    _categoryNameDic = categoryNameDic;
    [self.liveClassTypeBtn setTitle:categoryNameDic[@"categoryName"] forState:UIControlStateNormal];
    self.categoryId = [NSString stringWithFormat:@"%@",categoryNameDic[@"showCategoryId"]];
    [self.liveClassTypeBtn setTitleColor:RGB(0x000000) forState:UIControlStateNormal];
}
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.isAgree = @"";
    self.categoryId = @"";
    self.startLabel.text =TransOutput(@"开启直播");
    self.liveNameLabel.text = TransOutput(@"直播名称:");
    self.liveClassLabel.text = TransOutput(@"直播分类:");
    [self.liveClassTypeBtn setTitle:TransOutput(@"请选择类型") forState:UIControlStateNormal];
    [self.liveClassTypeBtn addTarget:self action:@selector(typeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.liveClassTypeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.liveClassTypeBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    self.liveNameTF.placeholder = TransOutput(@"请输入直播名称");
    self.liveNoticLabel.text = [NSString stringWithFormat:@"%@:",TransOutput(@"直播公告")];
    self.numberLabel.text = @"0/200";
    [self.liveNotiTX setPlaceholderWithText:TransOutput(@"请输入直播公告") Color:RGB(0xBBB8B8)];
    self.liveNotiTX.delegate = self;
    
    self.startBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    @weakify(self);
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    self.picBtn.backgroundColor = RGB(0xF6FAFE);
    self.picBtn.layer.borderColor = RGB(0xA3CCF9).CGColor;
    self.picBtn.layer.borderWidth = 0.5;
    [self.picBtn setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
    [self.picBtn setTitle:TransOutput(@"商品图片") forState:UIControlStateNormal];
    self.picBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.picBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
    self.picBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    [self.picBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
    NSString *str = [NSString stringWithFormat:@"%@",TransOutput(@"ライブ配信規約を確認し、同意します。")];
    CGFloat w = [Tool getLabelWidthWithText:str height:35 font:14] + 40;
    if (w > WIDTH - 60) {
        w = WIDTH - 60;
    }
    self.Agree = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [self.Agree setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [self.Agree addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.Agree];
    [self.Agree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.picBtn.mas_bottom).offset(12);
        make.leading.mas_offset((WIDTH - w - 20) / 2);
        make.width.height.mas_offset(20);
    }];
    
  
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:str];
   
    NSString *valueString = [[NSString stringWithFormat:@"firstPerson://1"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
      
    [attstring addAttribute:NSLinkAttributeName value:valueString range:NSMakeRange(0, 7)];
   

    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 7)];
     
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:NSMakeRange(0, 7)];

 
    self.agreeTx = [[UITextView alloc] init];
    self.agreeTx.delegate = self;
    self.agreeTx.attributedText =attstring;
    self.agreeTx.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0); // 上 左 下 右
    self.agreeTx.font = [UIFont systemFontOfSize:14];
    self.agreeTx.textAlignment = NSTextAlignmentLeft;
    self.agreeTx.editable = NO; // 如果你不希望用户编辑文本，设置为NO
    [self addSubview:self.agreeTx];
    [self.agreeTx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.Agree);
        make.leading.mas_equalTo(self.Agree.mas_trailing).offset(0);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(20);
    }];

    
    // Initialization code
}
-(void)typeClick{
    ExecBlock(self.categoryChoseClickBlock);
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
 
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        ExecBlock(self.pushLiveXieyiClickBlock);
        return NO;
    }
   
    return YES;
 
}
-(void)agreeClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [self.Agree setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
           self.isAgree = @"1";
    }else{
        sender.selected = NO;
        [self.Agree setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
             self.isAgree = @"";
    }
}
-(void)updataModel:(RoomInfoModel *)model{
    self.model = model;

        [self.startBtn setTitle:TransOutput(@"提交申请") forState:UIControlStateNormal];
        self.liveNameTF.text = [NSString isNullStr:model.msg];
    self.liveNotiTX.text = [NSString isNullStr:model.notice];
        [self.picBtn setImage:[UIImage new] forState:UIControlStateNormal];
    if ([[NSString isNullStr:model.showCategoryName] length] == 0) {
        [self.liveClassTypeBtn setTitle:TransOutput(@"请选择类型") forState:UIControlStateNormal];
        [self.liveClassTypeBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    }else{
        [self.liveClassTypeBtn setTitle:[NSString isNullStr:model.showCategoryName] forState:UIControlStateNormal];
        [self.liveClassTypeBtn setTitleColor:RGB(0x000000) forState:UIControlStateNormal];
    }
    self.categoryId = [NSString isNullStr:model.showCategoryId];
        [self.picBtn setTitle:@"" forState:UIControlStateNormal];
    if ([[NSString isNullStr:model.imgPath] length] >0 ) {
        [self.picBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:model.imgPath]] forState:UIControlStateNormal ];
        self.pic = model.imgPath;
        self.del.hidden = NO;
    }
    else{

        [self.picBtn setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
        [self.picBtn setTitle:TransOutput(@"商品图片") forState:UIControlStateNormal];
        [self.picBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal ];
        self.del.hidden = YES;
    }
       
        self.numberLabel.text =[NSString stringWithFormat:@"%lu/200",(unsigned long)[NSString isNullStr:model.notice].length];

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = textView.text.length + text.length - range.length;
   
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)newLength];
    
    return newLength <= 200;
    
}
- (IBAction)picClick:(id)sender {
    ExecBlock(self.picClickBlock);
}
- (IBAction)closeClick:(id)sender {
    [self removeFromSuperview];
    
}
- (IBAction)delClick:(UIButton *)sender {

    self.picBtn.backgroundColor = RGB(0xF6FAFE);
    self.picBtn.layer.borderColor = RGB(0xA3CCF9).CGColor;
    self.picBtn.layer.borderWidth = 0.5;
    [self.picBtn setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
    [self.picBtn setTitle:TransOutput(@"商品图片") forState:UIControlStateNormal];
    self.picBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.picBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
    self.picBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    [self.picBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
    [self.picBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    self.pic = @"";
    self.del.hidden = YES;
}
- (IBAction)submitClick:(UIButton *)sender {
    if (self.liveNameTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入直播名称"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.categoryId.length == 0) {
        ToastShow(TransOutput(@"请选择直播类型"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.pic.length == 0) {
        ToastShow(TransOutput(@"请选择图片"), errImg,RGB(0xFF830F));
        return;
    }
    
    if (self.isAgree.length == 0) {
        ToastShow(TransOutput(@"ライブ配信規約をお読みいただき、ご同意をお願いします。"), errImg,RGB(0xFF830F));
        return;
    }
    ExecBlock(self.startLiveBlock,self.liveNameTF.text,self.liveNotiTX.text,self.pic,self.model,self.categoryId,self.liveClassTypeBtn.titleLabel.text);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
