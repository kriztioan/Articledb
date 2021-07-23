/**
 *  @file   WebViewwithJavascriptandPanels.h
 *  @brief  WebViewwithJavascriptandPanels Class Definition (ObjC)
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/

#ifndef WEBVIEWWITHJAVASCRIPTANDPANELS_H_
#define WEBVIEWWITHJAVASCRIPTANDPANELS_H_

#import <WebKit/WebKit.h>
#import "FindPanelWindowController.h"


@interface WebViewwithJavascriptandPanels : WKWebView <WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, retain) FindPanelWindowController *findpanelwindowcontroller;
@end
#endif // End of WEBVIEWWITHJAVASCRIPTANDPANELS_H_
