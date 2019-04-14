/*
 File: LargeImageDownsizingViewController.m
 Abstract: The primary view controller for this project.
 Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "LargeImageDownsizingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageScrollView.h"
#import "TCPhotoModel.h"
#import "TCPhotoUrlModel.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFImageDownloader.h>


/* Image Constants: for images, we define the resulting image
 size and tile size in megabytes. This translates to an amount
 of pixels. Keep in mind this is almost always significantly different
 from the size of a file on disk for compressed formats such as png, or jpeg.
 
 For an image to be displayed in iOS, it must first be uncompressed (decoded) from
 disk. The approximate region of pixel data that is decoded from disk is defined by both,
 the clipping rect set onto the current graphics context, and the content/image
 offset relative to the current context.
 
 To get the uncompressed file size of an image, use: Width x Height / pixelsPerMB, where
 pixelsPerMB = 262144 pixels in a 32bit colospace (which iOS is optimized for).
 
 Supported formats are: PNG, TIFF, JPEG. Unsupported formats: GIF, BMP, interlaced images.
 */
#define kImageFilename @"large_leaves_70mp.jpg" // 7033x10110 image, 271 MB uncompressed

/* The arguments to the downsizing routine are the resulting image size, and
 "tile" size. And they are defined in terms of megabytes to simplify the correlation
 between images and memory footprint available to your application.
 
 The "tile" is the maximum amount of pixel data to load from the input image into
 memory at one time. The size of the tile defines the number of iterations
 required to piece together the resulting image.
 
 Choose a resulting size for your image given both: the hardware profile of your
 target devices, and the amount of memory taken by the rest of your application.
 
 Maximizing the source image tile size will minimize the time required to complete
 the downsize routine. Thus, performance must be balanced with resulting image quality.
 
 Choosing appropriate resulting image size and tile size can be done, but is left as
 an exercise to the developer. Note that the device type/version string
 (e.g. "iPhone2,1" can be determined at runtime through use of the sysctlbyname function:
 
 size_t size;
 sysctlbyname("hw.machine", NULL, &size, NULL, 0);
 char *machine = malloc(size);
 sysctlbyname("hw.machine", machine, &size, NULL, 0);
 NSString* _platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
 free(machine);
 
 
 These constants are suggested initial values for iPad1, and iPhone 3GS */

#   define kDestImageSizeMB 20.0f // The resulting image will be (x)MB of uncompressed image data.
#   define kSourceImageTileSizeMB 5.0f // The tile size will be (x)MB of uncompressed image data.
/* These constants are suggested initial values for iPad2, and iPhone 4 */


/* These constants are suggested initial values for iPhone3G, iPod2 and earlier devices */
//#define IPHONE3G_IPOD2_AND_EARLIER


/* Constants for all other iOS devices are left to be defined by the developer.
 The purpose of this sample is to illustrate that device specific constants can
 and should be created by you the developer, versus iterating a complete list. */

#define bytesPerMB 1048576.0f
#define bytesPerPixel 4.0f
#define pixelsPerMB ( bytesPerMB / bytesPerPixel ) // 262144 pixels, for 4 bytes per pixel.
#define destTotalPixels kDestImageSizeMB * pixelsPerMB
#define tileTotalPixels kSourceImageTileSizeMB * pixelsPerMB
#define destSeemOverlap 2.0f // the numbers of pixels to overlap the seems where tiles meet.

@interface LargeImageDownsizingViewController ()<ImageScrollViewDelegate>
/// 文件路径
@property (nonatomic, strong) NSURL *filePath;
@end

@implementation LargeImageDownsizingViewController

@synthesize destImage;



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
/*
 -(void)loadView {
 
 }*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //--

    [self prepareUI];
    [self downloadImageWithSDWeb];
}




- (void)prepareUI {
    progressView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:progressView];
    progressView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.thumbImage) {
        progressView.image = self.thumbImage;
    }else {
        [progressView sd_setImageWithURL:[NSURL URLWithString:self.model.urls.small]];}
    progressView.userInteractionEnabled = YES;
    [progressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageScrollViewNeedCloseVCWithView:)]];
    
    [MBProgressHUD showActivityIndicatorTo:self.view];
}
- (void)setModel:(TCPhotoModel *)model {
    _model = model;
}

/// 开始展示图片
- (void)showImage:(UIImage *)image {
    if (image == nil) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_model.urls.raw]]];
    }
    
    image = [self fixOrientation:image];
    TCdispatch_main_async_safe(^{
        [self initializeScrollView:image];
    });
    
    

}


-(void)initializeScrollView:(UIImage *)arg {
    

   scrollView = [[ImageScrollView alloc] initWithFrame:self.view.bounds image:arg];
    [self.view addSubview:scrollView];
    scrollView.closeDelegate = self;
    [progressView removeFromSuperview];
    progressView = nil;
}
#pragma mark - 私有方法
- (void)downloadImageWithAFN {
    
}

/// 使用SDWebImage下载图片
- (void)downloadImageWithSDWeb {
    
        [[SDImageCache sharedImageCache].config setShouldDecompressImages:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.model.urls.raw]]];
        if (image) {
            
            [self showImage:[UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDown]];
        }else {
            
                [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:YES];
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.model.urls.raw] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (finished) {
                        [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.model.urls.raw]]];
//                        TCdispatch_main_async_safe(^{
                            [self showImage:[UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDown]];
//                        });
                    }
                }];
            
        }
        });
}


#pragma mark - 图片界面代理
- (void)ImageScrollViewNeedCloseVCWithView:(ImageScrollView *)view {
    [self dismissViewControllerAnimated:NO completion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
                [[SDImageCache sharedImageCache] removeImageForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.model.urls.raw]] fromDisk:NO withCompletion:nil];
        });

    }];
}

- (void)dealloc {
    NSLog(@"页面销毁：%s",__func__);
}


/// 旋转图片
- (UIImage *)fixOrientation:(UIImage *)aImage {
    if(aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform,0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
        break;
    }
    switch(aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
        transform = CGAffineTransformScale(transform, -1,1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
        transform = CGAffineTransformScale(transform, -1,1);
            break;
        default:
        break;
            
        }

    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
    CGImageGetBitsPerComponent(aImage.CGImage),0,
    CGImageGetColorSpace(aImage.CGImage),
    CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch(aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:

            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
        break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
        break;
            
    }

    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;}


@end
