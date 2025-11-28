//
//  ChatTableViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell
-(void)setZhuboID:(NSString *)zhuboID{
    _zhuboID = zhuboID;
}
-(void)setModel:(MessageModel *)model{
    _model = model;
    
    if (model.messageType == 11) {
        UIImage *image = [UIImage imageNamed:@"Image 1"];

        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -2.5, 16, 16); //这个-2.5是为了调整下标签跟文字的位置
        attach.image = image;
        //添加到富文本对象里
        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
      
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString isNullStr:model.message]];
      
        
        [att insertAttributedString:imageStr atIndex:0];//加入文字前面

        self.contentLabel.attributedText = att;
  
        self.contentLabel.textColor = RGB(0xF4D97A);
    }

    
    else if (model.messageType == 8 ){
        self.contentLabel.text = [NSString stringWithFormat:@"%@%@",[NSString isNullStr:model.recipientUserList[0][@"userName"]],TransOutput(@"被设置为管理员")];

        self.contentLabel.textColor = RGB(0xF4D97A);
        
    }
    else if (model.messageType == 9 ){
        self.contentLabel.text =[NSString stringWithFormat:@"%@%@",[NSString isNullStr:model.recipientUserList[0][@"userName"]],TransOutput(@"被取消管理员")];

        self.contentLabel.textColor = RGB(0xF4D97A);
        
    }
    else if  (model.messageType == 3) {
        NSLog(@"用户id：%@",account.userInfo.userId);
        NSString *uidStr = [NSString stringWithFormat:@"%@",model.recipientUserList[0][@"userId"]];
        if ([uidStr isEqualToString:account.userInfo.userId] ) {
         
            self.contentLabel.text =[NSString stringWithFormat:@"%@",TransOutput(@"你已被禁言")];
            
        }else{
            self.contentLabel.text =[NSString stringWithFormat:@"%@%@",[NSString isNullStr:model.recipientUserList[0][@"userName"]],TransOutput(@"被禁言")];
        }
       

        self.contentLabel.textColor = RGB(0xF4D97A);
    }
    else if  (model.messageType != 5 && model.messageType != 6)
    {
        if ([model.senderUser[@"userId"] isEqual:self.zhuboID]  ) {
            //主播消息
            CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"主播") height:20 font:14];
       
            NSString *str = [NSString stringWithFormat:@"%@：%@",TransOutput(@"主播"),[NSString isNullStr:model.message]];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
            [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(0xFE9803)} range:NSMakeRange(0, [TransOutput(@"主播") length] + 1)];

          
            self.contentLabel.attributedText = att;
        }
        else if (model.isAdmin) {
            //管理员
            CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"管理员") height:20 font:14];
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0, 0, w + 14, 20);
            label.text =TransOutput(@"管理员");
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor gradientColorArr:@[RGB(0xD45375),RGB(0xD45375),RGB(0xD45375)] withWidth:w + 14];
            label.layer.cornerRadius = 8;
            label.clipsToBounds = YES;
            
            UIImage *image = [UIImage imageNamed:@"组合 423"];

            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.bounds = CGRectMake(0, -2.5, w + 14, 16); //这个-2.5是为了调整下标签跟文字的位置
            attach.image = image;
            //添加到富文本对象里
            NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
            CGFloat nameW = [Tool getLabelWidthWithText:[NSString stringWithFormat:@"%@：",[NSString isNullStr:model.senderUser[@"userName"]]] height:20 font:15];
            NSString *str = [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:model.senderUser[@"userName"]],[NSString isNullStr:model.message]];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
            [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor gradientColorArr:@[RGB(0x8CEBFF),RGB(0x8CEBFF),RGB(0x8CEBFF)] withWidth:nameW]} range:NSMakeRange(0, [[NSString isNullStr:model.senderUser[@"userName"]] length] + 1)];
            NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@"  "];
            [att insertAttributedString:speaceString atIndex:0];//加入文字前面

            
            [att insertAttributedString:imageStr atIndex:0];//加入文字前面

            self.contentLabel.attributedText = att;
        }
        else{
            
            NSString *str;
            
            if (model.messageType  == 1) {
                str= [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:model.senderUser[@"userName"]],TransOutput(@"来了")];
            }
           else if (model.messageType == 2) {
               str= [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:model.senderUser[@"userName"]],TransOutput(@"走了")];
            }
            else{
                str= [NSString stringWithFormat:@"%@：%@",[NSString isNullStr:model.senderUser[@"userName"]],model.message];
            }
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
            [att addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGB(0x8CEBFF)} range:NSMakeRange(0, [[NSString isNullStr:model.senderUser[@"userName"]] length] + 1)];
            self.contentLabel.attributedText = att;
       
        }
    }
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
