#import "ListItem.h"
#import "Util.h"
#import "DB.h"
#import "ScrollViewControllerCate.h"
#import "ButtonCate.h"
#import "ScrollViewControllerList.h"
#import "ViewReview.h"
#import "Util.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SocialUtil.h"
#import "ViewControllerRoot.h"

@implementation ListItem
@synthesize imgViewBg,blurBg,updateBlurTimer,maskBg,viewTopBorder,viewBottomBorder,lblName,btnFavorite,btnFlag,btnPhone,btnReview,btnShowMap,strPhone,rate,googleId,btnLigth,dicDetailPanel,scrollViewCurrentExpanded,scrollViewDetailBase,scrollViewDetailMap,scrollViewDetailOpening,scrollViewDetailReview,isExpanded,viewGradientBgForName;

double posBottomLine=150-10-44+8;
double posLeft;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentCon=[[ViewContainer alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        //self.contentCon.userInteractionEnabled=NO;
        // Initialization code
        CGRect rec=CGRectMake(0, 0, self.gv.screenW, 150);
        imgViewBg = [[AsyncImgView alloc]initWithFrame:rec];
        [self addSubview:imgViewBg];
        self.seq=-1;
        posLeft=320-44-20;
        //no detail view 30 listItem 121mb use memory capacity
        //after 123mb;
        //目前只實作 map 和 review / base 和 opening 現在先不要做 
        dicDetailPanel=[[NSMutableDictionary alloc] init];
        scrollViewDetailMap=[[ScrollViewDetailMap alloc] initWithFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-40-80-150)];
        scrollViewDetailMap.name=@"map";
        [self.contentCon addSubview:scrollViewDetailMap];
        [dicDetailPanel setValue:scrollViewDetailMap forKey:scrollViewDetailMap.name];
        
        scrollViewDetailReview=[[ScrollViewDetailReview alloc] initWithFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];
        scrollViewDetailReview.name=@"review";
        [self.contentCon addSubview:scrollViewDetailReview];
        [dicDetailPanel setValue:scrollViewDetailReview forKey:scrollViewDetailReview.name];
        
        scrollViewDetailOpening=[[ScrollViewDetailOpening alloc] initWithFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-40-80-150)];
        scrollViewDetailOpening.name=@"opening";
        [self.contentCon addSubview:scrollViewDetailOpening];
        [dicDetailPanel setValue:scrollViewDetailOpening forKey:scrollViewDetailOpening.name];
        
        scrollViewDetailBase=[[ScrollViewDetailBase alloc] initWithFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-40-80-150)];
        scrollViewDetailBase.name=@"base";
        [scrollViewDetailBase setBackgroundColor:[UIColor whiteColor]];
        [self.contentCon addSubview:scrollViewDetailBase];
        [dicDetailPanel setValue:scrollViewDetailBase forKey:scrollViewDetailBase.name];
        
        //mask
        maskBg=[[UIView alloc]initWithFrame:rec];
        //[maskBg setBackgroundColor:[Util colorWithHexString:@"#1b686630"]];
        [maskBg setBackgroundColor:[Util colorWithHexString:@"#00000050"]];
        [maskBg setUserInteractionEnabled:NO];
        [self addSubview:maskBg];

        
        //blurVersion
        if(self.gv.isBlurModel){
            blurBg= [[FXBlurView alloc] initWithFrame:rec];
            [self addSubview:blurBg];
            [blurBg setBlurEnabled:NO];
            [blurBg setAlpha:0.0f];
            [blurBg setBlurRadius:18.0f];
        }else{
            [maskBg setBackgroundColor:[Util colorWithHexString:@"#00000090"]];
        }


        
        //no blur version
        //[maskBg setBackgroundColor:[Util colorWithHexString:@"#000000CC"]];
        viewGradientBgForName=[[UIView alloc] initWithFrame:CGRectMake(0, -45, self.gv.screenW, 45)];
        viewGradientBgForName.userInteractionEnabled=NO;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = viewGradientBgForName.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[Util colorWithHexString:@"0000008f"] CGColor], (id)[[Util colorWithHexString:@"00000000"] CGColor], nil];
        [viewGradientBgForName.layer insertSublayer:gradient atIndex:0];
        [self addSubview:viewGradientBgForName];
        [self addSubview:self.contentCon];
        
        
        btnFlag=[[ButtonFlag alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.contentCon addSubview:btnFlag];
        
        lblName=[[UILabel alloc] init];
        [lblName setFont:self.gv.fontListName];
        [lblName setTextColor:[UIColor whiteColor]];
        [self.contentCon addSubview:lblName];
        
        btnPhone=[[ButtonPhone alloc] initWithFrame:CGRectMake(posLeft,posBottomLine, 44, 44)];
        [btnPhone setHidden:YES];
        strPhone=@"";
        [self.contentCon addSubview:btnPhone];
        
        btnLigth=[[ButtonLight alloc] initWithFrame:CGRectMake(posLeft,posBottomLine, 44, 44)];
        [btnLigth setHidden:YES];
        self.isOpening=NO;
        [self.contentCon addSubview:btnLigth];
        
        btnFavorite=[[ButtonLike alloc] initWithFrame:CGRectMake(posLeft, posBottomLine, 44, 44)];
        [btnFavorite setHidden:YES];
        self.isFavorite=NO;
        [self.contentCon addSubview:btnFavorite];

        
        btnShowMap=[[ButtonShowMap alloc] initWithFrame:CGRectMake(posLeft, posBottomLine, 44, 44)];
        [btnShowMap setHidden:YES];
        [self.contentCon addSubview:btnShowMap];
        
        btnReview=[[ButtonReview alloc] initWithFrame:CGRectMake(posLeft,  posBottomLine, 44, 44)];
        [btnReview setHidden:YES];
        [self.contentCon addSubview:btnReview];
        
        
        viewTopBorder= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.gv.screenW, 1)];
        [self addSubview:viewTopBorder];
        [self iniTopBorder];
        
        viewBottomBorder= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.gv.screenW, 1)];
        [self addSubview:viewBottomBorder];
        [self iniBottomBorder];
        
        [self setClipsToBounds:YES];
        
        self.viewMiddleLigthBorder=[[UIView alloc] initWithFrame:CGRectMake(0, 150, self.gv.screenW, 1)];
        [self.viewMiddleLigthBorder setBackgroundColor:[Util colorWithHexString:@"#FFFFFF55"]];
        [self.contentCon addSubview:self.viewMiddleLigthBorder];
        [self.viewMiddleLigthBorder setAlpha:0.0];
        self.viewMiddleDarkBorder=[[UIView alloc] initWithFrame:CGRectMake(0, 149, self.gv.screenW, 1)];
        [self.viewMiddleDarkBorder setBackgroundColor:[Util colorWithHexString:@"#00000055"]];
        [self.contentCon addSubview:self.viewMiddleDarkBorder];
        [self.viewMiddleDarkBorder setAlpha:0.0];
        
        //comment block
        self.lblIForComment=[[UILabel alloc] initWithFrame:CGRectMake(20, 180, 20, 20)];
        [self.lblIForComment setFont:self.gv.fontListFunctionTitle];
        [self.lblIForComment setText:@"I"];
        [self.lblIForComment setTextColor:[UIColor whiteColor]];
        [self.contentCon addSubview:self.lblIForComment];
        
        self.btnComment=[[ButtonComment alloc] initWithFrame:CGRectMake(28, 162,44, 44)];
        [self.contentCon addSubview:self.btnComment];
        [self.btnComment addTarget:self.btnComment action:@selector(switchCommentArea) forControlEvents:UIControlEventTouchUpInside];
        
        //circle
        //self.loadingCircle =[[LoadingCircle alloc]initWithFrame:CGRectMake((320-30)/2, (150-30)/2, 30, 30)];
        self.loadingCircle =[[LoadingCircle alloc]initWithFrameAndThick:CGRectMake((320-40)/2, (150-40)/2, 40, 40) thick:2];
        [self addSubview:self.loadingCircle];
        
        
        //arrow
        self.viewArrow=[[ViewArrow alloc] initWithFrame:CGRectMake(btnReview.frame.origin.x+(44-20)/2,145, 20, 5)];
        [self addSubview:self.viewArrow];
        [self.viewArrow setAlpha:0.0f];
        self.viewArrow.userInteractionEnabled=NO;
    }
    return self;
}

-(void)iniTopBorder{
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:CGPointMake(0, 0)];
    [bgPath addLineToPoint:CGPointMake(self.gv.screenW, 0)];
    [bgPath addLineToPoint:CGPointMake(self.gv.screenW, 1)];
    [bgPath addLineToPoint:CGPointMake(0, 1)];
    [bgPath addLineToPoint:CGPointMake(0, 0)];
    [bgPath closePath];
    bgLayer.path = [bgPath CGPath];
    bgLayer.fillColor =[[Util colorWithHexString:@"0xFFFFFF55"] CGColor];
    [bgLayer setFrame:CGRectMake(0, 0, 320, 1)];
    [viewTopBorder.layer addSublayer:bgLayer];
}

-(void)iniBottomBorder{
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:CGPointMake(0, 149)];
    [bgPath addLineToPoint:CGPointMake(self.gv.screenW, 149)];
    [bgPath addLineToPoint:CGPointMake(self.gv.screenW, 150)];
    [bgPath addLineToPoint:CGPointMake(0, 150)];
    [bgPath addLineToPoint:CGPointMake(0, 149)];
    [bgPath closePath];
    bgLayer.path = [bgPath CGPath];
    bgLayer.fillColor =[[Util colorWithHexString:@"0x00000055"] CGColor];
    [bgLayer setFrame:CGRectMake(0, 0, 320, 1)];
    [viewBottomBorder.layer addSublayer:bgLayer];
}

-(BOOL)checkFlagByGoogleId:(NSString *) gid{
    NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&google_id=%@",self.gv.urlProtocol,self.gv.domain,self.gv.controllerOfficialSuggestPlace,self.gv.actionCheckExistsOfficialSuggestPlace,gid];
    NSMutableDictionary *dicCheck=[Util jsonWithUrl:url];
    if([[dicCheck valueForKey:@"exists"] boolValue] ){
        return YES;
    }else{
        return NO;
    }
    return YES;
}

-(void) call{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strPhone]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

-(void) loadPicFromGoogle:(NSString *) ref{
    [imgViewBg setHidden:NO];
    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=false&key=%@",ref,[GV sharedInstance].googleWebKey] ;
    if(self.gv.isBlurModel){
        [blurBg setDynamic:YES];
        [blurBg setBlurEnabled:YES];
    }
    [imgViewBg loadImageFromURL:strURL target:self completion:@selector(blurVersion)];
    
}

-(void) addLoadGooglePlaceDetailToQueue:(NSString *) ref{
    if([GV getGlobalStatus]==COMMON){
        NSLog(@"exit addLoadGooglePlaceDetailToQueue");
        return;
    }
    ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    if(scrollViewControllerList.isCancelCurrentLoadItemListMarker){
        return;
    }
    GooglePlaceAPI *api=[self.gv.gpApiPool getAPI];
    api.busy+=1;
    NSMutableDictionary *parDic=[[NSMutableDictionary alloc] init];
    [parDic setValue:ref forKeyPath:@"ref"];
    [parDic setValue:api.key forKeyPath:@"apiKey"];
    [parDic setValue:api forKey:@"api"];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_loadDetailFromGoogle:) object:parDic];
    [api.queue addOperation:operation];
}

-(void) _loadDetailFromGoogle:(NSMutableDictionary *) par{
    if([GV getGlobalStatus]==COMMON){
        NSLog(@"exit _loadDetailFromGoogle");
        return;
    }
    //[NSThread sleepForTimeInterval:0.08];
    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@&language=%@",[par valueForKey:@"ref"],[par valueForKey:@"apiKey"] ,[DB getSysConfig:@"lang"]] ;
    ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    //抓googel的資料
    [Util jsonAsyncWithUrl:strURL target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:10 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        //GooglePlaceAPI *api=(GooglePlaceAPI *)[par valueForKey:@"api"];
        BOOL isError=NO;
        if(connectionError !=nil|| ![[data valueForKey:@"status"] isEqualToString:@"OK"]){
            NSLog(@"status:%@",[data valueForKey:@"status"]);
            NSLog(@"err_msg:%@",[data valueForKey:@"error_message"]);
            NSLog(@"error:%@",connectionError.description);
            isError=YES;
        }
        
        [[[data objectForKey:@"result"] objectForKey:@"types"] addObject:scrollViewControllerList.keyword];

        NSData* jsonData = nil;
        @try {
            jsonData=[NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"error test:%@",data);
        }
        @finally {
        }

        if(!isError){
            //check opening hours
            if([[data objectForKey:@"result"] objectForKey:@"opening_hours"]==nil && [[data objectForKey:@"result"] objectForKey:@"opening_hours"]==nil){
                NSString *name=[[data objectForKey:@"result"] valueForKey:@"name"];

                //let user grab facebook store opening data to local database
                if(self.gv.loginType==Facebook){
                    //把facebook資料抓回來
                    //NSLog(@"%@",[NSString stringWithFormat:@"%@:https://graph.facebook.com/search?q=%@&type=page&access_token=%@",name,name,[FBSession activeSession].accessTokenData.accessToken]);
                    [Util jsonAsyncWithUrl:[NSString stringWithFormat:@"https://graph.facebook.com/search?q=%@&type=page&access_token=%@",name, [FBSession activeSession].accessTokenData.accessToken] target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
                        //NSLog(@"%@",[NSString stringWithFormat:@"%@:%@",name,data]);
                    } queue:self.gv.backgroundThreadManagement];
                }
            }
            NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            NSString* jsonStringEscape=[[jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            NSMutableDictionary *test=[data copy];
            
            @try {

                NSString *addPlaceToLocalURL =[NSString stringWithFormat:@"%@://%@/%@?action=%@&member_id=%@",self.gv.urlProtocol,self.gv.domain,self.gv.controllerPlace,self.gv.actionAddPlace,self.gv.localUserId];
                [Util stringAsyncWithUrlByPost:addPlaceToLocalURL cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:3 completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if (connectionError  || (int)newStr.length>0) {
                        NSLog(@"error:%@",newStr);
                    }
                } queue:self.gv.backgroundThreadManagement postData:[NSString stringWithFormat:@"google_place_detail=%@",jsonStringEscape]];
            }
            @catch (NSException *exception) {
            }
            @finally {
                
            }
        }
        self.jsonBaseData=[data objectForKey:@"result"];
        [scrollViewControllerList initialItemDataAndThen:self isFromLocal:NO];
    } queue:self.gv.backgroundThreadManagement];
}



-(BOOL) initialItemData:(NSMutableDictionary *)data isFromLocal:(BOOL) isFromLocal{
    ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    ButtonCate *selected=scrollViewControllerCate.selectedButtonCate;
    if(scrollViewControllerList.isCancelCurrentLoadItemListMarker){
        return NO;
    }
    
    //filter condition or sorting key on thie condition
    //有sorting key 的時候在這邊把seq 重新定義
    //如果有 filter condition 在 scrollViewControllerList.sorting 會在做一次
    if([scrollViewControllerList isExistSortingKey]){
        self.seq=scrollViewControllerList.itemPrepareDataCount;
    }
    scrollViewControllerList.itemPrepareDataCount+=1;
    
    if([[data objectForKey:@"photos"] count]>0){

        [self loadPicFromGoogle:[[[data  objectForKey:@"photos"] objectAtIndex:0]  valueForKey:@"photo_reference"]];
    }
    if([selected.sortingKey isEqual:@"distance"]){
        [NSThread sleepForTimeInterval:0.1];
        NSMutableDictionary *dicDist =[Util jsonWithUrl:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%.8F,%.8F&destinations=%.8F,%.8F&mode=walk&language=zh-TW&sensor=false",selected.centerLocation.latitude,selected.centerLocation.longitude,self.lat,self.lng]];
        NSString *stringDist=@"0";
        if([[dicDist valueForKey:@"status"] isEqualToString:@"OK"]){
            if([[dicDist objectForKey:@"rows"] count]>0 &&[[[[dicDist objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"] count]>0){
                stringDist=[[[[[[dicDist objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"];
            }
            NSString *address=[dicDist objectForKey:@"destination_addresses"];
            if(self.address.length==0){
                self.address=address;
            }
        }else{
            CLLocation *destination=[[CLLocation alloc] initWithLatitude:self.lat  longitude:self.lng];
            CLLocation *oringial=[[CLLocation alloc] initWithLatitude:selected.centerLocation.latitude  longitude:selected.centerLocation.longitude];
            stringDist=[NSString stringWithFormat:@"%f",[destination distanceFromLocation:oringial]* 0.000621371192*1000];
        }
        self.distance=[stringDist doubleValue];
    }else{
        [Util jsonAsyncWithUrl:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%.8F,%.8F&destinations=%.8F,%.8F&mode=walk&language=zh-TW&sensor=false",selected.centerLocation.latitude,selected.centerLocation.longitude,self.lat,self.lng] target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
            NSString *stringDist=@"";
            if([[data valueForKey:@"status"] isEqualToString:@"OK"]){
                if([[data objectForKey:@"rows"] count]>0 &&[[[[data objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"] count]>0){
                    stringDist=[[[[[[data objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"];
                }
                NSString *address=[data objectForKey:@"destination_addresses"];
                if(self.address.length==0){
                    self.address=address;
                }
            }else{
                CLLocation *destination=[[CLLocation alloc] initWithLatitude:self.lat  longitude:self.lng];
                CLLocation *oringial=[[CLLocation alloc] initWithLatitude:selected.centerLocation.latitude  longitude:selected.centerLocation.longitude];
                stringDist=[NSString stringWithFormat:@"%f",[destination distanceFromLocation:oringial]* 0.000621371192*1000];
            }
            self.distance=[stringDist floatValue];
        } queue:self.gv.backgroundThreadManagement];
    }
    
    
    //official suggestion
    if(!isFromLocal){
        if([self checkFlagByGoogleId:self.googleId]){
            self.isOfficialSuggest=YES;
        }else{
            self.isOfficialSuggest=NO;
        }
    }else{
        self.isOfficialSuggest=[[[data objectForKey:@"results"] valueForKey:@"official_suggest"] boolValue];
    }
    //phone;
    if([data objectForKey:@"international_phone_number"] !=nil && [data objectForKey:@"international_phone_number"] !=[NSNull null]){
        strPhone=[data objectForKey:@"international_phone_number"];
    }else if([data objectForKey:@"formatted_phone_number"] !=nil && [data objectForKey:@"formatted_phone_number"] !=[NSNull null]){
        strPhone=[data objectForKey:@"formatted_phone_number"];
    }
    strPhone=[strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    //address;
    self.address=[data valueForKey:@"formatted_address"];
    
    //types
    NSArray *types=[data objectForKey:@"types"];
    NSMutableString *typesString=[[NSMutableString alloc]init];
    for(int i=0;i<types.count;i++){
        if(i!=types.count-1){
            [typesString appendString:[NSString stringWithFormat:@"%@,",[types objectAtIndex:i]]];
        }else{
            [typesString appendString:[NSString stringWithFormat:@"%@",[types objectAtIndex:i]]];
        }
    }
    self.googleTypes=typesString;
    
    //name
    self.name=[data valueForKey:@"name"];
    
    //rate
    self.rate=[[data valueForKey:@"rating"] floatValue];

    //review
    self.arrReview=[data objectForKey:@"reviews"];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    self.arrReview=[[self.arrReview sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
    
    //抓自己的review
    if(!isFromLocal){
        if([selected.sortingKey isEqual:@"rating"]){
            NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&google_place_id=%@&is_from_local=0",self.gv.urlProtocol,self.gv.domain,self.gv.controllerReview,self.gv.actionGetReview,self.googleId];
            NSDictionary *dicReview=[Util jsonWithUrl:url];
            NSArray * arrReviewFromLocal=[dicReview objectForKey:@"results"];
            int originalReviewCount=(int)self.arrReview.count;
            double totalRatingFromLocalSite=0;
            for(int i=0;i<arrReviewFromLocal.count;i++){
                totalRatingFromLocalSite+=[[[arrReviewFromLocal objectAtIndex:i] valueForKey:@"rating"] doubleValue];
                [self.arrReview addObject:[arrReviewFromLocal objectAtIndex:i]];
            }
            if(originalReviewCount>0){
                self.rate=(
                           (self.rate*originalReviewCount)+
                           totalRatingFromLocalSite
                           )
                            /(arrReviewFromLocal.count+originalReviewCount);
            }else if(arrReviewFromLocal.count>0){
                self.rate=totalRatingFromLocalSite/arrReviewFromLocal.count;
            }
            NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
            self.arrReview=[[self.arrReview sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
        }else{
            NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&google_place_id=%@&is_from_local=0",self.gv.urlProtocol,self.gv.domain,self.gv.controllerReview,self.gv.actionGetReview,self.googleId];
            NSMutableDictionary *dicData=[Util jsonWithUrl:url];
            
            NSArray * arrReviewFromLocal=[dicData objectForKey:@"results"];
            int originalReviewCount=(int)self.arrReview.count;
            double totalRatingFromLocalSite=0;
            for(int i=0;i<arrReviewFromLocal.count;i++){
                totalRatingFromLocalSite+=[[[arrReviewFromLocal objectAtIndex:i] valueForKey:@"rating"] doubleValue];
                [self.arrReview addObject:[arrReviewFromLocal objectAtIndex:i]];
            }
            if(originalReviewCount>0){
                self.rate=(
                           (self.rate*originalReviewCount)+
                           totalRatingFromLocalSite
                           )
                /(arrReviewFromLocal.count+originalReviewCount);
            }else if(arrReviewFromLocal.count>0){
                self.rate=totalRatingFromLocalSite/arrReviewFromLocal.count;
            }
            NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
            self.arrReview=[[self.arrReview sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
        }
    }
    
    //light
    if([data objectForKey:@"opening_hours"] !=[NSNull null]  && [data objectForKey:@"opening_hours"] !=nil && [[data objectForKey:@"opening_hours"] valueForKey:@"open_now"] !=nil){
        self.isExistOpeningData=YES;
        if([[[data objectForKey:@"opening_hours"] valueForKey:@"open_now"] intValue]==1){
            self.isOpening=YES;
        }
    }else{
        self.isExistOpeningData=NO;
    }
    
    if(![scrollViewControllerList isExistSortingKey]){
        if(selected.isOnlyShowFavorite && !self.isFavorite){
            return NO;
        }
        if(selected.isOnlyShowOfficialSuggest && !self.isOfficialSuggest){
            return NO;
        }
        if(selected.isOnlyShowOpening && !self.isOpening){
            return NO;
        }
        if(selected.isOnlyShowPhone && self.strPhone.length==0){
            return NO;
        }
        if(selected.rating>self.rate){
            return NO;
        }
    }
    return YES;
}

-(void)displaySelf{
    if(![NSThread isMainThread]){
        NSException *e = [NSException
                          exceptionWithName:@"main thread exception"
                          reason:@"ListItem -placeElement is needed main thread"
                          userInfo:nil];
        @throw e;
    }
    ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    if([scrollViewControllerList isExistfilterCondition] && ![scrollViewControllerList isExistSortingKey]){
        [scrollViewControllerList.scrollViewList addSubview:self];
        [self setFrame:CGRectMake(0, 150*self.seq+40, self.gv.screenW, 150)];
        [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [self.contentCon setAlpha:1.0f];
         } completion:^(BOOL finished) {
             if (finished){
             }
         }];
    }else if(![scrollViewControllerList isExistfilterCondition] && ![scrollViewControllerList isExistSortingKey]){
        [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [self.contentCon setAlpha:1.0f];
         } completion:^(BOOL finished) {
             if (finished){
             }
         }];
    }else{
        [self setAlpha:1.0f];
    }
}

//main thread function
-(void) placeElement{
    [self.loadingCircle stop];
    if(![NSThread isMainThread]){
        NSException *e = [NSException
                          exceptionWithName:@"main thread exception"
                          reason:@"ListItem -placeElement is needed main thread"
                          userInfo:nil];
        @throw e;
    }
    ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    ButtonCate *selected=scrollViewControllerCate.selectedButtonCate;
    
    float iniPos=20.0f;
    //official suggestion
    double offsetForOfficialSuggest=0;
    if(self.isOfficialSuggest){
        [btnFlag setHidden:NO];
    }else{
        [btnFlag setHidden:YES];
        offsetForOfficialSuggest=29;
    }
    [lblName setFrame:CGRectMake(44-offsetForOfficialSuggest, 0, self.gv.screenW-40, 40)];
    self.lblName.text=self.name;
    
    //rate
    [btnReview setRate:rate];
    
    //review
    [btnReview setReviewCount:(int) [self.arrReview count]];
    
    if(strPhone.length>0){
        iniPos +=44+53;
        [btnPhone setHidden:NO];
    }else{
        if(selected.isOnlyShowPhone && ![scrollViewControllerList isExistSortingKey]){
            [self.loadingCircle stop];
            [self setHidden:YES];
            return;
        }
        iniPos+=44;
    }
    
    //favorite;
    if(self.gv.localUserId!=nil){
        self.isFavorite=[btnFavorite isFavorite];
        [btnFavorite setFrame:CGRectMake(self.gv.screenW-iniPos, posBottomLine, 44, 44)];
        iniPos +=53;
        [btnFavorite setHidden:NO];
    }
    //showMap
    [btnShowMap setFrame:CGRectMake(self.gv.screenW-iniPos, posBottomLine, 44, 44)];
    iniPos +=53;
    [btnShowMap setHidden:NO];
    //review
    [btnReview setFrame:CGRectMake(self.gv.screenW-iniPos, posBottomLine, 44, 44)];
    iniPos+=53;
    [btnReview setHidden:NO];
    if(rate<selected.rating && ![scrollViewControllerList isExistSortingKey]){
        [self.loadingCircle stop];
        [self setHidden:YES];
        return;
    }
    [btnReview setRate:rate];
    [btnReview setReviewCount:(int) [self.arrReview count]];
    //light
    if(self.isExistOpeningData){
        [btnLigth setFrame:CGRectMake(self.gv.screenW-iniPos, posBottomLine, 44, 44)];
        iniPos+=53;
        [btnLigth setHidden:NO];
        //NSLog(@"%@",[[data objectForKey:@"result"] objectForKey:@"opening_hours"] );
        if(self.isOpening){
            [btnLigth turnOn];
        }else if(selected.isOnlyShowOpening && ![scrollViewControllerList isExistSortingKey]){
            [self.loadingCircle stop];
            [self setHidden:YES];
            return;
        }
    }

}

-(void)noBlurVersion{
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [imgViewBg setAlpha:1.0f];
     } completion:^(BOOL finished) {
         if (finished){
         }
     }];
}

-(void) blurVersion{
    [imgViewBg setAlpha:0.0f];
    [imgViewBg setHidden:NO];
    [UIView animateWithDuration:0.28 delay:0.3 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [imgViewBg setAlpha:1.0f];
         [blurBg setAlpha:1.0f];
     } completion:^(BOOL finished) {
         if (finished){
             [blurBg setDynamic:NO];
         }
     }];
}

-(void)expandDetail:(NSString *) detailName animate:(BOOL) animate{
    self.expandName=detailName;
    ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList*)self.gv.scrollViewControlllerList;
    scrollViewControllerList.scrollViewList.isAutoAnimation=YES;
    scrollViewControllerList.expandedItem=self;
    self.poseOfCurrentReview=0;
    [self generateReview];
    [scrollViewDetailReview setContentOffset:CGPointMake(0, 0)];
    isExpanded=YES;
    
    [self.superview bringSubviewToFront:self];
    if(![detailName isEqual:@"review"]){
        [self.btnComment setFrame:CGRectMake(28-self.gv.screenW, self.btnComment.frame.origin.y, self.btnComment.frame.size.width, self.btnComment.frame.size.height)];
        [self.lblIForComment setFrame:CGRectMake(20-self.gv.screenW, self.lblIForComment.frame.origin.y, self.lblIForComment.frame.size.width, self.lblIForComment.frame.size.height)];
    }else{
        [self.btnComment setFrame:CGRectMake(28, self.btnComment.frame.origin.y, self.btnComment.frame.size.width, self.btnComment.frame.size.height)];
        [self.lblIForComment setFrame:CGRectMake(20, self.lblIForComment.frame.origin.y, self.lblIForComment.frame.size.width, self.lblIForComment.frame.size.height)];
    }
    
    
    
    for(NSString *key in self.dicDetailPanel){
        if(key != detailName){
            [[self.dicDetailPanel objectForKey:key] setFrame:CGRectMake(-self.gv.screenW, 150, self.gv.screenW, self.gv.screenH-40-150)];
        }else{
            [[self.dicDetailPanel objectForKey:key] setFrame:CGRectMake(0, 150, self.gv.screenW, 0)];
        }
    }

    NSArray *arrItemList=scrollViewControllerList.arrItemList;
    double duration=0.28;
    self.countFinishAllAnimation=0;
    if(!animate){
        duration=0.0;
    }
    if(scrollViewControllerList.isEndedForSearchResult){
        [self.contentCon setFrame:CGRectMake(0, 0, scrollViewControllerList.scrollViewList.frame.size.width, self.gv.screenH-40)];
    }else{
        [self.contentCon setFrame:CGRectMake(0, 0, scrollViewControllerList.scrollViewList.frame.size.width, self.gv.screenH)];
    }
    [scrollViewControllerList.scrollViewList setContentSize:CGSizeMake(0, 150*[scrollViewControllerList getListItemCountInnerScrollViewList]+self.gv.screenH-150-80)];

    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
        {

            //這邊要修改成 再scrollViewList裡頭做掉 要不然scroll 再轉的時候會變更viewFunBar的高度
            if(self.imgViewBg.image==nil && self.seq>0){
                scrollViewControllerList.scrollViewList.contentOffset=CGPointMake(0, self.seq*150-1+40) ;
            }else{
                scrollViewControllerList.scrollViewList.contentOffset=CGPointMake(0, self.seq*150+1+40);
            }
            [scrollViewControllerList.viewFunBar setFrame:CGRectMake(0, 0, self.gv.screenW, 0)];
            [[dicDetailPanel objectForKey:detailName] setFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];
            [self.viewMiddleLigthBorder setAlpha:1.0f];
            [self.viewMiddleDarkBorder setAlpha:1.0f];
            [self.viewArrow setAlpha:1.0f];
            if([detailName isEqual:@"review"]){
              [self.btnComment setAlpha:1.0f];
              [self.viewArrow setFrame:CGRectMake(self.btnReview.frame.origin.x+(self.btnReview.frame.size.width-self.viewArrow.frame.size.width)/2, self.viewArrow.frame.origin.y, self.viewArrow.frame.size.width, self.viewArrow.frame.size.height)];
            }else{
              [self.viewArrow setFrame:CGRectMake(self.btnShowMap.frame.origin.x+(self.btnShowMap.frame.size.width-self.viewArrow.frame.size.width)/2, self.viewArrow.frame.origin.y, self.viewArrow.frame.size.width, self.viewArrow.frame.size.height)];
            }
            [self setFrame:CGRectMake(0, self.frame.origin.y, self.gv.screenW, self.gv.screenH-80)];
            [viewBottomBorder setFrame:CGRectMake(0, self.gv.screenH-80-150, self.gv.screenW, 1)];

            [blurBg setAlpha:0.0f];
            [maskBg setAlpha:0.0f];
            if(self.imgViewBg.image!=nil){
              [viewGradientBgForName setFrame:CGRectMake(0, 0, self.gv.screenW, 45)];
            }
            for(int i =0;i<[arrItemList count];i++){
              ListItem* item=(ListItem*) [arrItemList objectAtIndex:i];
              if(item.isExpanded && ![item isEqual:self]){
                  [item clearReview];
              }
              if(item.seq==-1){
                  continue;
              }
              if(!item.isShow){
                  continue;
              }
              if(item.seq>self.seq){
                  [item setFrame:CGRectMake(0, item.seq*150+self.gv.screenH-80-150+40, self.gv.screenW, 150)];
              }
            }
            [scrollViewControllerList.btnMore setFrame:CGRectMake(0, (scrollViewControllerList.scrollViewList.subviews.count-3)*150+self.gv.screenH-150-80+40, self.gv.screenW, scrollViewControllerList.btnMore.frame.size.height)];
        } completion:^(BOOL finished) {
            if (finished){
              [blurBg setHidden:YES];
              [maskBg setHidden:YES];
            }
    }];
}

-(void)generateReview{
    if(![GV isLogin]){
        [self.lblIForComment setHidden:YES];
        [self.btnComment setHidden:YES];
    }else{
        [self.lblIForComment setHidden:NO];
        [self.btnComment setHidden:NO];
    }
    for(int i=0;i<self.arrReview.count;i++){
        NSDictionary *review=[self.arrReview objectAtIndex:i];
        NSDate *announcDate=[NSDate dateWithTimeIntervalSince1970:[[[self.arrReview objectAtIndex:i] valueForKey:@"time"] intValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strAnnounceDate = [formatter stringFromDate:announcDate];
        ViewReview *viewReview=[[ViewReview alloc] initWithParameter:CGRectMake(0,0, self.gv.screenW, 200) name:[review valueForKey:@"author_name"]   rating:[[review valueForKey:@"rating"] floatValue] comment:[review valueForKey:@"text"] announceDate:strAnnounceDate];
        viewReview.unixtime=(int)[[[self.arrReview objectAtIndex:i] valueForKey:@"time"] integerValue];
        [self.scrollViewDetailReview addSubview:viewReview];
        if(i==0 && [GV isLogin]){
            self.poseOfCurrentReview=50;
        }
        CGRect posRect=CGRectMake(0, self.poseOfCurrentReview+20, self.gv.screenW, viewReview.frame.size.height);
        [viewReview setFrame:posRect];
        viewReview.originalRect=posRect;
        self.poseOfCurrentReview=viewReview.frame.origin.y+viewReview.frame.size.height;
    
        //self review on soda;
        if([[self.arrReview objectAtIndex:i] valueForKey:@"soda_member_id"]!=nil
           &&
           [self.gv.localUserId isEqual:[[self.arrReview objectAtIndex:i] valueForKey:@"soda_member_id"]]
           ){
            viewReview.sodaMemberId=self.gv.localUserId;
            NSString *comment=[[self.arrReview objectAtIndex:i] valueForKey:@"text"];
            double rating=[[[self.arrReview objectAtIndex:i] valueForKey:@"rating"] doubleValue];
            [self.btnComment.voteHeart setRate:rating];
            if(comment.length>0){
                self.btnComment.btnInput.lblDefault.text=@"";
                self.btnComment.btnInput.lblShow.text=comment;
            }else{
                self.btnComment.btnInput.lblDefault.text=self.btnComment.defaultString;
                self.btnComment.btnInput.lblShow.text=@"";
            }
        }
    }
    [self.scrollViewDetailReview setContentSize:CGSizeMake(self.gv.screenW, self.poseOfCurrentReview)];
    self.scrollViewDetailReview.originalContentHeight=self.poseOfCurrentReview;
}

-(void)saveReview{
    //加一個loading;
    self.loadingForSendReview=nil;
    CGPoint point = [self.btnComment.btnSave convertPoint:self.btnComment.btnSave.bounds.origin toView:self.window];
    self.loadingForSendReview=[[LoadingCircle alloc] initWithFrameAndThick:CGRectMake(point.x+(self.btnComment.btnSave.frame.size.width-20)/2, point.y-80+(self.btnComment.btnSave.frame.size.height-20)/2-8, 20, 20) thick:1.5];
    [self addSubview:self.loadingForSendReview];
    [self.loadingForSendReview start];
    [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.btnComment.btnSave setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if(finished) {
        }
    }];
    
    
    NSString *comment=@"";
    if(self.btnComment.btnInput.lblShow.text!=nil){
        comment=self.btnComment.btnInput.lblShow.text;
    }
    NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&member_id=%@&google_place_id=%@&rating=%f&comment=%@",self.gv.urlProtocol ,self.gv.domain, self.gv.controllerReview,self.gv.actionAddReview,self.gv.localUserId,googleId,[self.btnComment.voteHeart getRate],comment];
    [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        if(connectionError ==nil){
            if([[[data objectForKey:@"results"] valueForKey:@"success"] boolValue]){
                double rating=[self.btnComment.voteHeart getRate];
                NSString *comment=self.btnComment.btnInput.lblShow.text;
                [self updateArrReviewWithComment:comment rating:rating];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateReviewPanelWithComment:comment rating:rating];
                    [self.btnComment contractCommentArea];
                    [SocialUtil shareReviewWithPlaceName:self.name comment:comment rating:rating googleId:self.googleId googleRef:self.googleRef];
                    [self.loadingForSendReview stop];
                });
                ViewControllerRoot* root= (ViewControllerRoot *)self.gv.viewControllerRoot;
                [root.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"vote_place"];

            }else{
                NSLog(@"server site error:%@",[data objectForKey:@"results"]);
            }
        }else{
            NSLog(@"%@",url);
            NSLog(@"connection error:%@",connectionError.description);
            [self.loadingForSendReview stop];
            [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.btnComment.btnSave setAlpha:1.0f];
            } completion:^(BOOL finished) {
                if(finished) {
                    UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Connection error, please, send again." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                    [calert show];
                }
            }];
        }
        
    } queue:self.gv.backgroundThreadManagement];
}
//only arrReview data
-(void)updateArrReviewWithComment:(NSString *)comment rating:(double)rating{
    BOOL isExist=NO;
    for(int i=0;i<self.arrReview.count;i++){
        if(i==0){
            NSLog(@"%@",[self.arrReview objectAtIndex:i]);
        }
        if([[self.arrReview objectAtIndex:i] valueForKey:@"soda_member_id"] !=nil &&
           [[[self.arrReview objectAtIndex:i] valueForKey:@"soda_member_id"] isEqualToString:self.gv.localUserId]
           ){
            [[self.arrReview objectAtIndex:i] setValue:[NSString stringWithFormat:@"%f",[self.btnComment.voteHeart getRate]] forKey:@"rating"];
            
            [[self.arrReview objectAtIndex:i] setValue:self.btnComment.btnInput.lblShow.text forKey:@"text"];
            [[self.arrReview objectAtIndex:i] setValue:[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]]  forKey:@"time"];
            isExist=YES;
            break;
        }
    }
    if(!isExist){
        NSMutableDictionary *newReview=[[NSMutableDictionary alloc] init];
        [newReview setValue:[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] forKey:@"time"];
        [newReview setValue:self.gv.localUserId forKey:@"soda_member_id"];
        [newReview setValue:self.gv.localUserName forKey:@"author_name"];
        [newReview setValue:[NSString stringWithFormat:@"%.2f",rating] forKey:@"rating"];
        [newReview setValue:comment forKey:@"text"];
        [self.arrReview addObject:newReview];
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
        self.arrReview=[[self.arrReview sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
    }
}
//only ui thread and reviewPanel
-(void)updateReviewPanelWithComment:(NSString *)comment rating:(double)rating{
    if(![NSThread isMainThread]){
        NSException *e = [NSException
                          exceptionWithName:@"main thread exception"
                          reason:@"ListItem -updateReviewPanelWithComment is needed main thread"
                          userInfo:nil];
        @throw e;
    }
    NSArray *subviews=self.scrollViewDetailReview.subviews;
    NSMutableArray *newSubviews=[[NSMutableArray alloc]init];
    BOOL isExist=NO;
    double originalRating=0;
    for(int i=0;i<subviews.count;i++){
        if([[subviews objectAtIndex:i] isKindOfClass:[ViewReview class]]){
            [newSubviews addObject:(ViewReview *)[subviews objectAtIndex:i]];
            ViewReview *review=(ViewReview *)[subviews objectAtIndex:i];
            if([review.sodaMemberId isEqualToString:self.gv.localUserId]){
                originalRating=review.reviewHeart.rating;
                [review.reviewHeart setRate:rating];
                review.lblComment.text=comment;
                //重算高度
                CGSize expectedSizeForComment = [review.lblComment sizeThatFits:CGSizeMake(self.gv.screenW-40, 99999)];
                [review.lblComment setFrame:CGRectMake(review.lblComment.frame.origin.x,review.lblComment.frame.origin.y, expectedSizeForComment.width,expectedSizeForComment.height)];
                [review setFrame:CGRectMake(review.frame.origin.x, review.frame.origin.y, self.gv.screenW-40, expectedSizeForComment.height+review.lblName.frame.size.height+50)];
                review.unixtime=(int) [[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] integerValue];
                
                [review.viewBottomBorder setFrame:CGRectMake(15, review.lblComment.frame.size.height+review.lblName.frame.size.height+50, self.gv.screenW-30, 1)];
                isExist=YES;
            }
        }
    }
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"unixtime" ascending:NO];
    if(!isExist){
        int unixtime=(int) [[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] integerValue];
        NSDate *announcDate=[NSDate dateWithTimeIntervalSince1970:unixtime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strAnnounceDate = [formatter stringFromDate:announcDate];
        ViewReview *viewReview=[[ViewReview alloc] initWithParameter:CGRectMake(0,0, self.gv.screenW, 200) name:self.gv.localUserName  rating:rating comment:comment announceDate:strAnnounceDate];
        viewReview.unixtime=unixtime;
        viewReview.sodaMemberId=self.gv.localUserId;
        [viewReview setAlpha:0.0f];
        [viewReview setFrame:CGRectMake(viewReview.frame.origin.y,-viewReview.frame.size.height/2, viewReview.frame.size.width, viewReview.frame.size.height)];
        [self.scrollViewDetailReview addSubview:viewReview];
        [newSubviews addObject:viewReview];
        
        //recaculate review count and rate
        int currentReviewCount=(int) [self.btnReview.lblCountOfReview.text intValue];
        self.btnReview.lblCountOfReview.text=[NSString stringWithFormat:@"%d",1+currentReviewCount];
        self.rate=(currentReviewCount*self.rate+rating)/(currentReviewCount+1);
        [self.btnReview setRate:self.rate];
    }else{
        //recaculate review count and rate
        int currentReviewCount=(int) [self.btnReview.lblCountOfReview.text intValue];
        
        //above loop get originalRating
        self.rate=(currentReviewCount*self.rate-originalRating+rating)/(currentReviewCount);
        [self.btnReview setRate:self.rate];
    }
    newSubviews=[[newSubviews sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
    
    [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.poseOfCurrentReview=0;
        for(int i=0;i<newSubviews.count;i++){
            if(i==0 && [GV isLogin]){
                self.poseOfCurrentReview=50;
            }
            
            ViewReview *viewReview=(ViewReview*)[newSubviews objectAtIndex:i];
            if(!isExist && i==0){
                [viewReview setAlpha:1.0f];
            }
            CGRect posRect=CGRectMake(0, self.poseOfCurrentReview+20, self.gv.screenW, viewReview.frame.size.height);
            [viewReview setFrame:posRect];
            viewReview.originalRect=posRect;
            self.poseOfCurrentReview=posRect.origin.y+posRect.size.height;
        }
        [self.scrollViewDetailReview setContentSize:CGSizeMake(self.gv.screenW, self.poseOfCurrentReview)];
        self.scrollViewDetailReview.originalContentHeight=self.poseOfCurrentReview;
    } completion:^(BOOL finished) {
        if(finished){
        }
    }];

}

-(void)clearReview{
    NSArray *subviews=self.scrollViewDetailReview.subviews;
    for(int i=0;i<subviews.count;i++){
        if([[subviews objectAtIndex:i] isKindOfClass:[ViewReview class]]){
            [[subviews objectAtIndex:i] removeFromSuperview];
        }
    }
}

-(void)contractDetailWithAll:(BOOL) animate{
    NSLog(@"contractDetailWithAll");
    [blurBg setHidden:NO];
    [maskBg setHidden:NO];
    isExpanded=NO;
    ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList*)self.gv.scrollViewControlllerList;
    scrollViewControllerList.scrollViewList.isAutoAnimation=YES;
    scrollViewControllerList.expandedItem=nil;
    NSArray *arrItemList=scrollViewControllerList.arrItemList;
    [self.btnComment contractCommentArea];
    double duration=0.28;
    if(!animate){
        duration=0.0;
    }
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
        [self.viewArrow setAlpha:0.0f];
         if(scrollViewControllerList.isEndedForSearchResult){
             [scrollViewControllerList.scrollViewList setContentSize:CGSizeMake(self.gv.screenW, scrollViewControllerList.itemDisplayCount*150+40)];
         }else{
             [scrollViewControllerList.scrollViewList setContentSize:CGSizeMake(self.gv.screenW, scrollViewControllerList.itemDisplayCount*150+40+40)];
         }
        [blurBg setAlpha:1.0];
        [maskBg setAlpha:1.0];
        [self.viewMiddleLigthBorder setAlpha:0.0f];
        [self.viewMiddleDarkBorder setAlpha:0.0f];
        [viewGradientBgForName setFrame:CGRectMake(0, -45, self.gv.screenW, 45)];
        [viewBottomBorder setFrame:CGRectMake(0, 0, self.gv.screenW, 1)];
        [self setFrame:CGRectMake(0, self.frame.origin.y, self.gv.screenW, 150)];
         ScrollViewControllerList *scrollViewControllerList=(ScrollViewControllerList*) self.gv.scrollViewControlllerList;
         [scrollViewControllerList.viewFunBar setFrame:CGRectMake(0, 0, self.gv.screenW, 40)];
         [scrollViewControllerList.scrollViewList iniMarker];
         if(scrollViewControllerList.scrollViewList.contentSize.
            height >self.gv.screenH-80 && self.seq*150+40>scrollViewControllerList.scrollViewList.contentSize.
            height-self.gv.screenH+80){
             scrollViewControllerList.scrollViewList.contentOffset=CGPointMake(0, scrollViewControllerList.scrollViewList.contentSize.height-self.gv.screenH+80);
         }else{
             if(scrollViewControllerList.scrollViewList.contentSize.height<self.gv.screenH-80-40){
                 scrollViewControllerList.scrollViewList.contentOffset=CGPointMake(0, 0);
             }else{
                 scrollViewControllerList.scrollViewList.contentOffset=CGPointMake(0, self.seq*150);
             }
         }
        [[dicDetailPanel objectForKey:self.expandName] setFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];

         for(int i =0;i<[arrItemList count];i++){
             ListItem* item=(ListItem*) [arrItemList objectAtIndex:i];
             if([item isEqual:self]){
                 continue;
             }
             if(item.seq==-1){
                 continue;
             }
             if(!item.isShow){
                 continue;
             }
             if(item.seq>self.seq){
                 [item setFrame:CGRectMake(0, item.seq*150+40, self.gv.screenW, 150)];
             }
         }
         [scrollViewControllerList.btnMore setFrame:CGRectMake(0, scrollViewControllerList.itemDisplayCount*150+40, self.gv.screenW, scrollViewControllerList.btnMore.frame.size.height)];
     } completion:^(BOOL finished) {
         if(finished){
             scrollViewControllerList.scrollViewList.isAutoAnimation=NO;
            [self clearReview];
         }
     }];


}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%@",self.googleId);
    NSLog(@"%@",self.googleTypes);
}


@end
