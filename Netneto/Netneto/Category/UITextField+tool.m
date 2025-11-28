//
//  UITextField+tool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/18.
//

#import "UITextField+tool.h"

@implementation UITextField (tool)
-(void)addPlachColor:(NSString *)plaStr color:(UIColor *)color{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:plaStr attributes:
    @{NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraphStyle
         }];
  
    self.attributedPlaceholder = attrString;

}
@end
