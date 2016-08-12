// -----------------------------------------------------------------------------------
//  NKDExtendedCode39Barcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 04 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDCode39Barcode.h"
/*!
 @header NKDExtendedCode39Barcode.h

 Extended Code 3 of 9 uses the same encoding scheme as its parent Code 3 of 9, but it utilizes two-character combinations
to expand the range of encodable characters to include lower-case alphabetical characters and more punctuation and diacriticals.
 This subclass of NKDCode39 implements this encoding scheme.
*/

/*!
 @class NKDExtendedCode39Barcode
 @discussion Extended Code 3 of 9 is the same encoding scheme as Code 3 of 9, except that it can encode a wider
             range of characters, including lower-case alphabetical characters by using two-character combinations
 
 */
@interface NKDExtendedCode39Barcode : NKDCode39Barcode
{

}
/*!
 @method initWithContent:printsCaption
 @abstract Overriden to perform under the uppercase that the parent class performs
 @param inContent Alphanumeric string to be encoded
 @param inPrints YES if caption should be printed
 @result Extended Code 3 of 9 Barcode object encoding the data passed in inContent
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;

/*!
 @method _encodeChar:
 @abstract Overridden to encode the extended character set; Super is called to encode the standard character set,
            with only the code necessary to create the two-character encoding additions to Code 3 of 9 specifications.
 @param inChar ASCII-8 Character to be encoded
 @result String of 0s and 1s represented the Code 39 encoding of content
*/
-(NSString *)_encodeChar:(char)inChar;

@end
