/**
 *  @file   ArticledbAppDelegate.h
 *  @brief  ArticledbAppDelegate Class Definition (ObjC++)
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/

#ifndef ARTICLEDBAPPDELEGATE_H_
#define ARTICLEDBAPPDELEGATE_H_

#import <Cocoa/Cocoa.h>

#import "WebViewwithJavascriptandPanels.h"
#import "civetweb.h"

struct mg_context *ctx;

@interface ArticledbAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, assign) IBOutlet WebViewwithJavascriptandPanels *view;
@property (nonatomic, assign) IBOutlet NSTextField *serverPort;
@end
#endif // End of ARTICLEDBAPPDELEGATE_H_
