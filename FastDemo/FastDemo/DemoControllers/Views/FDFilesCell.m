//
//  FDFilesCell.m
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDFilesCell.h"
#import "FDKit.h"

@interface FDFilesCell()

@property (nonatomic, strong) UILabel *fileName;
@property (nonatomic, strong) UILabel *fileCreateDate;
@property (nonatomic, strong) UILabel *fileSize;

@end

@implementation FDFilesCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.fileName];
    [self.contentView addSubview:self.fileCreateDate];
    [self.contentView addSubview:self.fileSize];
    [self.fileName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(@(15));
        make.width.lessThanOrEqualTo(@(WindowSizeW - 100));
    }];
    [self.fileCreateDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(self.fileName.mas_bottom).offset(5);
    }];
    [self.fileSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)renderWithFileName:(NSString *)name {
    self.fileName.text = name;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",self.dirPath,name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    if (fileAttributes != nil) {
        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        if (isDir) {
            self.fileSize.text = @"";
        } else {
            NSNumber *fileSize =  [fileAttributes objectForKey:NSFileSize];
            if (fileSize.integerValue > 0) {
                if (fileSize.intValue > 1024 * 1024) {
                    self.fileSize.text = [NSString stringWithFormat:@"%.2fMB",fileSize.intValue/(1024 * 1024.f)];
                } else if(fileSize.integerValue > 1024) {
                    self.fileSize.text = [NSString stringWithFormat:@"%dKB",fileSize.intValue/(1024)];
                } else {
                    self.fileSize.text = [NSString stringWithFormat:@"%dB",fileSize.intValue];
                }
            }
        }
           
        if (fileModDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            self.fileCreateDate.text = [formatter stringFromDate:fileModDate];
        }
    }
}

- (void)plistCellRenderWithName:(NSString *)name artist:(NSString *)artist; {
    self.fileName.text = name;
    self.fileCreateDate.text = artist;
}

#pragma mark - Getter

- (UILabel *)fileName {
    if (!_fileName) {
        _fileName = [UILabel new];
        _fileName.textColor = HEXCOLOR(0x666666);
        _fileName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _fileName.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _fileName;
}

- (UILabel *)fileCreateDate {
    if (!_fileCreateDate) {
        _fileCreateDate = [UILabel new];
        _fileCreateDate.textColor = HEXCOLOR(0x999999);
        _fileCreateDate.font = [UIFont systemFontOfSize:12];
    }
    return _fileCreateDate;
}

- (UILabel *)fileSize {
    if (!_fileSize) {
        _fileSize = [UILabel new];
        _fileSize.textColor = HEXCOLOR(0x999999);
        _fileSize.font = [UIFont systemFontOfSize:13];
        _fileSize.textAlignment = NSTextAlignmentRight;
    }
    return _fileSize;
}

@end
