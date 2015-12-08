//
//  ConnectionRequestTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 08/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionRequestTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *sender_idlbl;
    IBOutlet UIImageView *BackImgView;
    IBOutlet UILabel *senderNamelbl;
}
-(void)setLabelText:(NSString*)sendrIdStr :(NSString*)senderNameStr  ;

@end
