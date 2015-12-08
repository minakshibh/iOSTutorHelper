//
//  ParentListTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentListTableViewCell : UITableViewCell
{
    IBOutlet UILabel *NumbrOfStudntsLbl;
    IBOutlet UILabel *balanceLbl;
    IBOutlet UILabel *lessonsLbl;
    IBOutlet UILabel *parentNameLbl;
    IBOutlet UIImageView *backImgView;
}
-(void)setLabelText:(NSString*)parentName :(NSString*)Students :(NSString*)balance :(NSString*)lessons;

@end
