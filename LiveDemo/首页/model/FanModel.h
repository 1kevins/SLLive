//
//  FanModel.h
//  LiveDemo
//
//  Created by kevin on 2017/6/23.
//  Copyright © 2017年 SLLive. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol FanModelDetail @end
@interface FanModelDetail  : JSONModel

@property(nonatomic,assign)NSInteger pos  ;// 3,
@property(nonatomic,assign)NSInteger allnum  ;// 25545,
@property(nonatomic,assign)NSInteger roomid  ;// 60314136,
@property(nonatomic,assign)NSInteger serverid  ;// 15,
@property(nonatomic,strong)NSString * gps  ;//  来自喵星 ,
@property(nonatomic,strong)NSString * flv  ;//  http ;////hdl.9158.com/live/e88fabcfba2926c99eb6500eb513fc92.flv ,
@property(nonatomic,assign)NSInteger starlevel  ;// 2,
@property(nonatomic,strong)NSString * familyName  ;//   ,
@property(nonatomic,assign)NSInteger isSign  ;// 0,
@property(nonatomic,strong)NSString * nation  ;//   ,
@property(nonatomic,strong)NSString * nationFlag  ;//   ,
@property(nonatomic,assign)NSInteger distance  ;// 0,
@property(nonatomic,assign)NSInteger gameid  ;// 0,
@property(nonatomic,assign)NSInteger useridx  ;// 62132191,
@property(nonatomic,assign)NSInteger realuidx  ;// 0,
@property(nonatomic,strong)NSString * userId  ;//  WeiXin22369830 ,
@property(nonatomic,assign)NSInteger gender  ;// 0,
@property(nonatomic,strong)NSString * myname  ;//  秋-小曲贼上道😏 ,
@property(nonatomic,strong)NSString * signatures  ;//  我回来啦~ ,
@property(nonatomic,strong)NSString * smallpic  ;//  http ;////liveimg.9158.com/pic/avator/2017-05/07/20/20170507204801_62132191_250.png ,
@property(nonatomic,strong)NSString * bigpic  ;//  http ;////liveimg.9158.com/pic/avator/2017-05/07/20/20170507204801_62132191_640.png ,
@property(nonatomic,assign)NSInteger level  ;// 0,
@property(nonatomic,assign)NSInteger grade  ;// 0,
@property(nonatomic,assign)NSInteger curexp  ;// 0


@end


@protocol FanModelList @end
@interface FanModelList  : JSONModel

@property(nonatomic,assign)NSInteger counts;
@property(nonatomic,strong)NSMutableArray <FanModelDetail>* list;

@end


@interface FanModel  : JSONModel

@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *msg;
@property(nonatomic,strong)FanModelList <FanModelList>*data;
+(void)getFanModelithBlock:(void (^)(NSMutableArray* Arr))success error:(void (^)(NSError* error)) errors;
@end



