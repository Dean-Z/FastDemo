//
//  FFmpegCmdManager.m
//  FastDemo
//
//  Created by Jason on 2019/1/10.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FFmpegCmdManager.h"
#import "ffmpeg.h"

@implementation FFmpegCmdManager

//裁剪视频函数, 命令行如下:
//ffmpeg -i input.mp4 -ss **START_TIME** -t **STOP_TIME** -acodec copy -vcodec copy output.mp4
- (void)cutInputVideoPath:(char*)inputPath
          outPutVideoPath:(char*)outputPath
                startTime:(char*)startTime
                 duration:(char*)duration {
    
    int argc = 12;
    char **arguments = calloc(argc, sizeof(char*));
    if(arguments != NULL) {
        arguments[0] = "ffmpeg";
        arguments[1] = "-ss";
        arguments[2] = startTime;
        arguments[3] = "-t";
        arguments[4] = duration;
        arguments[5] = "-i";
        arguments[6] = inputPath;
        arguments[7] = "-acodec";
        arguments[8] = "copy";
        arguments[9] = "-vcodec";
        arguments[10]= "copy";
        arguments[11]= outputPath;
        
        ffmpeg_main(argc, arguments);
    }
}

//裁剪音频频函数, 命令行如下:
//ffmpeg -i input.mp4 -ss **START_TIME** -t **STOP_TIME** -acodec copy -acodec copy output.aac
- (void)cutInputAudioPath:(char*)inputPath
          outputAudioPath:(char*)outputPath
                startTime:(char*)startTime
                 duration:(char*)duration {
    
    int argc = 12;
    char **arguments = calloc(argc, sizeof(char*));
    if(arguments != NULL) {
        arguments[0] = "ffmpeg";
        arguments[1] = "-ss";
        arguments[2] = startTime;
        arguments[3] = "-t";
        arguments[4] = duration;
        arguments[5] = "-i";
        arguments[6] = inputPath;
        arguments[7] = "-acodec";
        arguments[8] = "copy";
        arguments[9] = "-acodec";
        arguments[10]= "copy";
        arguments[11]= outputPath;
        
        ffmpeg_main(argc, arguments);
    }
}

// 合并视频函数
// ffmpeg -f concat -i *** -acodec copy -vcodec copy output.mpg
- (void)concatInputFilePath:(NSString *)inputFilePath
             outPutVideoPath:(char*)outputPath {
    int argc = 10;
    char **arguments = calloc(argc, sizeof(char*));
    if (arguments != NULL) {
        arguments[0] = "ffmpeg";
        arguments[1] = "-f";
        arguments[2] = "concat";
        arguments[3] = "-i";
        arguments[4] = (char *)[inputFilePath UTF8String];
        arguments[5] = "-acodec";
        arguments[6] = "copy";
        arguments[7] = "-vcodec";
        arguments[8] = "copy";
        arguments[9] = outputPath;
        
        ffmpeg_main(argc, arguments);
    }
}

// 合并音视频
// ffmpeg -i *** -i *** out.mp4
- (void)concatVideoPath:(char*)videoPath
              audioPath:(char*)audioPath
        outPutVideoPath:(char*)outputPath {
    int argc = 6;
    char **arguments = calloc(argc, sizeof(char*));
    if (arguments != NULL) {
        arguments[0] = "ffmpeg";
        arguments[1] = "-i";
        arguments[2] = videoPath;
        arguments[3] = "-i";
        arguments[4] = audioPath;
        arguments[5] = outputPath;
        
        ffmpeg_main(argc, arguments);
    }
}

- (void)concatImages:(char *)imagesPath
                rate:(char *)rate
             toVideo:(char *)videoPath {
    int argc = 9;
    char **arguments = calloc(argc, sizeof(char*));
    if (arguments != NULL) {
        arguments[0] = "ffmpeg";
        arguments[1] = "-y";
        arguments[2] = "-r";
        arguments[3] = rate;
        arguments[4] = "-i";
        arguments[5] = imagesPath;
        arguments[6] = "-f";
        arguments[7] = "mp4";
        arguments[8] = videoPath;
        
        ffmpeg_main(argc, arguments);
    }
}

@end
