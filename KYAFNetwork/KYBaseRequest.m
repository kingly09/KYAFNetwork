//
//  KYBaseRequest.m
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

#import "KYBaseRequest.h"
#import "KYAFNetwork.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

static BOOL _isNetwork;

@interface KYBaseRequest ()

@end

@implementation KYBaseRequest


- (KYRequestMethod)requestMethod{
    return KYRequestMethodGET;
}

- (KYRequestSerializerType)requestSerializerType{
    return KYRequestSerializerTypeHTTP;
}

- (KYResponseSerializerType)responseSerializerType{
    return KYResponseSerializerTypeHTTP;
}

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(KYHttpNetworkStatus )networkStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status)
            {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(KYNetworkStatusUnknown) : nil;
                    _isNetwork = NO;
                    KYLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(KYNetworkStatusNotReachable) : nil;
                    _isNetwork = NO;
                    KYLog(@"无网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(KYNetworkStatusReachableViaWWAN) : nil;
                    _isNetwork = YES;
                    KYLog(@"2G,3G,4G 等其它网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(KYNetworkStatusReachableViaWiFi) : nil;
                    _isNetwork = YES;
                    KYLog(@"WIFI");
                    break;
            }
        }];

        [manager startMonitoring];
    });
}

+ (BOOL)currentNetworkStatus{
    return _isNetwork;
}



@end
