/**
 *  @file   WebViewwithJavascriptandPanels.h
 *  @brief  WebViewwithJavascriptandPanels Class Implementation (ObjC)
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/

#import "WebViewwithJavascriptandPanels.h"

@implementation WebViewwithJavascriptandPanels

@synthesize findpanelwindowcontroller;

- (void) awakeFromNib {
  
  self.UIDelegate = (id) self;

  [self.configuration.userContentController addScriptMessageHandler:self name:@"Blob"];

  self.navigationDelegate = self;

  self.findpanelwindowcontroller = [[FindPanelWindowController alloc] init];
  
  self.findpanelwindowcontroller.delegate = self;
}

- (IBAction)doFindPanelAction:(id)sender {
  
  [self.findpanelwindowcontroller performFindPanelAction:sender];
}

- (void) searchFor:(NSString *)string direction:(BOOL)directionFlag caseSensitive:(BOOL)caseSensitiveFlag wrap:(BOOL)wrapFlag{
  
  [self evaluateJavaScript:@"typeof SearchResults" completionHandler:^(NSString *result, NSError *error) {
    
    if ([result isEqualToString:@"undefined"]) {
      
      NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"js" inDirectory:@"js"];
      
      NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
      
      [self evaluateJavaScript:jsCode completionHandler:nil];
    }
    
    NSString *startSearch = [NSString stringWithFormat:@"HighlightAllOccurencesOfString('%@', %@, %@, %@)", string, directionFlag?@"true":@"false", caseSensitiveFlag?@"false":@"true", wrapFlag?@"true":@"false"];
    
    [self.findpanelwindowcontroller.message setStringValue:@"Searching ..."];
    
    [self evaluateJavaScript:startSearch completionHandler:^(NSString *result, NSError *error) {
      
      if (error == nil) {
        
        [self evaluateJavaScript:@"SearchResults.length" completionHandler:^(NSString *result, NSError *error) {
          if (error == nil && result != nil) {
  
            [self.findpanelwindowcontroller.message setStringValue:[NSString stringWithFormat:@"%@ results", result]];
          }
        }];
      }
    }];
  }];
}

- (void) webView:(WKWebView *)webView runOpenPanelWithParameters:(WKOpenPanelParameters *)parameters initiatedByFrame:(WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSArray<NSURL *> * _Nullable))completionHandler{
  
  NSOpenPanel * openDialog = [NSOpenPanel openPanel];
  [openDialog setCanChooseFiles:YES];
  [openDialog setCanChooseDirectories:NO];
  openDialog.allowsMultipleSelection = NO;
  
  [openDialog beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
    
    if (result == NSModalResponseOK) {
    
      completionHandler([openDialog URLs]);
    }
    else {
    
      completionHandler(nil);
    }
  }];  
}

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

  if ([navigationAction.request.URL.absoluteString containsString:@"blob"]) {

    NSString *js = [NSString stringWithFormat:@"\
                    var xhr = new XMLHttpRequest();\n\
                    xhr.open('GET', '%@');\n\
                    xhr.responseType = 'blob';\n\
                    xhr.onload = function(e) {\n\
                      if (this.status == 200) {\n\
                        var reader = new window.FileReader();\n\
                        reader.readAsDataURL(this.response);\n\
                        reader.onloadend = function() {\n\
                          window.webkit.messageHandlers.Blob.postMessage(reader.result);\n\
                        }\n\
                      }\n\
                    }\n\
                    xhr.send();\n", navigationAction.request.URL.absoluteString];

    [self evaluateJavaScript:js completionHandler:nil];

    decisionHandler(WKNavigationActionPolicyCancel);

    return;
  }
  
  decisionHandler(WKNavigationActionPolicyAllow);
}

-(void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

  if ([message.name isEqualToString:@"Blob"]) {
    
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    savePanel.canCreateDirectories = YES;
    savePanel.showsHiddenFiles = NO;
    savePanel.allowedFileTypes = @[@"com.adobe.pdf"];
    savePanel.allowsOtherFileTypes = NO;
    savePanel.nameFieldStringValue = @"AdB.pdf";

    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
      
      if (result == NSModalResponseOK) {

        NSRange range = [message.body rangeOfString:@"base64,"];

        NSData *body = [[NSData alloc] initWithBase64EncodedString:[NSString stringWithString:[message.body substringFromIndex:range.location+7]] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        if (body) {
          
          [body writeToURL:[savePanel URL] atomically:YES];
        }
      }
    }];
  }
}

- (void) webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
 
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = message;
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];

    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
        
        if (result == NSAlertFirstButtonReturn) {
        
          completionHandler(YES);
        }
        else {
        
          completionHandler(NO);
        }
    }];
}
@end
