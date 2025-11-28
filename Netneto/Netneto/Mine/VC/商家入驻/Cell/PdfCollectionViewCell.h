//
//  PdfCollectionViewCell.h
//  Netneto
//
//  Created by apple on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PdfCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong) UIView *imageV;

@property (nonatomic ,strong) UIButton *pic;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *deleteButotn;
@end

NS_ASSUME_NONNULL_END
