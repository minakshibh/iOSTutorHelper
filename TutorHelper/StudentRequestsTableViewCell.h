//
//  StudentRequestsTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 13/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentRequestsTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *idLbl;
    IBOutlet UILabel *feesLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *contactLbl;
    IBOutlet UIImageView *backImgView;
}

-(void)setLabelText:(NSString*)sendrIdStr :(NSString*)senderNameStr :(NSString*) feesStr :(NSString*)emailStr :(NSString*)contactStr ;

@end
