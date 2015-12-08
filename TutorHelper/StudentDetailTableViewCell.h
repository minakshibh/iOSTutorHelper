//
//  StudentDetailTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentDetailTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *studentNameLbl;
    IBOutlet UILabel *contactNumberLbl;
    IBOutlet UILabel *emailAddressLbl;
    IBOutlet UILabel *notesLbl;
    IBOutlet UIImageView *backImgView;
}
-(void)setLabelText:(NSString*)studentName :(NSString*)emailAddrss :(NSString*)contact :(NSString*)notes;

@end
