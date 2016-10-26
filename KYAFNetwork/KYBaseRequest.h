//
//  KYBaseRequest.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN
///  HTTP Request method.
typedef NS_ENUM(NSInteger, KYRequestMethod) {
    KYRequestMethodGET = 0,
    KYRequestMethodPOST,
    KYRequestMethodHEAD,
    KYRequestMethodPUT,
    KYRequestMethodDELETE,
    KYRequestMethodPATCH,
};

///  Request serializer type.
typedef NS_ENUM(NSInteger, KYRequestSerializerType) {
    KYRequestSerializerTypeHTTP = 0,  //设置请求数据为二进制格式
    KYRequestSerializerTypeJSON,      //设置请求数据为JSON格式
};

///  Response serializer type
typedef NS_ENUM(NSUInteger, KYResponseSerializerType) {
    KYResponseSerializerTypeHTTP,   //设置响应数据为二进制格
    KYResponseSerializerTypeJSON,   //设置响应数据为JSON格式
};


typedef NS_ENUM(NSUInteger, KYNetworkStatus) {
    KYNetworkStatusUnknown,             //未知网络
    KYNetworkStatusNotReachable,        //无网络
    KYNetworkStatusReachableViaWWAN,    //手机网络
    KYNetworkStatusReachableViaWiFi     //WIFI网络
};

typedef void(^KYHttpRequestSuccess)(id responseObject);     // 请求成功的Block
typedef void(^KYHttpRequestFailed)(NSError *error);         // 请求失败的Block

typedef void(^KYHttpNetworkStatus)(KYNetworkStatus status); //网络状态的Block

typedef void(^KYHttpRequestCache)(id responseCache);         //缓存的Block

typedef void (^KYHttpProgress)(NSProgress *progress);        //上传或者下载的进度


@interface KYBaseRequest : NSObject

///  HTTP request method.
- (KYRequestMethod)requestMethod;

///  Request serializer type.
- (KYRequestSerializerType)requestSerializerType;

///  Response serializer type. See also `responseObject`.
- (KYResponseSerializerType)responseSerializerType;


@end

NS_ASSUME_NONNULL_END
