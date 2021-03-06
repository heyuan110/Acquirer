//
//  DetailTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DetailTableCell.h"

@implementation DetailTableCell

@synthesize bankCardLabel, tradeTimeLabel;
@synthesize tradeAmtLabel, tradeTypeLabel, tradeStatLabel;

-(void)dealloc{
    [bankCardLabel release];
    [tradeTimeLabel release];
    [tradeAmtLabel release];
    [tradeTypeLabel release];
    [tradeStatLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat leftOffset = 30;
        CGFloat rightOffset = 40;
        CGFloat leftWidth = 110.0f;
        
        bankCardLabel = [[UILabel alloc] init] ;
        bankCardLabel.frame = CGRectMake(leftOffset, 5, leftWidth, 20);
        bankCardLabel.textAlignment = NSTextAlignmentLeft;
        bankCardLabel.font = [UIFont systemFontOfSize:15];
        bankCardLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:bankCardLabel];
        
        tradeTimeLabel = [[UILabel alloc] init];
        tradeTimeLabel.frame = CGRectMake(leftOffset, 25, leftWidth, 20);
        tradeTimeLabel.font = [UIFont systemFontOfSize:13];
        tradeTimeLabel.textAlignment = NSTextAlignmentLeft;
        tradeTimeLabel.textColor = [UIColor darkGrayColor];
        tradeTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeTimeLabel];
        
        tradeAmtLabel = [[UILabel alloc] init];
        tradeAmtLabel.frame = CGRectMake(CGRectGetMaxX(bankCardLabel.frame), 5, 140, 20);
        tradeAmtLabel.font = [UIFont boldSystemFontOfSize:15];
        tradeAmtLabel.textAlignment = NSTextAlignmentRight;
        tradeAmtLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeAmtLabel];
        
        tradeTypeLabel = [[UILabel alloc] init];
        tradeTypeLabel.frame = CGRectMake(CGRectGetMinX(tradeAmtLabel.frame), CGRectGetMaxY(tradeAmtLabel.frame), 105.0f, 20);
        tradeTypeLabel.font = [UIFont systemFontOfSize:14];
        tradeTypeLabel.textColor = [UIColor darkGrayColor];
        tradeTypeLabel.textAlignment = NSTextAlignmentRight;
        tradeTypeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeTypeLabel];
        
        tradeStatLabel = [[UILabel alloc] init];
        tradeStatLabel.frame = CGRectMake(self.bounds.size.width - rightOffset - 30, 25, 30, 20);
        tradeStatLabel.font = [UIFont boldSystemFontOfSize:14];
        tradeStatLabel.textAlignment = NSTextAlignmentLeft;
        tradeStatLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeStatLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
