//
//  LiveShopCarCollectionViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "LiveShopCarCollectionViewCell.h"

@implementation LiveShopCarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 30, 30) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 30, 30);
    maskLayer.path = maskPath.CGPath;
    self.numLabel.layer.mask = maskLayer;

 
    // Initialization code
}

@end
