//
//  FDBlockContants.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#ifndef FDBlockContants_h
#define FDBlockContants_h

typedef void (^fd_block_void)(void);
typedef void (^fd_block_bool)(BOOL);
typedef void (^fd_block_object)(id);
typedef void (^fd_block_int)(int);
typedef void (^fd_block_float)(float);
typedef void (^fd_block_object_object)(id, id);
typedef void (^ModelLoadDataCompleteBlock)(NSError *);

#endif /* FDBlockContants_h */
