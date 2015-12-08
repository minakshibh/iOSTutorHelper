//
//  downloadInvoiceTableViewCell.m
//  TutorHelper
//
//  Created by Krishna Mac Mini 2 on 26/10/15.
//  Copyright © 2015 Krishnais. All rights reserved.
//

#import "downloadInvoiceTableViewCell.h"
#import "downloadInvoiceViewController.h"

@implementation downloadInvoiceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)monthName :(NSString*)downloadLink
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:downloadLink];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    lblDownloadLink.attributedText = [attributeString copy];
    
    lblMonth.text = [NSString stringWithFormat:@"%@",monthName];
    
    lblBackgroundLbl.layer.cornerRadius =5.0f;
    [[lblBackgroundLbl layer] setMasksToBounds:YES];
}
@end
