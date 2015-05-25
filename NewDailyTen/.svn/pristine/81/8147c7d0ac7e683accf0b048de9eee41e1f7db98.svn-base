// UIImageView+AFNetworking.m
//
// Copyright (c) 2011 Gowalla (http://gowalla.com/)
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
#import <objc/runtime.h>
#import "LBCache.h"
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import "UIImageView+AFNetworking.h"
#import "FileUtil.h"

@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
- (void)clearCache;
@end

#pragma mark -

static char kAFImageRequestOperationObjectKey;

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
@end

@implementation UIImageView (_AFNetworking)
@dynamic af_imageRequestOperation;
@end

#pragma mark -

@implementation UIImageView (AFNetworking)

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });

    return _af_imageRequestOperationQueue;
}

+ (AFImageCache *)af_sharedImageCache {
    static AFImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[AFImageCache alloc] init];
        [_af_imageCache setCountLimit:20];
    });

    return _af_imageCache;
}

#pragma mark -

- (void)setImageWithURL:(NSURL *)url{
    
    NSLog(@"AAAAA %@", self.image);
    
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    //NSLog(@"BBBBB %@", self.image);
    self.image = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURL1:(NSURL *)url {
    
    NSLog(@"AAAAA %@", self.image);
    
    [self setImageWithURL1:url placeholderImage:nil];
}

- (void)setImageWithURL1:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    //NSLog(@"BBBBB %@", self.image);
    self.image = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest1:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest1:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    
    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        
    }
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];

    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }

        self.af_imageRequestOperation = nil;
    } else {
        if(placeholderImage != nil)
        self.image = placeholderImage;

    
        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (success) {
                    success(operation.request, operation.response, responseObject);
                } else if (responseObject) {
                    self.alpha = 0.4f;
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0f];
                    self.alpha = 1.0f;
                    self.image = responseObject;
                    [UIView commitAnimations];
                }

                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }
            }

            [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (failure) {
                    failure(operation.request, operation.response, error);
                }

                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }
            }
        }];

        self.af_imageRequestOperation = requestOperation;

        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}
/*
 - (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
 placeholderImage:(UIImage *)placeholderImage
 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
 {
 [self cancelImageRequestOperation];
 
 
 UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
 if (cachedImage) {
 
 self.image = cachedImage;
 self.af_imageRequestOperation = nil;
 
 if (success) {
 success(nil, nil, cachedImage);
 }
 } else {
 NSString *urlString = [[urlRequest URL] absoluteString];
 NSData *data = [self loadImageData:[self pathInCacheDirectory:@"WendaleCache"] imageName:[urlString md5Value]];
 if (data) {
 self.image = [UIImage imageWithData:data];
 self.af_imageRequestOperation = nil;
 
 if (success) {
 success(nil, nil, self.image);
 }
 return;
 }
 
 self.image = placeholderImage;
 
 AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
 [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
 if (success) {
 success(operation.request, operation.response, responseObject);
 }else if (responseObject) {
 self.image = responseObject;}
 //图片本地缓存
 if ([self createDirInCache:@"WendaleCache"]) {
 NSString *imageType = @"jpg";
 //从url中获取图片类型
 
 NSMutableArray *arr = (NSMutableArray *)[urlString componentsSeparatedByString:@"."];
 if (arr) {
 imageType = [arr objectAtIndex:arr.count-1];
 }
 [self saveImageToCacheDir:[self pathInCacheDirectory:@"WendaleCache"] image: responseObject imageName:[urlString md5Value] imageType:imageType];
 }
 
 
 self.af_imageRequestOperation = nil;
 }
 
 [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
 if (failure) {
 failure(operation.request, operation.response, error);
 }
 
 self.af_imageRequestOperation = nil;
 }
 }];
 
 self.af_imageRequestOperation = requestOperation;
 
 [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
 }
 }
 
 -(NSString* )pathInCacheDirectory:(NSString *)fileName
 {
 NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
 NSString *cachePath = [cachePaths objectAtIndex:0];
 return [cachePath stringByAppendingPathComponent:fileName];
 }
 
 //创建缓存文件夹
 -(BOOL) createDirInCache:(NSString *)dirName
 {
 NSString *imageDir = [self pathInCacheDirectory:dirName];
 BOOL isDir = NO;
 NSFileManager *fileManager = [NSFileManager defaultManager];
 BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
 BOOL isCreated = NO;
 if ( !(isDir == YES && existed == YES) )
 {
 isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
 }
 if (existed) {
 isCreated = YES;
 }
 return isCreated;
 }
 
 // 删除图片缓存
 - (BOOL) deleteDirInCache:(NSString *)dirName
 {
 NSString *imageDir = [self pathInCacheDirectory:dirName];
 BOOL isDir = NO;
 NSFileManager *fileManager = [NSFileManager defaultManager];
 BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
 bool isDeleted = false;
 if ( isDir == YES && existed == YES )
 {
 isDeleted = [fileManager removeItemAtPath:imageDir error:nil];
 }
 
 return isDeleted;
 }
 
 // 图片本地缓存
 - (BOOL) saveImageToCacheDir:(NSString *)directoryPath  image:(UIImage *)image imageName:(NSString *)imageName imageType:(NSString *)imageType
 {
 BOOL isDir = NO;
 NSFileManager *fileManager = [NSFileManager defaultManager];
 BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
 bool isSaved = false;
 if ( isDir == YES && existed == YES )
 {
 if ([[imageType lowercaseString] isEqualToString:@"png"])
 {
 isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
 }
 else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
 {
 isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
 }
 else
 {
 NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
 }
 }
 return isSaved;
 }
 // 获取缓存图片
 -(NSData*) loadImageData:(NSString *)directoryPath imageName:( NSString *)imageName
 {
 BOOL isDir = NO;
 NSFileManager *fileManager = [NSFileManager defaultManager];
 BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
 if ( isDir == YES && dirExisted == YES )
 {
 NSString *imagePath = [directoryPath stringByAppendingString : imageName];
 BOOL fileExisted = [fileManager fileExistsAtPath:imagePath];
 if (!fileExisted) {
 return NULL;
 }
 NSData *imageData = [NSData dataWithContentsOfFile : imagePath];
 return imageData;
 }
 else
 {
 return NULL;
 }
 }*/

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

+ (void)clearCache
{
    [[[self class] af_sharedImageCache] clearCache];
}
@end

#pragma mark -

static inline NSString * AFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    NSString * md5 = [AFImageCacheKeyFromURLRequest(request) md5Value];
    NSString * picPath = [[FileUtil getCachePicPath] stringByAppendingPathComponent:md5];
    UIImage * result = nil;
    
    result = [self objectForKey:picPath];
    if(result)
        return result;
    
    result = [[UIImage alloc] initWithContentsOfFile:picPath];
    if(result)
    {
        [self setObject:result forKey:picPath];
        return result;
    }
    else
        return nil;    
    //return [self objectForKey:AFImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request)
    {
        NSString * md5 = [AFImageCacheKeyFromURLRequest(request) md5Value];
        NSString * picPath = [[FileUtil getCachePicPath] stringByAppendingPathComponent:md5];
        
        NSString * extension = [request.URL pathExtension];
        NSData * data = nil;
        if([extension isEqualToString:@"png"])
            data = UIImagePNGRepresentation(image);
        else
            data = UIImageJPEGRepresentation(image, 1);
        [data writeToFile:picPath options:NSDataWritingAtomic error:nil];
        [self setObject:image forKey:picPath];
    }
}

- (void)clearCache
{
    [self removeAllObjects];
    [[NSFileManager defaultManager] removeItemAtPath:[FileUtil getCachePicPath] error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[FileUtil getCachePicPath] withIntermediateDirectories:YES attributes:nil error:nil];
}

@end

#endif
