//
//  TPUIBaseTableViewCell.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "TPUIBaseTableViewCell.h"

@implementation TPUIBaseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self makeConstraints];
    }
    return self;
}
- (void)setupSubviews {}
- (void)makeConstraints {}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
