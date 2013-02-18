// -----------------------------------------------------------------------------------
//  NKDPlanetBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sun May 05 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDPlanetBarcode.h"


@implementation NKDPlanetBarcode
// -----------------------------------------------------------------------------------
-(float)_heightForDigit:(int)index
                andBar:(int)bar
// -----------------------------------------------------------------------------------
{
	return ([super _heightForDigit:index andBar:bar] == TALL_BAR) ? SHORT_BAR : TALL_BAR;
}
@end
