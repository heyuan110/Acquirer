//
//  PlainTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PlainTableCell.h"

@implementation PlainTableCell

@synthesize titleLabel, textLabel;

-(void)dealloc{
    [titleLabel release];
    [textLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat offset = 20;
        CGFloat titleWidth = 150;
        CGRect titleFrame = CGRectMake(offset, 0, titleWidth, self.bounds.size.height);
        titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLabel];
        
        CGFloat textWidth = 100;
        CGRect textFrame = CGRectMake(self.bounds.size.width-textWidth-offset, 0, textWidth, self.bounds.size.height);
        textLabel = [[UILabel alloc] initWithFrame:textFrame];
        titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:textLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end