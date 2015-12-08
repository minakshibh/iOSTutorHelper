//
//  InstructionsViewController.h
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController
{
    BOOL imagCount;
    IBOutlet UIImageView *instructionImageView;
}
- (IBAction)skipActionBtn:(id)sender;
- (IBAction)nextActionBtn:(id)sender;

@end
