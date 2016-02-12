//
//  Contact.h
//  Whatsapp
//
//  Created by Magneto on 2/12/16.
//  Copyright © 2016 HummingBird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image_id;
-(BOOL)hasImage;
-(void)save;
+(Contact *)contactFromDictionary:(NSDictionary *)dict;
+(Contact *)queryForName:(NSString *)name;
@end