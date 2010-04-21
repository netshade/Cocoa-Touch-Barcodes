//
//  JapanPostBarcode.h
//  BarcodePod
//
//  Created by 佐藤 昭 on Mon Jun 30 2003.
//  Copyright (c) 2003 SatoAkira. All rights reserved.
//
// 基本的に4ステイト3バー。数字と制御コードは3本のバーで1つのキャラクタ。大文字A~Zは制御コード+数字で1つのキャラクタ。スタートコード(STC)、ストップコード(SPC)は2本のバー。スタートコード(1)+郵便番号(7)+住居表示番号(13)+チェックデジット(1)+ストップコード(1)。郵便番号のハイフンは削除する。0で右側の不足分を埋める。住居表示番号は右側の不足分をCC4制御コードで埋める。英字は2つに数えるので13個目が制御コードのときは中途半端になる。バー幅は0.6mm。黒バーの間隔は1.2mmなので、(2 + (7+13+1) * 3 + 1) * 1.2 = 79.2mmが最初のバー中心から最後のバー中心までの長さになる。基準線の間隔は1.2mm。合計3.6mmになるので10ポイント相当になる。なお、この設定は10ポイントに設定したときの値である。8.5ポイントから11.5ポイントまで許容されているので、全数値を0.85から1.15の範囲で乗じても良い。 //

#import <Foundation/Foundation.h>
#import "NKDBarcode.h"

@interface JapanPostBarcode : NKDBarcode {
	@private
	NSString *japanpostContents;
}

- (NSString *)japanpostContents;

@end
