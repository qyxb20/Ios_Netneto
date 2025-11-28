//
//  ImageModel.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "ImageModel.h"

@implementation ImageModel
-(instancetype)initWithDic:(NSString *)usrlStr{
    self = [super init];
    if (self) {
        self.url = usrlStr;
        
    }
    [self setmyframe:self];
    return self;
}
-(void)setmyframe:(ImageModel *)model{
    CGSize imageSize = [Tool getImageSizeWithURL:[NSString isNullStr:model.url]];
    _imageH = WIDTH * imageSize.height / imageSize.width;
}
-(instancetype)modelWithDic:(NSString *)usrlStr{
    ImageModel *model = [[ImageModel alloc] initWithDic:usrlStr];
    return model;
}
@end
