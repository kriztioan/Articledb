/**
 *  @file   config.cpp
 *  @brief  Configuration Implementation
 *  @author KrizTioaN (christiaanboersma@hotmail.com)
 *  @date   2021-07-22
 *  @note   BSD-3 licensed
 *
 ***********************************************/

#include "config.h"

ERROR_CODE loadConfig(const char *filename, std::string &config){
    
    config = "";
	
    FILE *file = NULL;
    if((file = std::fopen(filename, "r")) == NULL)
        return(CONFIG_READ);
    
    int fd = fileno(file);
    
    flock(fd, LOCK_SH);
  
    bool parentheses = false;
    
    char character;
    while((character = getc(file)) != EOF)
    {
        if(character == '#')
        {
            while((character = getc(file)) != EOF)
            {
                if(character == '\n')
                    break;
            }
        }
        else if(character == '$')
        {
            if(!config.empty())
                config += '&';
            while((character = getc(file)) != EOF)
            {
                if(character == '\n')
                    break;
                if(character == '\"')
                {
                    parentheses = !parentheses;
                    continue;
                }
                if(character == '\\')
                {
                    while((character = getc(file)) != EOF)
                        if(character == '\n')
                            break;
                }
                else if(character != ' ' || (character == ' ' && parentheses == true))
                    config += character;
            }
        }
    }
    
    flock(fd, LOCK_UN);
  
    fclose(file);
    
    return(OK);
}

ERROR_CODE writeConfigFile(const char *filename, std::string config, std::string oldconfig){
    
    config = decodeURL(config);
	
    // If password change then encrypt
    std::string  password = getvalue("password", config);
    if(password.length() > 0) {
      const char alphanum[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      uint32_t upperbound = (uint32_t) strlen(alphanum);
      char salt[3];
      for(unsigned int i = 0; i < 2; i++)
        salt[i] = alphanum[arc4random_uniform(upperbound)];
      salt[2] = '\0';
      config = setvalue("password", crypt(password.c_str(), salt), config);
    }
    else
        config = setvalue("password", getvalue("password", oldconfig).c_str(), config);
    
    FILE *file = NULL;
    
    if((file = std::fopen(filename, "w")) == NULL)
        return(CONFIG_WRITE);
    
    int fd = fileno(file);
    
    flock(fd, LOCK_EX);
 	
    config = delkey("confirmpassword", config);
	
    fprintf(file, "#\n"
                  "# Automatic generated configuration file for AdB\n"
                  "#\n"
                  "# valid variables are $save, $base $data, $bibtex $msword $abbreviaton $plugins $baseurl, $administrator, $splash, $scheme, $username, $password and $expire\n"
                  "#\n\n");

    size_t pos = 0, configLen = config.length();
    while(pos < configLen)
    {
        putc('$', file);
        while(config.at(pos) != '=')
            putc(config.at(pos++), file);
        fprintf(file, " %c \"", config.at(pos++));
        while(pos < configLen)
        {
            if(config.at(pos) == '&')
            {
                ++pos;
                break;
            }
            putc(config.at(pos++), file);
        }
        fprintf(file, "\"\n");
    }
    
    flock(fd, LOCK_UN);
    
    fclose(file);
	
    return(OK);
}

std::string getvalue(const char* key, const std::string str){
    
    size_t len = str.length();
	
    char *content = (char *) malloc(sizeof(char) * (len + 1));
    content = strcpy(content, str.c_str());
	
    char *match, *value;
	
    std::string valueStr = "";
    for(int i = 0; i < len; i++){
		
        match = content + i;
        while(content[i] != '=' && content[i] != '\0')
            i++;
        content[i] = '\0';
		
        if(strcmp(key, match) == 0){
            value = content + ++i;
			
            while(content[i] != '&' && content[i] != '\0')
                i++;
            content[i] = '\0';
			
            valueStr = value;
            break;
			
        }
        else{
            while(content[++i] != '&' && content[i] != '\0');
        }
    }
    free(content);
	
    return(valueStr);
}

std::string setvalue(const char *key, const char *value, const std::string str){
	
    size_t len = str.length();
	
    char *content = (char *) malloc(sizeof(char) * (len + 1));
    content = strcpy(content, str.c_str());
	
    char *match;
	
    std::string update;
    for(int i = 0; i < len; i++){
		
        match = content + i;
        while(content[i] != '=' && content[i] != '\0')
            ++i;
        content[i] = '\0';
		
        if(strcmp(key, match) == 0){
			
            update  = str.substr(0,++i);
            update += value;
			
            while(content[i] != '&' && content[i] != '\0')
                i++;
			
            update += str.substr(i);
			
            free(content);
			
            return(update);
        }
        else{
            while(content[++i] != '&' && content[i] != '\0');
        }
    }
    free(content);
	
	
    if(len > 0)
        update += std::string("&") + key + "=" + value;
    else
        update += std::string(key) + "=" + value;
	
    return(update);
}

std::string delkey(const char *key, const std::string str){
	
    size_t len = str.length();
	
    char *content = (char *) malloc(sizeof(char) * (len + 1));
    content = strcpy(content, str.c_str());
	
    char *match;
	
    std::string update;
    for(int i = 0, j; i < len; i++){
		
        j = i;
		
        match = content + i;
        while(content[i] != '=' && content[i] != '\0')
            ++i;
        content[i] = '\0';
		
        if(strcmp(key, match) == 0){
			
            do ++i; while(content[i] != '&' && content[i] != '\0');
			
            if(content[i] == '&')
                ++i;
			
            update  = str.substr(0,j);
            update += str.substr(i);
			
            free(content);
			
            return(update);
        }
        else{
            while(content[++i] != '&' && content[i] != '\0');
        }
    }
    free(content);
	
    return(str);
}

std::string decodeURL(const std::string URLencoded){
	
    char code;
	
    std::string URLdecoded(URLencoded);
    for(std::string::size_type idx = 0; idx < URLdecoded.length(); idx++)
    {
        if(URLdecoded.at(idx) == '+')
            URLdecoded.replace(idx, 1, " ");
        else if(URLdecoded.at(idx) == '%'){
            code = static_cast<char>(strtol((URLdecoded.substr(idx + 1, 2)).c_str(), NULL, 16));
            URLdecoded.replace(idx, 3, &code, 1);
        }
    }
	
    return(URLdecoded);
}
