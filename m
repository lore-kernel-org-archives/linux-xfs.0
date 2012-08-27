Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R0Z866205134 for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 19:35:08 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Dj5B4UZU2Dzuhsx9 for <xfs@oss.sgi.com>;
	Sun, 26 Aug 2012 17:35:56 -0700 (PDT)
Date: Mon, 27 Aug 2012 10:35:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump: save & restore 32-bit projids
Message-ID: <20120827003555.GB13691@dastard>
References: <503ABD37.7090006@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <503ABD37.7090006@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Bill Kendall <wkendall@sgi.com>, =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWM=?=@oss.sgi.com, Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

T24gU3VuLCBBdWcgMjYsIDIwMTIgYXQgMDc6MjA6MDdQTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IEN1cnJlbnQgeGZzZHVtcC94ZnNyZXN0b3JlIG9ubHkgcmVjb2duaXplIHRoZSBsb3dl
ciAxNiBiaXRzIG9mIHRoZSBwcm9qaWQuCj4gV2l0aCB0aGlzIHBhdGNoLCB0aGUgZnVsbCAzMiBi
aXRzIGFyZSBkdW1wZWQgJiByZXN0b3JlZC4KPiAKPiBSZXBvcnRlZC1ieTogQm9yaXMgUmFudG8g
PGJyYW50b0ByZWRoYXQuY29tPgo+IENjOiBBcmthZGl1c3ogTWnFm2tpZXdpY3ogPGFyZWttQG1h
dmVuLnBsPgo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgU2FuZGVlbiA8c2FuZGVlbkByZWRoYXQuY29t
Pgo+IC0tLQo+IAo+IFRoaXMgYWxzbyBhZGRzIGEgZGVmaW5pdGlvbiBmb3IgYnNfZm9ya29mZiwg
YnV0IEkgZG9uJ3QgdGhpbmsKPiB0aGF0IGlzIHNvbWV0aGluZyB3aGljaCBzaG91bGQgZ2V0IHNh
dmVkICYgcmVzdG9yZWQsIGNvcnJlY3Q/CgpSaWdodCAtIGl0J3MgYSBrZXJuZWwgY29udHJvbGxl
ZCBmaWVsZCwgb25seSBleHBvcnRlZCBhcyBhIGhpbnQgdG8KaGVscCB4ZnNfZnNyIGJ1aWxkIHNp
bWlsYXJseSBmb3JtYXR0ZWQgaW5vZGVzLgoKPiBUQkggSSd2ZSBkb25lIHZlcnkgbGl0dGxlIGhh
Y2tpbmcgb24geGZzZHVtcC4gIEkgdGhpbmsgdGhpcwo+IHJlcXVpcmVzIGEgbmV3IHZlcnNpb24s
IGJ1dCBub3Qgc3VyZS4gIFRoaXMgc2VlbXMgdG8gd29yayBidXQKPiBtYXkgbmVlZCBzYW5pdHkg
Y2hlY2tzICYgZml4dXBzLiAgQW5kLCBvZiBjb3Vyc2UsIGFuIHhmc3Rlc3QuCgpMb29rcyBvaywg
YnV0IEknbSBpbiB0aGUgc2FtZSBib2F0IGFzIHlvdSBvbiB4ZnNkdW1wLiBBIFFBIHRlc3QKd291
bGQgYmUgZ29vZCB0byBnbyBhbG9uZyB3aXRoIHRoaXMuIDspCgpDaGVlcnMsCgpEYXZlLgotLSAK
RGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
