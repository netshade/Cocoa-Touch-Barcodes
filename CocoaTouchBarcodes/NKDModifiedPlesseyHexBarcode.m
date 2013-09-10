// -----------------------------------------------------------------------------------
//  NKDModifiedPlesseyHexBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 08 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDModifiedPlesseyHexBarcode.h"


@implementation NKDModifiedPlesseyHexBarcode
// -----------------------------------------------------------------------------------
-(NSString *)_encodeChar:(char)inChar
// -----------------------------------------------------------------------------------
{

    if (![[super _encodeChar:inChar] isEqual:@""])
        return [super _encodeChar:inChar];
    
    switch (inChar)
    {
        case 'A':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT, ONE_BIT, ZERO_BIT, ONE_BIT];
        case 'B':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT, ONE_BIT, ZERO_BIT, ONE_BIT];
        case 'C':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT, ZERO_BIT, ONE_BIT, ONE_BIT];
        case 'D':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT, ZERO_BIT, ONE_BIT, ONE_BIT];
        case 'E':
            return [NSString stringWithFormat:@"%@%@%@%@", ZERO_BIT, ONE_BIT, ONE_BIT, ONE_BIT];
        case 'F':
            return [NSString stringWithFormat:@"%@%@%@%@", ONE_BIT, ONE_BIT, ONE_BIT, ONE_BIT];
    }
    return @"";
}
@end
