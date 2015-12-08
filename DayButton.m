//
//  DayButton.m
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DayButton.h"



@implementation DayButton
@synthesize delegate, buttonDate;

- (id)buttonWithFrame:(CGRect)buttonFrame
{
	self = [DayButton buttonWithType:UIButtonTypeCustom];
	
	self.frame = buttonFrame;
	self.titleLabel.textAlignment = NSTextAlignmentRight;
	self.backgroundColor = [UIColor clearColor];
	[self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"cell-bg1.png"] forState:UIControlStateNormal];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ViewType"] isEqualToString:@"SettingsView"])
    {
        
    //Long press on button
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        [longPress release];
        
        //double tap on button
        
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
        tapTwice.numberOfTapsRequired = 2;
        [tapTwice requireGestureRecognizerToFail:tapTwice];
        [self addGestureRecognizer:tapTwice];
        
        
        
        
    }
    else
    {
        [self addTarget:delegate action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    }
    
	//[self addTarget:delegate action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	return self;
}

-(IBAction)longPress:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"longBtnPressed" forKey:@"buttonPressedType"];
  	[self.delegate dayButtonPressed:self];
}
-(IBAction)tapTwice:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"DoubleTap" forKey:@"buttonPressedType"];

    [self.delegate dayButtonPressed:self];

}

- (void)layoutSubviews
{
	[super layoutSubviews];
	UILabel *titleLabel = [self titleLabel];
	CGRect labelFrame = titleLabel.frame;
	int framePadding = 6;
//	labelFrame.origin.x = self.bounds.size.width-9 - labelFrame.size.width ;
//	labelFrame.origin.y = framePadding;
    labelFrame.size.width=17;

    
    if ( IS_IPHONE_6)
    {
        labelFrame.origin.x = self.bounds.size.width-9 - labelFrame.size.width+2 ;
        labelFrame.origin.y = framePadding+3;
    }
  else  if (IS_IPHONE_6P )
    {
        labelFrame.origin.x = self.bounds.size.width-9 - labelFrame.size.width-3 ;
        labelFrame.origin.y = framePadding+3;
    }
   else if (IS_IPHONE_5)
    {
        labelFrame.origin.x = self.bounds.size.width-9 - labelFrame.size.width+5 ;
        labelFrame.origin.y = framePadding;
    }
    else{
        labelFrame.origin.x = self.bounds.size.width-9 - labelFrame.size.width+3;
        labelFrame.origin.y = framePadding;
    }
    [self titleLabel].textAlignment=NSTextAlignmentLeft;
    
	[self titleLabel].frame = labelFrame;
}

- (void)dealloc {
    [super dealloc];
}


@end
