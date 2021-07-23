/**
 *  @file   FindPanelWindowController.m
 *  @brief  FindPanelWindowController Class Implementation (ObjC)
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/
#import "FindPanelWindowController.h"

@implementation FindPanelWindowController

@synthesize find;
@synthesize replacewith;
@synthesize ignorecase;
@synthesize wraparound;
@synthesize delegate;

- (id) init {
  
  if (!(self = [super initWithWindowNibName: @"FindPanel"])) {
    
    return nil;
  }
  
  return self;
}

- (IBAction)findNext:(id)sender {

    [delegate searchFor:[self.find stringValue] direction:YES caseSensitive:![self.ignorecase state] wrap:[self.wraparound state]];
}

- (IBAction)findPrevious:(id)sender {
  
    [delegate searchFor:[self.find stringValue] direction:YES caseSensitive:![self.ignorecase state] wrap:[self.wraparound state]];
}

- (void)performFindPanelAction:(id)sender {
  
  switch ([sender tag]) {
    
    case NSFindPanelActionShowFindPanel:
    
    [self showWindow:sender];
    break;
    
    case NSFindPanelActionNext:
    
    [self findNext:sender];
    
    break;
    
    case NSFindPanelActionPrevious:
    
    [self findPrevious:sender];
    
    break;
  }
}
@end
