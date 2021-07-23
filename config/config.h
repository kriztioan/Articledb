/**
 *  @file   config.h
 *  @brief  Configuration Implementation
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/

#ifndef CONFIG_H_
#define CONFIG_H_

#include <string>
#include <fstream>
#include <iomanip>

#include <sys/file.h>

#include <unistd.h>

#define CRYPT  "A9"

#define OK           (1L<<0)

#define CONFIG_READ  (1L<<2)
#define CONFIG_WRITE (1L<<3)

typedef long ERROR_CODE;

ERROR_CODE loadConfig(const char *filename, std::string &config);
ERROR_CODE writeConfigFile(const char *filename, std::string config, std::string oldconfig);

std::string getvalue(const char *key, const std::string str);

std::string setvalue(const char *key, const char *value, const std::string str);

std::string delkey(const char *key, const std::string str);

std::string decodeURL(const std::string URLencoded);

#endif // End of CONFIG_H_
