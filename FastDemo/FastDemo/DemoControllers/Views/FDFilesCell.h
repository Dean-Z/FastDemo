//
//  FDFilesCell.h
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDFilesCell : UITableViewCell

@property (nonatomic, strong) NSString *dirPath;
- (void)renderWithFileName:(NSString *)name;

@end
