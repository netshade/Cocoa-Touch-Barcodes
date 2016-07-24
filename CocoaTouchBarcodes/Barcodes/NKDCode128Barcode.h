// -----------------------------------------------------------------------------------
//  NKDCode128Barcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sat May 11 2002.
//  �2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDBarcode.h"
/*!
 @header NKDCode128Barcode.h

 This concrete subclass of NKDBarcode handles one of the more complex encoding schemes - Code 128, which is
 capable of encoding the entire ASCII-7 character set. It uses three "code sets" which can be switched
 between by using control characters.

 Code A allows the encoding of upper-case alphanumeric characters and non-printing characters such as ACK, and ESC,
 Code B has upper and lower case alphanumerics, and Code C is encodes numeric data packed in two digits per character,
 making Code 128 a very useful barcode because it both offers a complete character set AND offers a very compact encoding
 scheme, especially for numeric data.
 */

/*!
 @typedef CodeSet
 @discussion Defines a type of CodeSet (as an Int) to make methods that take one of the precompiler defined set values
            more readable.
 */
typedef int CodeSet;
/*!
 @defined SET_A
 @discussion Used to designate that we are using Code Set A, shifting to B or C if necessary
 */
#define SET_A 0

/*!
 @defined SET_B
 @discussion Used to designate that we are using Code Set B, shifting to A or C if necessary
 */
#define SET_B 1

/*!
 @defined SET_C
 @discussion Used to designate that we are using Code Set A. With our current algorithm, we won't be shifting to
            A or B, but at some point, our initiator routine should look for situations where most (but not all)
            of the characters are numbers and Set C with shifting to one of the other sets still results in a shorter
            encoding, however this will involve more than just changing the algorithm to determine the primary set, since
            SET_C processes two charactes at a time and this framework is primarily focused on the individual encoding of
            characters. That behavior is not immutable - it is overridden in the Interleaved Two of Five class, but overriding
            this behavior for part, but not all, of <i>content</i> presents several challenges.
 */
#define SET_C 2

/*!
 @class NKDCode128Barcode
 @abstract Concrete subclass for creating CODE-128 barcodes.
 */
@interface NKDCode128Barcode : NKDBarcode
{
    int		codeSet;
}
/*!
 @method initWithContent:printsCaption:
 @abstract Overridden to enforce generation of check digit.
 */
-(id)initWithContent: (NSString *)inContent
       printsCaption: (BOOL)inPrints;

/*!
 @method codeSet
 @abstract Returns the primary code set being used to encode content
 @result SET_A, SET_B, or SET_C
 */
-(CodeSet)codeSet;

/*!
 @method setCodeSet:
 @abstract Set the primary code set to encode content with
 @param inSet SET_A, SET_B, or SET_C
 */
-(void)setCodeSet:(CodeSet)inSet;

/*!
 @method generateChecksum
 @abstract Generates the check digit or checksum for this barcode encoding scheme.
 @discussion Code 128 has a mandatory check digit calculated by summing the start code
            value to the product of each character's value (via lookup table), modulus 103.
*/
-(void)generateChecksum;

/*!
 @method initiator
 @abstract Returns the encoded initiator or alignment bar(s)
 @discussion This is likely the most complex initator method in the framework. Because there are three code sets to
                choose from, we have to determine which one is the best choice for our content. Our algorithm will be
                to check first to see if there are only numbers, then we use set C. If there are other characters, we
                will sum the number of lower-case letters and the number of non-printing ASCII characters. If there are
                more lowercase letters than non-printings, we will use set B, otherwise, we will use set C.
*/
-(NSString *)initiator;

/*!
 @method terminator
 @abstract Returns the encoded terminator or alignment bar(s)
 @discussion Returns  1100011101011
@result String of 0s and 1s representing the last (non-content) character or alignment bar(s).
*/
-(NSString *)terminator;

/*!
@method _encodeChar
@abstract Private method to turn a single character into a string of 1s and 0s.
@discussion This method is overridden to make sure the current
@result String of 0s and 1s representing inChar encoded for this barcode.
*/
-(NSString *)_encodeChar:(char)inChar;

/*!
 @method _encodeNumberPair:
 @abstract Encodes a two-digit numeric value as a code-set C Code 128 value.
 @discussion Two digit numeric values when encoding using code set C coincide with the character "value" according to Code 128,
             so this method is much more useful than for just encoding for set-C, it also gives us a shortcut when calculating
             the check-digit and when trying to encode it.
 @param inPair String with length of two that holds the string representation of the two-digit number to be encoded.
 @result String of 0s and 1s representing the number pair.
 */
-(NSString *)_encodeNumberPair:(NSString *)inPair;

/*!
 @method _canEncodeChar:withSet:
 @abstract Tells us whether a particular code set can encode a given character
 @param inChar Character that we want to know whether it can be encoded
 @param theSet The code set we want to try and encode it with
 @result YES or NO, depending on whether theSet can encode inChar
 */
-(BOOL)_canEncodeChar:(char)inChar withSet:(CodeSet)theSet;

/*!
 @method _bestCodeSetForContent
 @abstract Method provides a common algorithm for determining the best primary code set for <i>content</i>
 @result SET_A, SET_B, SET_C, whichever was determined to be the best choice based on the data in <i>content</i>
 */
-(CodeSet)_bestCodeSetForContent;

/*!
 @method _shiftCharacterForSet:(CodeSet)inSet
 @abstract Returns the shift character for a given set
 @param inSet The CodeSet that we wish the shift character for.
 @result A String of 1s and 0s that contains the encoded shift character.
 */
-(NSString *)_shiftCharacterForSet:(CodeSet)inSet;

/*!
 @method _encodeChar: withSet:
 @abstract Called by _encodeChar once the character set to use has been determined.
 @param inChar The character to be encoded.
 @param inSet The CodeSet to use to encode it.
 @result String of 0s and 1s representing the character encoded using inSet.
 */
-(NSString *)_encodeChar:(char)inChar withSet:(CodeSet)inSet;

/*!
 @method barcode:
 @abstract Overridden to process sets of two characters when using SET_C as primary set, since it packs two characters into one
 @result String of 0s and 1s representing the content.
*/
-(NSString *)barcode;

/*!
 @method _valueForChar:
 @abstract Returns the code-128 value for a given character
 @discussion Used for calculating checksum for code sets A and B, where the numeric code-128 "value" is arbitrary
 @result Integer between 00 and 105
 */
-(int)_valueForChar:(int)inChar;
@end
