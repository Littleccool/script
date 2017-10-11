#!/usr/bin/perl

sub readGetData{ 
    # 指定局部变量queryString用以保存和传递函数的参数 
    local(*queryString) = @_ if @_; 
    # 读取环境变量QUERY_STRING的值赋给变量$queryString 
    $queryString = $ENV{"QUERY_STRING"}; 
    return 1;
}

sub readPostData{ 
    local(*queryString)=@_ if @_; 
    local($contentLength); 
    # 读取环境变量CONTENT_LENGTH的值 
    $contentLength = $ENV{"CONTENT_LENGTH"}; 
    # 检查是否有数据 
    if($contentLength){ 
        # 从设备STDIN读取contentLength长度的字符赋给$queryString 
        read(STDIN,$queryString,$contentLength); 
    } 
    return 1; 
} 

sub readData{ 
    local(*queryString) = @_ if @_; 
    # 读取环境变量REQUEST_METHOD 
    $requestType=$ENV{"REQUEST_METHOD"}; 

    # 如果请求方式为GET则使用函数readGetData 
    # 否则如果请求方式为POST则使用函数readPostData 
    if($requestType eq "GET"){ 
        &readGetData(*queryString); 
    } 
    elsif($requestType eq "POST"){ 
        &readPostData(*queryString); 
    } 
    return 1; 
} 

sub DecodeData{ 
    local(*queryString)= @_; 
    # 把加号转换成空格 
    $queryString=~s/\+/ /g; 
    # 转换十六进制字符 
    $queryString=~s/%(..)/pack("c",hex($1))/ge; 
    return 1; 
} 

sub parseData{ 
    local(*queryString,*formData) = @_ if @_; 
    local($key,$value,$curString,@tmpArray); 

    # 以&为分隔符把字符串转换成键-值对 
    @tmpArray = split(/&/,$queryString); 

    # 在数组@tmpArray内循环 
    foreach $curString(@tmpArray){ 
        # 以=为分隔符分开键-值对 
        ($key,$value) = split(/=/,$curString); 
        # 解码 
        &DecodeData(*key); 
        &DecodeData(*value); 
        # 把键和值加到字典中 
        $formData{$key}=$value; 
    } 
    return 1; 
} 

1;
#end of file cgilib.pl

