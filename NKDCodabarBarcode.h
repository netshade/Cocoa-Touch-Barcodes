// -----------------------------------------------------------------------------------
//  NKDCodabarBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sun May 12 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDBarcode.h"
/*!
 @header NKDCodabarBarcode.h
 This concrete subclass of NKDBarcode implements the self-checking Codabar style barcode used
 by FedEx and in blood banks. It can encode 20 different characters - numeric digits 0-9, plus
 four start/stop characters (A, B, C, D), and 6 other common symbols
 */

/*!
 @class NKDCodabarBarcode
 @discussion Implementation of the Codabar barcode using 1:2 narrow to wide ratio.
 */
@interface NKDCodabarBarcode : NKDBarcode
{

}

/*!
 @method _encodeChar
 @abstract Private method to turn a single character into a string of 1s and 0s.
 @discussion Encodes characters according to Codabar's specification
 @result String of 0s and 1s representing inChar encoded for this barcode.
*/
-(NSString *) _encodeChar:(char)inChar;
@end
