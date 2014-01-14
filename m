Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41EBC7F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 20:24:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD76DAC002
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 18:24:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	g3TRb40VXx819rZR for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 18:24:17 -0800 (PST)
Date: Tue, 14 Jan 2014 13:24:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Message-ID: <20140114022414.GM3469@dastard>
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
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
To: Zachary Kotlarek <zach@kotlarek.com>
Cc: xfs@oss.sgi.com

T24gTW9uLCBKYW4gMTMsIDIwMTQgYXQgMDM6MDc6MzBQTSAtMDgwMCwgWmFjaGFyeSBLb3RsYXJl
ayB3cm90ZToKPiAKPiBPbiBKYW4gMTMsIDIwMTQsIGF0IDExOjI3IEFNLCBEYXZlIENoaW5uZXIg
PGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOgo+IAo+ID4gU28sIHlvdSBuZWVkIHRvIGZpbmQg
dGhlIGlub2RlIG51bWJlciBvZiBhIGRpcmVjdG9yeSB3aXRoIGEgY29ycnVwdAo+ID4gZW50cnks
IGFuZCBkdW1wIHRoZSBpbm9kZSBhbmQgYW55IGRhdGEgZm9yayBibG9ja3MgdGhhdCBpdCBiZWxv
bmdzCj4gPiB0byB3aXRoIHhmc19kYiBzaW1pbGFyIHRvIHdoYXQgeW91IGhhdmUganVzdCBkb25l
LiAKPiAKPiAKPiBHb3Qgb25lLiBidVs5XSBpcyB0aGUgZmlsZSB0aGF0IGRvZXNu4oCZdCB3b3Jr
OgouLi4uLgo+IGJ1WzldLmludW1iZXIgPSA2ODcxOTQ3ODgxNAo+IGJ1WzldLm5hbWVsZW4gPSAy
Ngo+IGJ1WzldLm5hbWUgPSAiMDcgLSBTZVwzMDNcMjYxb3IgTWFjaG8gU29sby5tNHYiCj4gYnVb
OV0udGFnID0gMHgxMzAKClRoYXQgbG9va3MgY29tcGxldGVseSB2YWxpZC4gSXQncyBhIHV0Zi04
IGVuY29kZWQgZGlyZWN0b3J5IGVudHJ5LgpJdCBkb2Vzbid0IGxvb2sgbGlrZSB0aGVyZSdzIGFu
eSBjb3JydXB0aW9uIG9uIGRpc2sgaGVyZS4KClRoZSBscyAtbCBvdXRwdXQgZnVsbCBvZiA/Pz8/
IHVzdWFsbHkgbWVhbnMgdGhlIHN0YXQgb2YgdGhlIGlub2RlCnRoZSBkaXJlbnQgcG9pbnRlZCB0
bywgc28gdGhhdCBpbXBsaWVzIHRoYXQgdGhlIHN0YXQgaGFzIGZhaWxlZC4KU28sIHdoYXQgZG9l
cyBhbmQgc3RyYWNlIG9mIHRoZSAnbHMgLWwnIG9mIHRoYXQgZGlyZWN0b3J5IHRlbGwgeW91CmFi
b3V0IHRoZSBkaXJlY3RvcnkgZW50cnkgdGhhdCBpcyByZXR1cm5lZCB0byB1c2Vyc3BhY2U/Cgo+
IGJsZWFmWzVdLmhhc2h2YWwgPSAweDE2ZDA3MDc0Cj4gYmxlYWZbNV0uYWRkcmVzcyA9IDB4MjYK
ClRoYXQncyB0aGUgaGFzaCBlbnRyeSBpbiB0aGUgZGlyZWN0b3J5IGZvciB0aGUgbmFtZS4gVGhh
dCBtYXkgYmUKd3JvbmcsIEkgZ3Vlc3MuIGNhbiB5b3UgY3JlYXRlIGFub3RoZXIgZmlsZSB3aXRo
IHRoZSBzYW1lIG5hbWUKaW4gYSBkaWZmZXJlbnQgZGlyZWN0b3J5IHNvIHdlIGNhbiBjaGVjayB0
aGF0IHRoZSBoYXNoIGlzIGNvcnJlY3Q/Cgo+IHUuYm14WzBdID0gW3N0YXJ0b2ZmLHN0YXJ0Ymxv
Y2ssYmxvY2tjb3VudCxleHRlbnRmbGFnXSAwOlswLDUwOTY5Niw3OTcwMCwwXQo+IAo+IEnigJlt
IG5vdCBzdXJlIGlmIHRoaXMgdGhlIHJpZ2h0IHdheSB0byBnZXQgdGhlIHJlbGF0ZWQgZmlyc3Qg
ZGF0YSBibG9jay4gSWYgSSBkaWQgaXQgd3JvbmcgbGV0IG1lIGtub3c6Cj4gCj4geGZzX2RiPiBk
YWRkciA1MDk2OTYKCmZzYiA1MDk2OTYsIG5vdCBkYWRkci4KCkNoZWVycywKCkRhdmUuCgotLSAK
RGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
