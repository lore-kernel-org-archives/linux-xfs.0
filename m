Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 28CF47F4E
	for <linux-xfs@oss.sgi.com>; Thu, 31 Jan 2013 14:24:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 071D930406B
	for <linux-xfs@oss.sgi.com>; Thu, 31 Jan 2013 12:24:54 -0800 (PST)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id b8bk6TKeC1DXGjNi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 31 Jan 2013 12:24:52 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1U10gz-0005TZ-Vv
	for linux-xfs@oss.sgi.com; Thu, 31 Jan 2013 21:25:06 +0100
Received: from lougher.demon.co.uk ([80.177.127.218])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 31 Jan 2013 21:25:05 +0100
Received: from plougher by lougher.demon.co.uk with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 31 Jan 2013 21:25:05 +0100
From: Phillip Lougher <plougher@redhat.com>
Subject: Re: Volume fine on =?utf-8?b?eDg2XzY0LA==?= corruption on ARM
Date: Thu, 31 Jan 2013 20:19:20 +0000 (UTC)
Message-ID: <loom.20130131T205839-735@post.gmane.org>
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<5106FDA5.80409@sandeen.net>
	<20130128224013.GK2287@vicerveza.homeunix.net>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

TGx1w61zIEJhdGxsZSBpIFJvc3NlbGwgPHZpcmljIDxhdD4gdmlyaWMubmFtZT4gd3JpdGVzOgoK
PiAKPiBPbiBNb24sIEphbiAyOCwgMjAxMyBhdCAwNDozNzoyNVBNIC0wNjAwLCBFcmljIFNhbmRl
ZW4gd3JvdGU6Cj4gPiBTbyB0aGlzIHdhcyB0cnlpbmcgdG8gcmVhZCBhIGRpcjIgZGlyZWN0b3J5
IG1ldGFkYXRhIGxlYWYgYmxvY2ssIGFuZCBpdAo+ID4gZGlkbid0IGZpbmQgdGhlIHJpZ2h0IG1h
Z2ljLgo+ID4gWEZTQiBpcyBzdXBlcmJsb2NrIG1hZ2ljIC4gLiAuIAo+ID4gCj4gPiBJIHRlc3Rl
ZCBhbiBpbWFnZSB3aGljaCAoSSB0aGluaykgY29udGFpbnMgZXZlcnkgZGlyMiBmb3JtYXQsIGNy
ZWF0ZWQgb24KPiA+IHg4Nl82NCAodW5kZXIgYSBSSEVMNiAzLjIga2VybmVsKSBhbmQgY2hlY2tl
ZCBpdCBvbiBBUk0gKGEgcmFzcGJlcnJ5IHBpCj4gPiAzLjIuMjQga2VybmVsKSBzbyBpdCdzIG5v
dCByZWFsbHkgcXVpdGUgYW4gYXBwbGVzIHRvIGFwcGxlcyB0ZXN0Lgo+ID4gCj4gPiBEb2VzIHRo
ZSBmaWxlc3lzdGVtIGNoZWNrIGNsZWFuIG9uIHg4Nl82NCByaWdodCBhZnRlciB5b3UgY3JlYXRl
IGl0Pwo+ID4gSG93IGRpZCB5b3UgY3JlYXRlIGl0Pwo+IAo+IFRoYW5rIHlvdSBmb3IgdGVzdGlu
ZyEgWW91IG1lYW4gdGhhdCB5b3VyIHRlc3Qgd2VudCBmaW5lLCByaWdodD8KCj4gCj4gSSBydW46
Cj4gbWtmcy54ZnMgL2Rldi9zZGIxCj4gCj4gVGhlbiBJIGNvcGllZCBmaWxlcyB0byBpdC4gQWZ0
ZXIgdGhlIGZpcnN0IGNyYXNoIGluIHRoZSBhcm0sIEkgdXNlZAo+PiB4ZnNfcmVwYWlyIG9uIHRo
ZQo+IHg4Nl82NC4gSXQgY3JlYXRlZCBtYW55IGxvc3QrZm91bmQuIFRoZW4gSSB0cmllZCBhZ2Fp
biBpbiB0aGUgQVJNLCBhbmQgaXQKPiBjcmFzaGVkIGFnYWluIHRoZSBzYW1lIHdheS4KCkkgaGF2
ZSB0cmllZCB0byByZXByb2R1Y2UgdGhpcyB1c2luZyBhbiBhcm12NXRlbCBhcmNoIChxZW11IGVt
dWxhdGlvbiksCnJ1bm5pbmcgYSBzdG9jayAzLjcuMyBrZXJuZWwuICBUaGUgdGVzdCBpbWFnZSB3
YXMgY3JlYXRlZCBvbiB4ODZfNjQgd2l0aAphIHN0b2NrIDMuNy4zIGtlcm5lbCwgYW5kIHRoZSB0
ZXN0IGltYWdlIHRoZW4gYm9vdGVkIGFzIHRoZSByb290ZnMgb24gdGhlCkFSTSBzeXN0ZW0uCgpO
byBjb3JydXB0aW9uIG9mIHRoZSBmaWxlc3lzdGVtIG9jY3VycmVkIG9uIHRoZSBBUk0sIGV2ZW4g
d2l0aApwYXJhbGxlbCBmaWxlIHdyaXRlcy9tb3ZlcyB0byAnZW5jb3VyYWdlJyB0aGUgYnVnIHRv
IGFwcGVhci4KVGhlIHVubW91bnRlZCBmaWxlc3lzdGVtIGNoZWNrZWQtb3V0IE9LIG9uIHRoZSB4
ODZfNjQgdXNpbmcKeGZzX2NoZWNrLgoKSXMgdGhlcmUgc29tZSBtaXNzaW5nIGluZm9ybWF0aW9u
IGhlcmUgb3IgYWRkaXRpb25hbCBhY3Rpb25zIG5lZWRlZCB0bwp0cmlnZ2VyIHRoaXMgYnVnPwoK
VGhhbmtzCgpQaGlsbGlwCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
