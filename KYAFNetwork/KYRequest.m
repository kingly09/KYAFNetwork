//
//  KYRequest.m
//
// Copyright (c) 2016 KYAFNetwork  Software (https://github.com/kingly09/KYAFNetwork) by kingly inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "KYRequest.h"
#import <CommonCrypto/CommonDigest.h>
#if __has_include(<YYCache/YYCache.h>)
#import <YYCache/YYCache.h>
#else
#import "YYCache.h"
#endif

@interface KYRequest ()
@property (readwrite, nonatomic, strong) NSString *baseURL;
@property (readonly, nonatomic, strong)  KYRequestConfig *requestConfig;
@end


@implementation KYRequest

+ (instancetype) manager{
      return [[[self class] alloc] initWithBaseURL:nil];
}
- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(nullable NSString *)url{
    return [self initWithBaseURL:url requestConfig:nil];
}

- (instancetype)initWithBaseURL:(NSString *)url
           requestConfig:(KYRequestConfig *)configuration
{

    self = [super init];
    if (!self) {
        return nil;
    }

    self.baseURL = url;

    _requestConfig = configuration;

    return self;
}


@end


@interface KYCache : NSObject

/**
 根据请求的 URL与parameters 取出缓存数据

 @param URL        请求的URL
 @param parameters 请求的参数

 @return 缓存的服务器数据
 */
+ (id)httpRequestCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 缓存网络数据,根据请求的 URL与parameters,做KEY存储数据, 这样就能缓存多级页面的数据

 @param responseData 服务器返回的数据
 @param URL          请求的URL地址
 @param parameters   请求的参数
 */
+ (void)setResponseCache:(id)responseData URL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 获取网络缓存的总大小 bytes(字节)

 @return 返回网络缓存的总大小
 */
+ (NSInteger)getAllCacheSize;

/**
 *  删除所有网络缓存
 */
+ (void)removeAllCache;

@end

@interface NSString (md5)

+ (NSString *)KYNetwork_md5:(NSString *)string;

@end

@implementation NSString (md5)

+ (NSString *)KYNetwork_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];

    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }

    return [ms copy];
}

@end

static NSString *const KYNetworkResponseCache = @"KYNetworkResponseCache";
static YYCache *_dataCache;


@implementation KYCache

+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:KYNetworkResponseCache];
}

+ (id)httpRequestCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters{

    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}

+ (void)setResponseCache:(id)responseData URL:(NSString *)URL parameters:(NSDictionary *)parameters{

    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:responseData forKey:cacheKey withBlock:nil];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters
{
    if(!parameters){return URL;};
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    // 将URL与转换好的参数字符串拼接在一起,成为最终存储的KEY值
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString] ;
    return [NSString KYNetwork_md5:cacheKey];
}

+ (NSInteger)getAllCacheSize
{
    return [_dataCache.diskCache totalCost];
}

+ (void)removeAllCache
{
    [_dataCache.diskCache removeAllObjects];
}

@end
