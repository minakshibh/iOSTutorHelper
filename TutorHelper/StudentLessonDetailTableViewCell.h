//
//  StudentLessonDetailTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 19/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentLessonDetailTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *studentNameLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *contctLbl;
    IBOutlet UILabel *studBgLbl;
    IBOutlet UILabel *feesLbl;
    IBOutlet UILabel *addressLbl;
    IBOutlet UILabel *fees;
}
-(void)setLabelTextForParent:(NSString*)studentName :(NSString*)emailAddrss :(NSString*)contact :(NSString*)address: (NSString*)fee;

-(void)setLabelTextForTutor:(NSString*)studentName :(NSString*)emailAddrss :(NSString*)contact :(NSString*)address: (NSString*)fees;

@end
