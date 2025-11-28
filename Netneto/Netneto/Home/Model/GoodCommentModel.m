//
//  GoodCommentModel.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "GoodCommentModel.h"

@implementation GoodCommentModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.prodCommId = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"prodCommId"]]] ;
        self.score = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"score"]]];
        self.replyContent = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"replyContent"]]];
        self.recTime = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"recTime"]]];
        self.nickName = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"nickName"]]];
        self.content = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"content"]]];
        self.pics = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"pics"]]];
        self.pic = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"pic"]]];
        self.imgH = 0;
        self.replyH = 0;
        self.rowH = 50;
    }
    [self setmyframe:self];
    return self;
}
-(void)setmyframe:(GoodCommentModel *)model{
    
//    CGFloat nameH = 51 + 24 + 30;
    CGFloat nameH = 56;
    CGFloat contentH = [Tool getLabelHeightWithText:[NSString isNullStr:model.content] width:WIDTH - 32 font:12] + 12;
   
    if ([[NSString isNullStr:model.replyContent] length] == 0) {
        _replyH = 0;
    }else{
        NSString *replyStr =  [NSString stringWithFormat:@"%@:%@",TransOutput(@"掌柜回复"),[NSString isNullStr:model.replyContent]];
        
        _replyH = [Tool getLabelHeightWithText:replyStr width:WIDTH - 32 font:12] + 12;
    }
    CGFloat imgw = (WIDTH - 15 * 4 ) / 3;
    
    if (self.pics.length > 0) {
        NSArray *imgArr = [self.pics componentsSeparatedByString:@","];
        if(imgArr.count % 3 == 0){
            _imgH = imgArr.count / 3 * (imgw + 15);
        }
        else{
            _imgH = (imgArr.count / 3 + 1 )* (imgw + 15);
        }
    }
    _rowH = nameH + contentH  + _replyH + 9 + _imgH + 20 ;
}
-(instancetype)modelWithDic:(NSDictionary *)dic{
    GoodCommentModel *model = [[GoodCommentModel alloc] initWithDic:dic];
    return model;
}
@end
