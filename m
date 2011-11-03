Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3KLMLH051543 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 15:21:22 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ADAE1CE098E
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 13:21:21 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id EAYp2VpDBXsBBYLc
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 13:21:21 -0700 (PDT)
Received: by faai28 with SMTP id i28so2074705faa.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 13:21:20 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: xfs_repair fails with corrupt dinode 17491441757, extent total = 1,
	nblocks = 0.  This is a bug.
Date: Thu, 3 Nov 2011 21:21:16 +0100
References: <201110311156.20421.arekm@maven.pl>
	<201111031157.39179.arekm@maven.pl>
	<20111103110306.GA8382@infradead.org>
In-Reply-To: <20111103110306.GA8382@infradead.org>
MIME-Version: 1.0
Message-Id: <201111032121.16891.arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

T24gVGh1cnNkYXkgMDMgb2YgTm92ZW1iZXIgMjAxMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6
Cj4gT24gVGh1LCBOb3YgMDMsIDIwMTEgYXQgMTE6NTc6MzhBTSArMDEwMCwgQXJrYWRpdXN6IE1p
Pz9raWV3aWN6IHdyb3RlOgo+ID4gPiBJbiB0aGUgbWVhbnRpbWUgaXMgdGhlcmUgYW55IGNoYW5j
ZSB5b3UgY291bGQgc2VuZCB0aGUgb3V0cHV0IG9mCj4gPiA+IAo+ID4gPiAJeGZzX3JlcGFpciAt
biAtdnYgLW0gMQo+ID4gPiAKPiA+ID4gZm9yIHRoaXMgZmlsZXN5c3RlbT8KPiA+IAo+ID4gV2ls
bCBzdWNoIHJlcGFpciBkb25lIG9uIG1ldGFkdW1wZWQgJiByZXN0b3JlZCBpbWFnZSBiZSBlbm91
Z2ggZm9yIHlvdT8KPiAKPiBZZXMuCj4gCj4gSSBhbHNvIGxvb2tlZCBhdCB0aGUgbWVtb3J5IGhl
dXJpc3RpY3MgYW5kIGZvdW5kIHNvbWUgZmFpcmx5IG9idmlvdXMKPiBmbGF3cy4gIEknbGwgaGF2
ZSBzb21lIHRlc3QgcGF0Y2hlcyBmb3IgeW91IEFTQVAuCgojIExDX0FMTD1DIC4veGZzX3JlcGFp
ciAtdnYgLW0gMSAvZGV2L3ZnX3N5cy9sdl9zdG9yYWdlMQpQaGFzZSAxIC0gZmluZCBhbmQgdmVy
aWZ5IHN1cGVyYmxvY2suLi4KICAgICAgICAtIG1heF9tZW0gPSAxMDI0LCBpY291bnQgPSA5NzQ5
NTc0NCwgaW1lbSA9IDM4MDg0MiwgZGJsb2NrID0gCjE4ODQ3NTI4OTYsIGRtZW0gPSA5MjAyODkK
UmVxdWlyZWQgbWVtb3J5IGZvciByZXBhaXIgaXMgZ3JlYXRlciB0aGF0IHRoZSBtYXhpbXVtIHNw
ZWNpZmllZAp3aXRoIHRoZSAtbSBvcHRpb24uIFBsZWFzZSBpbmNyZWFzZSBpdCB0byBhdCBsZWFz
dCAxMzE5LgoKCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3ogICAgICAgIFBMRC9MaW51eCBUZWFt
CmFyZWttIC8gbWF2ZW4ucGwgICAgICAgICAgICBodHRwOi8vZnRwLnBsZC1saW51eC5vcmcvCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
