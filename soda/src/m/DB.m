//
//  DB.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/10.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "DB.h"

#import "FMDatabaseAdditions.h"
#import "Util.h"
#import "GV.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation DB
@synthesize db;

+(DB *) getShareInstance{
    static DB *myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    return myInstance;
}

+(void) setDB:(FMDatabase *)db{
    DB *myInstance=[DB getShareInstance];
    myInstance.db=db;
}

//porfile,goods,secret icon都只有remote 端有資料
+(BOOL) iniSysConfig{
    //create database
    NSString *path = [NSString stringWithFormat:@"%@/database.sqlite",[GV sharedInstance].pathDB];
    NSLog(@"%@",[GV sharedInstance].pathDB);
    FMDatabase *db =[FMDatabase databaseWithPath:path];
    [DB setDB:db];

    [db open];
    //collection
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS collection(id INTEGER PRIMARY KEY,name text, google_types text, title text, keyword text, icon text, lang text,other_source text, is_default bool default 1, sort DOUBLE default 100,distance DOUBLE,center_lat REAL,center_lng REAL,is_only_phone bool default 0,is_only_opening bool default 0,is_only_favorite bool default 0,rating REAL,is_only_official_suggest bool default 0,sorting_key text,is_search bool default 0)"];

    //favorite
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS favorite(id INTEGER PRIMARY KEY AUTOINCREMENT, name text, google_type text, google_id text, google_ref text, phone text, address text, lat REAL, lng REAL)"];
    
    //goodsbox
    //每開一次app 都會跟server 要資料
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS goodsbox(name text, type text, num INTEGER, rare REAL, max INTEGER)"];
    
    //icon
    //從server 的secret_collection 要到資料
    //然後從client 端對server 建立 secret_icon 的資料
    //建完 is_get 設定為 YES
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS secret_icon(name TEXT, tip TEXT, is_get BOOLEAN, is_sync BOOLEAN, icon_id INTEGER, secret_id TEXT, sort INTEGER, created_time TEXT)"];
    

    //sys config
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS sys_config(name text, content text)"];
    
    [db executeUpdate:@"CREATE INDEX IF NOT EXISTS index_collection_name_lang_sort ON collection (name, lang, sort);"];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ui(name text, title text, icon text, lang text)"];
    [db executeUpdate:@"CREATE INDEX IF NOT EXISTS index_ui_name_lang ON ui(name, lang);"];
    
    //usage_log
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS usage_log(id INTEGER PRIMARY KEY AUTOINCREMENT,s_date text, e_date text)"];
    
    
    //check collection data if exist then user click sync server or reset check again;
    int checkExistData=[db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM collection WHERE lang='%@'",[Util getLang]]];
    if(checkExistData==0){
        //remote error set local data
        @try {
            [self insertRemoteDefaultCollection:db action:@"default" lang:nil];
            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO collection (name,google_types,keyword,other_source,title,icon,is_default,lang,sort,distance,is_search) VALUES ('%@','%@','%@','%@','%@','%@','%d','%@','%f','%f',1)",@"search",@"",@"",@"",@"search",@"",1,[Util getLang],100.0f,300.0f]];
        }
        @catch (NSException *exception) {
            NSLog(@"exception:insertRemoteDefaultCollection");
        }
        @finally {
            
        }
    }
    
    //check ui
    checkExistData=[db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM ui WHERE lang='%@'",[Util getLang]]];
    if(checkExistData==0){
        //remote error set local data
        @try {
            [self insertRemoteUI:db action:@"get" lang:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"exception:insertRemoteUI");
        }
        @finally {
            
        }
    }
    
    //check sys_config
    checkExistData=[db intForQuery:@"SELECT COUNT(*) FROM sys_config"];
    if(checkExistData==0){
        //remote error set local data
        @try {
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"share_review",@"1"]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"share_favorite",@"1"]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"share_good",@"1"]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"share_icon",@"1"]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"tip",@"1"]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"notification",@"1"]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"lang",[Util getLang]]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%f')",@"center_lat",0.0f]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%f')",@"center_lng",0.0f]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%f')",@"distance",300.0f]];
            [db executeUpdate:[NSString stringWithFormat:@"insert into sys_config (name,content) VALUES ('%@','%@')",@"is_cust_location",@"N"]];
            //coin 先不實作
        }
        @catch (NSException *exception) {
            NSLog(@"exception:insertRemoteUI");
        }
        @finally {
            
        }
    }
    
    //check soda func remote sync per 60 secs/ dispose app
//    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS func(name TEXT, is_deprecating BOOLEAN, is_sync BOOLEAN, count INTEGER)"];
//    [db executeUpdate:@"CREATE INDEX IF NOT EXISTS index_func_name ON func(name);"];
//    checkExistData=[db intForQuery:@"SELECT COUNT(*) FROM func"];
//    //no data then setting with remote data;
//    //else insert check remote data.
//    if(checkExistData==0){
//        [self insertFuncFromRemote];
//    }else{
//        [self syncFuncFromRemote];
//    }

    [db close];
    return true;
}

+(void)getSecretIconFromRemote:(void(^)(NSMutableDictionary *data, NSError *connectionError)) completion{
    //clear local secret data in condition that is expired;
    GV *gv=[GV sharedInstance];
//    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_removeAllSecretIcon) object:nil];
//    [gv.FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
    
    NSString *accessToken=@"";
    if(gv.loginType==Facebook){
        accessToken=[FBSession activeSession].accessTokenData.accessToken;
    }else{
        accessToken=gv.googleAccessToken;
    }
    NSString *urlGetSecretIcon=[NSString stringWithFormat:@"http://%@/%@?action=%@&member_id=%@&access_token=%@", gv.domain, gv.controllerIcon, @"get_secret",gv.localUserId,accessToken];
    NSLog(@"%@",urlGetSecretIcon);
    [Util jsonAsyncWithUrl:urlGetSecretIcon target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:3 completion:completion queue:gv.backgroundThreadManagement];
    
}

+(void)_removeAllSecretIcon{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    [db executeUpdate:@"DELETE from secret_icon"];
    [db close];
}

+(void)getIconFromRemote{
    
}

+(NSMutableArray *) convertToArrayWithFMResultSet:(FMResultSet *) results{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    while([results next]){
        NSObject *item=[[NSObject alloc]init];
        for(int i=0;i<[results columnCount];i++){
            NSString *columnName=[results columnNameForIndex:i];
            [item setValue:[results stringForColumn:columnName] forKey:columnName];
        }
        [arr addObject:item];
    }
    return arr;
}

NSString *sysConfigResult=@"";
+(NSString *) getSysConfig:(NSString *)key{
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_getSysConfig:) object:key];
    [[GV sharedInstance].FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation,nil] waitUntilFinished:YES];
    return sysConfigResult;
}
+(void) _getSysConfig:(NSString *)key{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    NSString *result=[db stringForQuery:[NSString stringWithFormat:@"SELECT content FROM sys_config WHERE name='%@'",key]];
    [db close];
    sysConfigResult=result;
}


+(BOOL) setSysConfig:(NSString *)key value:(NSString *) value{
    BOOL result=YES;
    @try {
        NSMutableDictionary *dicParameters=[[NSMutableDictionary alloc]init];
        [dicParameters setValue:key forKey:@"key"];
        [dicParameters setValue:value forKey:@"value"];
        NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_setSysconfig:) object:dicParameters];
        [[GV sharedInstance].FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation,nil] waitUntilFinished:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@",exception.description);
        result=NO;
    }
    @finally {
        
    }
    return result;
}
+(void)_setSysconfig:(NSDictionary *) dicParameters{
    FMDatabase *dba=[DB getShareInstance].db;
    [dba open];
    [dba executeUpdate:[NSString stringWithFormat:@"UPDATE sys_config set content='%@' WHERE name='%@'",[dicParameters valueForKey:@"value"],[dicParameters valueForKey:@"key"]]];
    [dba close];
}


+(void) insertRemoteDefaultCollection:(FMDatabase *)db  action:(NSString *)action lang:(NSString *) lang{
    GV *gv=[GV sharedInstance];
    if(lang==nil){
        lang=[Util getLang];
    }
    NSString *urlGetDefaultCollection=[NSString stringWithFormat:@"http://%@/%@?action=%@&lang=%@", gv.domain, gv.controllerCollection, action,lang];
    NSLog(@"%@",urlGetDefaultCollection);
    NSMutableDictionary *dicConfig =[Util jsonWithUrl:urlGetDefaultCollection];
    NSMutableArray *arrResults=[dicConfig objectForKey:@"results"];
    //NSLog(@"default collection:%@",arrResults);
    for(int i=0;i<[arrResults count];i++){

        NSDictionary *dicCate=arrResults[i];
        //check same name for when not initial
        int checkCollection=[db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM collection WHERE name='%@' AND lang='%@'",[dicCate valueForKey:@"name"],lang]];
        NSString *sql;
        if(checkCollection>0){
            sql=[NSString stringWithFormat:@"UPDATE collection SET google_types='%@',keyword='%@',other_source='%@',title='%@',icon='%@',is_default=%d,sort='%f',distance='%f' WHERE name='%@' AND lang='%@'",[dicCate valueForKey:@"google_types"],[dicCate valueForKey:@"keyword"],[dicCate valueForKey:@"other_source"], [dicCate valueForKey:@"title"],[dicCate valueForKey:@"icon"],(int) [dicCate valueForKey:@"is_default"],(double) [[dicCate valueForKey:@"sort"] doubleValue],[[dicCate valueForKey:@"distance"] doubleValue],[dicCate valueForKey:@"name"],[dicCate valueForKey:@"lang"]];
        }else{
            sql=[NSString stringWithFormat:@"INSERT INTO collection (name,google_types,keyword,other_source,title,icon,is_default,lang,sort,distance) VALUES ('%@','%@','%@','%@','%@','%@','%d','%@','%f','%f')",[dicCate valueForKey:@"name"],[dicCate valueForKey:@"google_types"],[dicCate valueForKey:@"keyword"],[dicCate valueForKey:@"other_source"],[dicCate valueForKey:@"title"],[dicCate valueForKey:@"icon"],(int) [dicCate valueForKey:@"is_default"],[dicCate valueForKey:@"lang"],(double) [[dicCate valueForKey:@"sort"] doubleValue],[[dicCate valueForKey:@"distance"] doubleValue]];
        }
        [db executeUpdate:sql];
    }
}
+(void) dropAllTable{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    [db executeUpdate:@"DROP TABLE collection"];
    [db executeUpdate:@"DROP TABLE ui"];
    [db executeUpdate:@"DROP TABLE sys_config"];
    [db close];
}
+(void) insertRemoteUI:(FMDatabase *)db action:(NSString *) action lang:(NSString *) lang{
    GV *gv=[GV sharedInstance];
    if(lang==nil){
        lang=[Util getLang];
    }
    NSString *urlGetUI=[NSString stringWithFormat:@"http://%@/%@?action=%@&lang=%@", gv.domain, gv.controllerUI, action, lang];
    NSMutableDictionary *dic =[Util jsonWithUrl:urlGetUI];
    NSMutableArray *arrResults=[dic objectForKey:@"results"];
    NSLog(@"%@",arrResults);
    for(int i=0;i<[arrResults count];i++){
        NSDictionary *dicCate=arrResults[i];
        //check same name for when not initial
        int checkCollection=[db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM ui WHERE name='%@' AND lang='%@'",[dicCate valueForKey:@"name"],lang]];
        NSString *sql;
        if(checkCollection>0){
            sql=[NSString stringWithFormat:@"UPDATE ui SET title='%@' WHERE lang='%@' AND name='%@'", [dicCate valueForKey:@"title"],[dicCate valueForKey:@"lang"],[dicCate valueForKey:@"name"]];
        }else{
            sql=[NSString stringWithFormat:@"INSERT INTO ui (name,title,lang) VALUES ('%@','%@','%@')",[dicCate valueForKey:@"name"],[[dicCate valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"'" withString:@"''"],[dicCate valueForKey:@"lang"] ];
        }
        [db executeUpdate:sql];
    }
}
+(BOOL)changeLang:(NSString *) lang{
    @try {
        [DB setSysConfig:@"lang" value:lang];
        FMDatabase *db=[DB getShareInstance].db;
        [db open];
        if([db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM ui WHERE lang='%@'",lang]]==0){
            [self insertRemoteUI:db action:@"get" lang:lang];
        }
        if([db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM collection WHERE lang='%@'",lang]]==0){
            [self insertRemoteDefaultCollection:db action:@"default" lang:lang];
        }
        [db close];
    }
    @catch (NSException *exception) {
        NSLog(@"error:%@",exception.description);
        return false;
    }
    @finally {

    }
    return true;

}
NSString *uiResult;
+(NSString *)getUI:(NSString *)key{
    NSMutableDictionary *dicParam=[[NSMutableDictionary alloc] init];
    [dicParam setValue:[DB getSysConfig:@"lang"] forKey:@"lang"];
    [dicParam setValue:key forKey:@"key"];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_getUI:) object:dicParam];
    [[GV sharedInstance].FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation,nil] waitUntilFinished:YES];
    if(!uiResult){
        return [key stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    }
    return uiResult;
}
+(void)_getUI:(NSDictionary *)dicParam{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    uiResult=[db stringForQuery:[NSString stringWithFormat:@"SELECT title FROM ui WHERE name='%@' AND lang='%@'",[dicParam valueForKey:@"key"], [dicParam valueForKey:@"lang"]]];
    [db close];
}

+(NSString *)getUIInnerFMDatabaseQueue:(NSString *)key{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    NSString *result=[db stringForQuery:[NSString stringWithFormat:@"SELECT title FROM ui WHERE name='%@' AND lang=(select content from sys_config where name='lang')",key]];
    [db close];
    if(!result){
        return [key stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    }
    return result;
}

+(BOOL) clearLocalCollection:db{
    return [db executeUpdate:@"DROP TABLE IF EXISTS collection)"];
}
@end
