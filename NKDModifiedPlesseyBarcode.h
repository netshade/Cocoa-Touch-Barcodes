// -----------------------------------------------------------------------------------
//  NKDModifiedPlesseyBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Tue May 07 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDBarcode.h"
/*!
 @header NKDBarcode

  This is an encoder for the Plessey Code. According to the Plessy Code
  Specification, numeric digits are assigned a set value, but the remaining values
  can be used for whatever values are desired. This subclass adds the ability
  to encode the letters A through F for full hexadecimal support.

                <CODE>Wide bar followed by narrow space is a "1" bit.<BR>
 		Narrow bar followed by wide space is a "O" bit.</CODE>
 
  We will use a 3:1 wide to narrow bar ratio.
 
<CENTER><HR>
    THIS IS NOT GUARANTEED TO PRODUCE A BARCODE THAT IS IN COMPLIANCE WITH THE SPECIFICATION.<BR>
                           == USE AT YOUR OWN RISK ==
<HR></CENTER>

 */

/*!
 @defined ONE_BIT
 @discussion Plessey encodes data in binary form. A '1' is encoded as a wide bar followed by
            a narrow space. For this framework, this is represented by the string "1110"
 */
#define ONE_BIT @"1110"

/*!
 @defined ZERO_BIT
 @discussion Plessey encodes data in binary form. A '0' is encoded as a narrow bar followed by
        a wide space. For this framework, this is represented by the string "1000"
 */
#define ZERO_BIT @"1000"

/*!
 @class NKDModifiedPlesseyBarcode
 @abstract Plessey barcode object.
 @discussion This is an encoder for the Plessey Code. According to the Plessy Code 
    Specification, numeric digits are assigned a set value, but the remaining values
    can be used for whatever values are desired. This base object supports only the
    encoding of digits. The ModifiedPlesseyHexEncoder subclass adds the ability
    to encode the letters A through F for full hexadecimal support.
 
 		Wide bar following by narrow space is a "1" bit. 
 		Narrow bar followed by wide space is a "O" bit. 
 
    This class uses a 3:1 wide to narrow bar ratio.
*/
@interface NKDModifiedPlesseyBarcode : NKDBarcode
{

}
/*!
 @method initWithContent:printsCaption
 @abstract Initializes new barcode object with provided data and specifies whether a caption should be printed
 below the barcode. This overridden initialization routine sets the bar width to .1, yielding a .3 wide bar dize.
 @param inContent A string containing the data to be encoded; should use only <B>ASCII-8</B> characters
 (those that can be encoded using a single char in UTF-8)
 @param inPrints YES if caption should print.
 @result Returns initialized NKDBarcode class
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;
/*!
@method _encodeChar:
 @abstract Overridden to provide correct encoding of numeric data.
 @result String of 1s and 0s representing the encoded content
 */
-(NSString *)_encodeChar:(char)inChar;

/*!
 @method initiator
 @abstract Returns the encoded initiator or alignment bar(s)
 @discussion Returns encoded string representing the left most character which is Binary ONE_BIT
            ONE_BIT ZERO_BIT ONE_BIT
 @result String of 0s and 1s representing the first (non-content) character or alignment bar(s).
*/
-(NSString *)initiator;

/*!
 @method terminator
 @abstract Returns the encoded terminator or alignment bar(s)
 @discussion Returns encoded string representing the right-most character.  We'll use a single thick bar so that our
            code can be scanned left-to-right or right-to-left. The thick bar is followed by the  reverse-start symbol, '1100' 
            backwards, or '0011'
 @result String of 0s and 1s representing the last (non-content) character or alignment bar(s).
    */
-(NSString *)terminator;

/*!
 @method generateChecksum
 @abstract Generates the check digit or checksum for this barcode encoding scheme.
 @discussion ***TO DO: The MODIFIED Plessey check digit is calculated by using the following steps. 
 
        -Starting from the units position, create a new number with all of 
                the odd position digits in their original sequence. 
        -Multiply this new number by 2. 
        -Add all of the digits of the product from step two. 
        -Add all of the digits not used in step one to the result in step three. 
        -Determine the smallest number which when added to the result in step four 
                will result in a multiple of 10. This is the check character. 
 
*/
-(void)generateChecksum;
@end
