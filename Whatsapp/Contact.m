//
//  Contact.m
//  Whatsapp
//
//  Created by Magneto on 2/12/16.
//  Copyright © 2016 HummingBird. All rights reserved.
//

#import "Contact.h"
#import "LocalStorage.h"

@implementation Contact

+(Contact *)contactFromDictionary:(NSDictionary *)dict
{
    Contact *contact = [[Contact alloc] init];
    contact.name = dict[@"name"];
    contact.identifier = dict[@"id"];
    contact.image_id = dict[@"image_id"];
    return contact;
}
-(BOOL)hasImage
{
    return ![self.image_id isEqualToString:@""];
}
-(void)save
{
    [LocalStorage storeContact:self];
}

@end
