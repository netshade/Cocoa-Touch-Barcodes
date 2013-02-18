// -----------------------------------------------------------------------------------
// NSString-UPCEAN.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Thu May 30 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
/*!
 @header NSString-UPCEAN.h

 Adds two methods to NSString used for creating UPC and EAN barcodes.
 */

/*!
 @category NSString(UPCEAN)

 This category on NSString adds the instance methods needed by the various UPC and EAN barcode classes. Both of these methods were originally part of the NKDAbstractUPCEANBarcode class, but since they operate on NSStrings and never needs to be overridden, this seems a better fit, and also makes the code more readable
 */
@interface NSString (UPCEAN)

/*!
@method swapHandedness
@abstract Reverses encoded UPC or EAN character (represented as string of 0s and 1s) from left to right handed encoding - makes all bars gaps and all gaps bars
@discussion In UPC & EAN different parity is used for different digits to allow encoding of additional values. This assumes that <code>self</code> is a string of 0s and 1s representing the bars and gaps of an encoded EAN or UPC character.
@result String of 0s and 1s that is the polar opposite of inCode
*/
-(NSString *)swapHandedness;

/*!
@method swapParity
@abstract Swaps parity of encoded UPC or EAN character from even to Odd.
@discussion Assuming that parity concept is only used on the left hand side of EAN-13 and in EAN-8 and UPC-E. Right hand encoding for UPC-A and EAN-13 is always the same parity and UPC-A uses ODD_PARITY for all digits, so never has to call this. This assumes that <code>self</code> is a string of 0s and 1s representing the bars and gaps of an encoded EAN or UPC character.
@result String of 0s and 1s that is the opposite handed encoding of inCode
*/
-(NSString *)swapParity;

@end
