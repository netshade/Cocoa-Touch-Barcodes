// -----------------------------------------------------------------------------------
//  NKDModifiedPlesseyHexBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 08 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDModifiedPlesseyBarcode.h"
/*!
 @header NKDMOdifiedPlesseyHexBarcode

 This is an extension of the Plessey code. The Plessey specification sets out the encoding scheme for
 numeric data, but leaves the other bar combinations open. This is the most common use of the open
 combinations - to encode the letters A through F, allowing the use of Hex notation to represent 0-255
 in a two character combination.

 <CENTER><HR>
 THIS IS NOT GUARANTEED TO PRODUCE A BARCODE THAT IS IN COMPLIANCE WITH THE SPECIFICATION.<BR>
 == USE AT YOUR OWN RISK ==
 <HR></CENTER>

 */
@interface NKDModifiedPlesseyHexBarcode : NKDModifiedPlesseyBarcode
{

}
/*!
 @method _encodeChar:
 @abstract Extends character set by encoding alphabetical characters 'A' through 'F', otherwise, passes the
            value up to its superclass, NKDModifiedPlesseyBarcode
 @result String of 0s and 1s representing encoded data
 */
-(NSString *)_encodeChar:(char)inChar;
@end
