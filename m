Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 817A67F3F
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2014 17:01:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2D1AAC005
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2014 15:01:45 -0700 (PDT)
Received: from mail-we0-f170.google.com (mail-we0-f170.google.com
	[74.125.82.170]) by cuda.sgi.com with ESMTP id inD6njpAhqMa1Eo3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 28 Jun 2014 15:01:40 -0700 (PDT)
Received: by mail-we0-f170.google.com with SMTP id w61so6468753wes.1
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2014 15:01:39 -0700 (PDT)
Received: from t400.localnet (89-65-189-48.dynamic.chello.pl. [89.65.189.48])
	by mx.google.com with ESMTPSA id
	jv9sm30405347wjc.28.2014.06.28.15.01.38 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sat, 28 Jun 2014 15:01:39 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: xfs_repair 3.2.0 cannot (?) fix fs
Date: Sun, 29 Jun 2014 00:01:38 +0200
References: <201406280141.54350.arekm@maven.pl>
	<201406282352.56431.arekm@maven.pl>
In-Reply-To: <201406282352.56431.arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201406290001.38493.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

T24gU2F0dXJkYXkgMjggb2YgSnVuZSAyMDE0LCBBcmthZGl1c3ogTWnFm2tpZXdpY3ogd3JvdGU6
Cj4gT24gU2F0dXJkYXkgMjggb2YgSnVuZSAyMDE0LCBBcmthZGl1c3ogTWnFm2tpZXdpY3ogd3Jv
dGU6Cj4gPiBIZWxsby4KPiA+IAo+ID4gSSBoYXZlIGEgZnMgKG1ldGFkdW1wIG9mIGl0Cj4gPiBo
dHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJla20vcDIveDEvd2ViMi1ob21lLm1ldGFkdW1w
Lmd6KQo+ID4gdGhhdCB4ZnNfcmVwYWlyIDMuMi4wIGlzIHVuYWJsZSB0byBmaXggcHJvcGVybHku
Cj4gPiAKPiA+IFJ1bm5pbmcgeGZzX3JlcGFpciBmZXcgdGltZXMgc2hvd3MgdGhlIHNhbWUgZXJy
b3JzIHJlcGVhdGluZzoKPiA+IGh0dHA6Ly9peGlvbi5wbGQtbGludXgub3JnL35hcmVrbS9wMi94
MS9yZXBhaXIyLnR4dAo+ID4gaHR0cDovL2l4aW9uLnBsZC1saW51eC5vcmcvfmFyZWttL3AyL3gx
L3JlcGFpcjMudHh0Cj4gPiBodHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJla20vcDIveDEv
cmVwYWlyNC50eHQKPiA+IGh0dHA6Ly9peGlvbi5wbGQtbGludXgub3JnL35hcmVrbS9wMi94MS9y
ZXBhaXI1LnR4dAo+ID4gCj4gPiAocmVwYWlyMS50eHQgYWxzbyBleGlzdHMgLSBpdCB3YXMgaW5p
dGlhbCwgdmVyeSBiaWcvbG9uZyByZXBhaXIpCj4gPiAKPiA+IE5vdGUgdGhhdCBmcyBtb3VudHMg
ZmluZSAoYW5kIHdhcyBtb3VudGluZyBmaW5lIGJlZm9yZSBhbmQgYWZ0ZXIgcmVwYWlyKQo+ID4g
YnV0IHhmc19yZXBhaXIgaW5kaWNhdGVzIHRoYXQgbm90IGV2ZXJ5dGhpbmcgZ290IGZpeGVkLgo+
ID4gCj4gPiAKPiA+IFVuZm9ydHVuYXRlbHkgdGhlcmUgbG9va3MgdG8gYmUgYSBwcm9ibGVtIHdp
dGggbWV0YWR1bXAgaW1hZ2UuIHhmc19yZXBhaXIKPiA+IGlzIGFibGUgdG8gZmluaXNoIGZpeGlu
ZyBvbiBhIHJlc3RvcmVkIGltYWdlIGJ1dCBpcyBub3QgYWJsZSAoc2VlCj4gPiByZXBhaXJYLnR4
dCkgYWJvdmUgb24gcmVhbCBkZXZpY2VzLiBIdWg/Cj4gCj4gTWFkZSB4ZnMgbWV0YWR1bXAgd2l0
aG91dCBmaWxlIG9iZnVzY2F0aW9uIGFuZCBJJ20gYWJsZSB0byByZXByb2R1Y2UgdGhlCj4gcHJv
YmxlbSByZWxpYWJseSBvbiB0aGUgaW1hZ2UgKGlmIHNvbWUgeGZzIGRldmVsb3BlciB3YW50cyBt
ZXRhZHVtcCBpbWFnZQo+IHRoZW4gcGxlYXNlIG1haWwgbWUgLSBJIGRvbid0IHdhbnQgdG8gcHV0
IGl0IGZvciBldmVyeW9uZSBkdWUgdG8gb2J2aW91cwo+IHJlYXNvbnMpLgoKRm9yZ290IHRvIG1l
bnRpb24gYWJvdXQgbmV3IHByb2JsZW0uIEFmdGVyIHJ1bm5pbmcgeGZzX3JlcGFpciAocmVwcm9k
dWNpYmxlIG9uIApyZWFsIGZzIGFuZCBvbiBtZXRhZHVtcCkgYW5kIHRyeWluZyB0byBtb3VudCBm
czoKClszNTcxMzY3LjcxNzE2N10gWEZTIChsb29wMCk6IE1vdW50aW5nIEZpbGVzeXN0ZW0KWzM1
NzEzNjcuODgzOTU4XSBYRlMgKGxvb3AwKTogRW5kaW5nIGNsZWFuIG1vdW50ClszNTcxMzY3Ljkw
MDczM10gWEZTIChsb29wMCk6IEZhaWxlZCB0byBpbml0aWFsaXplIGRpc2sgcXVvdGFzLgoKRmls
ZXMgYXJlIGFjY2Vzc2libGUgZXRjLiBKdXN0IG5vIHF1b3RhLiBVbmZvcnR1bmF0ZWx5IG5vIGlu
Zm9ybWF0aW9uIHdoeSAKaW5pdGlhbGl6YXRpb24gZmFpbGVkLgoKU28geGZzX3JlcGFpciB3YXNu
J3QgYWJsZSB0byBmaXggdGhhdCwgdG9vLgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiwgYXJl
a20gLyBtYXZlbi5wbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
