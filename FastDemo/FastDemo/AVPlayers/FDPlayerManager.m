//
//  FDPlayerManager.m
//  FastDemo
//
//  Created by Jason on 2019/1/16.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDPlayerManager.h"
#import "FDAVPlayerController.h"
#import "FDAVPlayerController.h"
#import "KxMovieViewController.h"

@interface FDPlayerManager ()

@end

@implementation FDPlayerManager

+ (void)showPlayerChooser:(UIViewController *)targer url:(NSString *)url {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Player" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"AVPlayer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        FDAVPlayerController *player = [FDAVPlayerController new];
        player.url = url;
        [targer presentViewController:player animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"FFmpeg" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
        KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:url parameters:parameters];
        [targer presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [targer presentViewController:alert animated:YES completion:nil];
}

@end
