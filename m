Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LJ7QtB168549 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 14:07:26 -0500
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: xfstests 258: Test xfs fs creation with fs size close to 4 TB
Date: Wed, 21 Sep 2011 21:06:47 +0200
References: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
	<1316624075.2986.22.camel@doink>
In-Reply-To: <1316624075.2986.22.camel@doink>
MIME-Version: 1.0
Message-Id: <201109212106.48084.arekm@maven.pl>
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
To: xfs@oss.sgi.com, aelder@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Sandeen <sandeen@redhat.com>, Eric@oss.sgi.com, Boris Ranto <branto@redhat.com>

T24gV2VkbmVzZGF5IDIxIG9mIFNlcHRlbWJlciAyMDExLCBBbGV4IEVsZGVyIHdyb3RlOgo+IE9u
IFdlZCwgMjAxMS0wOS0yMSBhdCAxNTo1MiArMDIwMCwgQm9yaXMgUmFudG8gd3JvdGU6Cj4gPiBt
a2ZzLnhmcyBmYWlsZWQgdG8gY3JlYXRlIHhmcyBmaWxlc3lzdGVtcyB3aXRoIDQgVEIgbWludXMg
ZmV3IGJ5dGVzIGR1ZQo+ID4gdG8gcm91bmQgdXAgZXJyb3IgaW4gbWtmcy54ZnMgY29kZS4KPiA+
IAo+ID4gVGhpcyB0ZXN0IGNhc2UgaXMgYSByZWdyZXNzaW9uIHRlc3QgZm9yIHRoZSBmcyBjcmVh
dGlvbiBwcm9ibGVtLgo+ID4gCj4gPiBJJ3ZlIHRlc3RlZCB0aGUgdGVzdCBjYXNlIHdpdGggbWtm
cy54ZnMgcGF0Y2ggKGluIHRoZSBmb3JtIHBvc3RlZCBieQo+ID4gRXJpYyBTYW5kZWVuKSBhbmQg
dGhlIHRlc3QgcGFzc2VkIChhbmQgdGhlcmVmb3JlIHRoZSBwYXRjaCBmaXhlZCB0aGUKPiA+IGlz
c3VlIGZvciBtZSkuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IEJvcmlzIFJhbnRvIDxicmFudG9A
cmVkaGF0LmNvbT4KPiAKPiBUaGlzIGxvb2tzIE9LLCBidXQgSSdtIGEgbGl0dGxlIGNvbmNlcm5l
ZCBhYm91dCB0aGUKPiBzaGVsbCdzIGFiaWxpdHkgdG8gaGFuZGxlID4gMzItYml0IHZhbHVlcyBp
biBpdHMKPiBhcml0aG1ldGljIGV4cHJlc3Npb25zICh3aXRoaW4gJCgoLi4uKSkpLgo+IAo+IFVz
aW5nICR7Zm91cnRifSB3b3JrcyBmb3IgbWUsIGJ1dCBJIGp1c3QgZG9uJ3Qga25vdwo+IHdoZXRo
ZXIgaXQgaXMgd3JpdHRlbiBzb21ld2hlcmUgdGhhdCBiYXNoIGFsd2F5cwo+IHN1cHBvcnRzIDY0
LWJpdCAob3IgZXZlbiBhcmJpdHJhcnkpIHByZWNpc2lvbiB2YWx1ZXMuCgpJIGNhbiBzYXkgb25s
eSB0aGF0IGJhc2hpem0gc3V4LiBwb3NpeCBzaGVsbCB1bmZvcnR1bmF0ZWx5IG1ha2VzIHByb2Js
ZW1zIApoZXJlLgoKbWtzaCAoaHR0cHM6Ly93d3cubWlyYnNkLm9yZy9ta3NoLmh0bSkgc3VwcG9y
dHMgMzJiaXQgYXJpdGhtZXRpYyBvbmx5IChldmVuIG9uIAo2NGJpdCBhcmNoKS4KCnNpbmdsZSB1
bml4IHNwZWMgc2F5cyAic2lnbmVkIGxvbmciLCBzbyB5b3UgY2Fubm90IHJlbHkgb24gcG9zaXgg
c2hlbGwgZm9yID4gCjMyYml0IHZhbHVlcy4KCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3ogICAg
ICAgIFBMRC9MaW51eCBUZWFtCmFyZWttIC8gbWF2ZW4ucGwgICAgICAgICAgICBodHRwOi8vZnRw
LnBsZC1saW51eC5vcmcvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
