/**
 *  @file   FindPanelWindowController.h
 *  @brief  FindPanelWindowController Class Definition (ObjC)
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/

#ifndef FINDPANELWINDOWCONTROLLER_H_
#define FINDPANELWINDOWCONTROLLER_H_

#import <Cocoa/Cocoa.h>

@protocol SearchForDelegate <NSObject>
@required
- (void) searchFor:(NSString *)string direction:(BOOL)directionFlag caseSensitive:(BOOL)caseSensitiveFlag wrap:(BOOL)wrapFlag;
@end

@interface FindPanelWindowController : NSWindowController {
    id <SearchForDelegate> delegate;
}

@property (assign) IBOutlet NSTextField *message;
@property (assign) IBOutlet NSTextField *find;
@property (assign) IBOutlet NSTextField *replacewith;
@property (assign) IBOutlet NSButton *ignorecase;
@property (assign) IBOutlet NSButton *wraparound;
@property (retain) IBOutlet id delegate;

- (void)performFindPanelAction:(id)sender;
@end
#endif // End of FINDPANELWINDOWCONTROLLER_H_
