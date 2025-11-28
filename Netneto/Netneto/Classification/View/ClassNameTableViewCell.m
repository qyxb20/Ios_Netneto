//
//  ClassNameTableViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "ClassNameTableViewCell.h"
@interface ClassNameTableViewCell ()

@property (nonatomic, strong) ClassNameLabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation ClassNameTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}


#pragma mark - UI
- (void)createView{
    [self addSubview:self.nameLabel];
    [self addSubview:self.lineView];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(0);
        make.top.bottom.mas_offset(0);
        make.width.mas_offset(1.5);
    }];
    
}


#pragma mark - Model
- (void)setTabModel:(ClassNameModel *)tabModel{
    self.nameLabel.text = [NSString isNullStr:tabModel.categoryName];
    if (tabModel.isSeleced == YES) {
        self.nameLabel.backgroundColor = [UIColor whiteColor];
   
        self.lineView.backgroundColor = RGB(0x197CF5);
       
        }else{
         self.lineView.backgroundColor = RGB(0xF7F7F7);
        self.nameLabel.backgroundColor = RGB(0xF7F7F7);
   
       
    }
}


#pragma mark - lazy
- (ClassNameLabel *)nameLabel{
    if (_nameLabel == nil) {
       
        _nameLabel = [[ClassNameLabel alloc]init];
        _nameLabel.textColor = RGB(0x646464);
        _nameLabel.backgroundColor = RGB(0xF7F7F7);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 2;
        _nameLabel.padding = CGSizeMake(10, 5);
    }
    return _nameLabel;
}
- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor darkGrayColor];
    }
    return _lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
