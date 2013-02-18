// -----------------------------------------------------------------------------------
//  NKDPlanetBarcode.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sun May 05 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NKDPostnetBarcode.h"
/*!
 @header NKDPlanetBarcode.h

 This is a concrete subclass of NKDPostnetBarcode. Planet Barcode is in most respects identical to PostNet,
 but for the fact that the positions of the tall and short bars are reversed.

 Thanks to Daniel Paquette for contributing the initial version of NKDPlanetBarcode.
 */

@interface NKDPlanetBarcode : NKDPostnetBarcode
{

}

@end
