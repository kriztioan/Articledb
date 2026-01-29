/**
 *  @file   ArticledbAppDelegate.mm
 *  @brief  ArticledbAppDelegate Class Implementation (ObjC++)
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/

#import "ArticledbAppDelegate.h"
#include "config.h"

@implementation ArticledbAppDelegate

@synthesize window;
@synthesize view;
@synthesize serverPort;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

  if (![[NSUserDefaults standardUserDefaults] stringForKey:@"port"]) {

    [[NSUserDefaults standardUserDefaults] setObject:@"7878" forKey:@"port"];
  }

  [self.serverPort setStringValue:[[NSUserDefaults standardUserDefaults]
                                      stringForKey:@"port"]];

  NSString *path = [[NSBundle mainBundle] pathForResource:@"AdB"
                                                   ofType:@"cfg"
                                              inDirectory:@"web"];

  if (path) {

    std::string config;

    loadConfig([path UTF8String], config);

    NSString *baseurl =
        [NSString stringWithFormat:@"http://localhost:%@/",
                                   [self.serverPort stringValue]];

    if (![baseurl isEqualToString:@(getvalue("baseurl", config).c_str())]) {

      writeConfigFile([path UTF8String],
                      setvalue("baseurl", [baseurl UTF8String], config),
                      config);
    }
  }

  [self startServer];
}

- (void)startServer {

  /*
   static const char *config_options[] = {
   "C", "cgi_pattern", "**.cgi$|**.pl$|**.php$",
   "E", "cgi_environment", NULL,
   "G", "put_delete_passwords_file", NULL,
   "I", "cgi_interpreter", NULL,
   "M", "max_request_size", "16384",
   "P", "protect_uri", NULL,
   "R", "authentication_domain", "mydomain.com",
   "S", "ssi_pattern", "**.shtml$|**.shtm$",
   "a", "access_log_file", NULL,
   "c", "ssl_chain_file", NULL,
   "d", "enable_directory_listing", "yes",
   "e", "error_log_file", NULL,
   "g", "global_passwords_file", NULL,
   "i", "index_files", "index.html,index.htm,index.cgi,index.shtml,index.php",
   "k", "enable_keep_alive", "no",
   "l", "access_control_list", NULL,
   "m", "extra_mime_types", NULL,
   "p", "listening_ports", "8080",
   "r", "document_root",  ".",
   "s", "ssl_certificate", NULL,
   "t", "num_threads", "10",
   "u", "run_as_user", NULL,
   "w", "url_rewrite_patterns", NULL,
   "x", "hide_files_patterns", NULL,
   NULL
   }; */

  const char *options[] = {
      "document_root",
      [[[NSBundle mainBundle] pathForResource:@"web" ofType:nil] UTF8String],
      "cgi_pattern",
      "**.cgi$",
      "index_files",
      "index.cgi",
      "enable_directory_listing",
      "no",
      "listening_ports",
      [[[NSUserDefaults standardUserDefaults] stringForKey:@"port"] UTF8String],
      "error_log_file",
      [[[NSBundle mainBundle] pathForResource:@"error"
                                       ofType:@"log"
                                  inDirectory:@"web"] UTF8String],
      "static_file_max_age",
      "0",
      "enable_keep_alive",
      "yes",
      "keep_alive_timeout_ms",
      "500",
      NULL};

  ctx = mg_start(NULL, NULL, options);

  if (ctx == NULL) {

    exit(1);
  }

  [view loadRequest:[NSURLRequest
                        requestWithURL:
                            [NSURL
                                URLWithString:[NSString
                                                  stringWithFormat:
                                                      @"http://localhost:%@/%@",
                                                      [[NSUserDefaults
                                                          standardUserDefaults]
                                                          stringForKey:@"port"],
                                                      @"index.cgi"]]]];
}

- (void)stopServer {

  mg_stop(ctx);
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:
    (NSApplication *)theApplication {
  return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {

  [self stopServer];
}

- (IBAction)restart:(id)sender {

  [self stopServer];

  [[NSUserDefaults standardUserDefaults] setObject:[self.serverPort stringValue]
                                            forKey:@"port"];

  NSString *path = [[NSBundle mainBundle] pathForResource:@"AdB"
                                                   ofType:@"cfg"
                                              inDirectory:@"web"];

  if (path) {

    std::string config;

    loadConfig([path UTF8String], config);

    NSString *baseurl =
        [NSString stringWithFormat:@"http://localhost:%@/",
                                   [self.serverPort stringValue]];

    if (![baseurl isEqualToString:@(getvalue("baseurl", config).c_str())]) {

      writeConfigFile([path UTF8String],
                      setvalue("baseurl", [baseurl UTF8String], config),
                      config);
    }
  }

  [self startServer];

  NSButton *button = (NSButton *)sender;

  [button.window performClose:self];
}

- (IBAction)home:(id)sender {

  [view loadRequest:[NSURLRequest
                        requestWithURL:
                            [NSURL
                                URLWithString:[NSString
                                                  stringWithFormat:
                                                      @"http://localhost:%@/%@",
                                                      [[NSUserDefaults
                                                          standardUserDefaults]
                                                          stringForKey:@"port"],
                                                      @"index.cgi"]]]];
}

@end
