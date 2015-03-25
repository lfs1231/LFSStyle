//
//  ViewController.m
//  Recipe 8.1: Taking Pictures
//
//  Created by Hans-Eric Grönlund on 7/18/12.
//  Copyright (c) 2012 Hans-Eric Grönlund. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;
@synthesize cameraButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)takePicture:(id)sender
{
    [self startMediaBrowserFromViewController: self usingDelegate: self];
    
	// Make sure camera is available
//    if ([UIImagePickerController
//         isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:@"Camera Unavailable"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel" 
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    if (self.imagePicker == nil)
//    {
//        self.imagePicker = [[UIImagePickerController alloc] init];
//        
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        self.imagePicker.allowsEditing = YES;
//       // self.imagePicker.showsCameraControls = NO;
//        
//    }
//    
//   self.imagePicker.delegate = self;
//  
//   
//     [self performSelector:@selector(takePicture) withObject:self afterDelay:1.0];
//    [self presentModalViewController:self.imagePicker animated:YES completion:^{
//        self.imagePicker.delegate = self;
//        NSLog(@"_imagePicker.delegate1 = %@",self.imagePicker.delegate);
//        [self imagePickerController:self.imagePicker  didFinishPickingMediaWithInfo:<#(NSDictionary *)#>]
//    }];
  
}



- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,kUTTypeImage, nil];
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = self;
    self.imagePicker=mediaUI;
    
 //
    
    [self presentViewController:mediaUI animated:YES completion:^{
      //  mediaUI.delegate = self;
  
        //self.imagePicker.delegate.delegate=self;
        NSLog(@"_imagePicker.deleg2ate1 = %@",self.imagePicker.delegate);
         NSLog(@"_imagePicker.deleg2ate12 = %@",self.imagePicker.viewControllers);
            NSLog(@"_imagePicker.deleg2ate13 = %@",self.imagePicker.parentViewController);
    }];
   
    return YES;
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"=====1==imagePickerController==");
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil);
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    NSLog(@"=====222222==imagePickerController==");
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
       NSLog(@"=====33333==cancel==");
    [self dismissViewControllerAnimated:YES completion:NULL];
}


// 打印信息，仅做演示
- (void)printALAssetInfo:(ALAsset*)asset
{
    //取图片的url
    NSString *photoURL=[NSString stringWithFormat:@"%@",asset.defaultRepresentation.url];
    NSLog(@"photoURL:%@", photoURL);
    // 取图片
    UIImage* photo = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    NSLog(@"PHOTO:%@", photo);
    NSLog(@"photoSize:%@", NSStringFromCGSize(photo.size));
    // 取图片缩图图
    UIImage* photoThumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    NSLog(@"PHOTO2:%@", photoThumbnail);
    NSLog(@"photoSize2:%@", NSStringFromCGSize(photoThumbnail.size));
}

-(void)loadImageFromPhotoLibrary
{
    // 为了防止界面卡住，可以异步执行
    dispatch_async(dispatch_get_main_queue(), ^{
        // 获取相册每个组里的具体照片
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=nil) {
                // 检查是否是照片，还可能是视频或其它的
                // 所以这里我们还能类举出枚举视频的方法。。。
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [self printALAssetInfo:result];
                }
            }
        };
        //获取相册的组
        ALAssetsLibraryGroupsEnumerationResultsBlock groupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (group!=nil) {
                NSString *groupInfo=[NSString stringWithFormat:@"%@",group];
                NSLog(@"GROUP INFO:%@",groupInfo);
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
            // 相册访问失败的回调，可以打印一下失败原因
            NSLog(@"相册访问失败，ERROR:%@", [error localizedDescription]);
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:groupsEnumeration
                             failureBlock:failureblock];
       
    });
    
}

// 同上面的原理，我们再做一个根据URL取图片及缩略图的方法
- (void)loadImageForURL:(NSURL*)photoUrl
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:photoUrl
                  resultBlock:^(ALAsset *asset)
     {
         [self printALAssetInfo:asset];
     }
                 failureBlock:^(NSError *error)
     {
         NSLog(@"error=%@",error);
     }];
}

@end
