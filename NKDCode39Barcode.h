// -----------------------------------------------------------------------------------
//  NKDCode39Barcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDBarcode.h"
/*!
 @header NKDCode39Barcode.h
 @discussion This is a concrete subclass of NKDBarcode that implements the common Code 3 of 9
            barcode using a 2:1 wide to narrow ratio for bars and defaults to a
            12 mil bar width. Code 3 of 9 supports bars as narrow as 7.5 mils, but on many
            printers, due to ink bleed or toner jitter, 7.5 creates an un-scannable barcode
 */
/*!
 @class NKDCode39Barcode
 @abstract Concrete subclass of NKDBarcode that generated Code 3 of 9 (a/k/a Code 39) Barcodes.
 @discussion  Code 3 of 9 Barcode using a 2:1 wide to narrow ratio for bars and defaults to a
              12 mil bar width. Code 3 of 9 supports bars as narrow as 7.5 mils, but on many
              printers, due to ink bleed or toner jitter, 7.5 creates an un-scannable barcode
*/
@interface NKDCode39Barcode : NKDBarcode
{

}
/*!
 @method initWithContent:printsCaption
 @abstract Overriden to perform an uppercaseString on inContent - Code 3 of 9 supports alphanumeric
           but only upper case.
 @param inContent Alphanumeric string to be encoded
 @param inPrints YES if caption should be printed
 @result Code 3 of 9 Barcode object encoding the data passed in inContent
*/
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;

/*!
 @method _encodeChar:
 @abstract Overridden to encode characters according to Code 3 of 9 specifications.
 @param inChar ASCII-8 Character to be encoded
 @result String of 0s and 1s represented the Code 39 encoding of content
 */
-(NSString *)_encodeChar:(char)inChar;

/*!
 @method initiator
 @abstract Overridden to return the encoded start character for 3 of 9, an encoded asterick '*'
 @result String with the encoded version of the asterick character
 */
-(NSString *)initiator;
/*!
 @method terminator
 @abstract Overridden to return the encoded end character for 3 of 9, an encoded asterick '*'
 @result String with the encoded version of the asterick character
*/
-(NSString *)terminator;

/*!
 @method generateChecksum
 @abstract Generates code 3 of 9 check digit based on content
 @discussion Code 39's optional checksum is rarely used, but we'll provide the option here. It's a fairly
            simple algorithm - it's the sum of the value (via lookup table) of each character and doing a
            modulus 43 on the sum, storing the result as a character in the field checkDigit
 */
-(void)generateChecksum;
@end
