Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3UEEp5E123692 for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 09:14:51 -0500
Date: Sat, 30 Apr 2011 16:18:10 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110430161810.6ccd2c99@neptune.home>
In-Reply-To: <20110429213524.449e003b@neptune.home>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110429151841.GA893@x4.trippels.de>
	<20110429213524.449e003b@neptune.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>

T24gRnJpLCAyOSBBcHJpbCAyMDExIEJydW5vIFByw6ltb250IHdyb3RlOgo+IE9uIEZyaSwgMjkg
QXByaWwgMjAxMSBNYXJrdXMgVHJpcHBlbHNkb3JmIHdyb3RlOgo+ID4gT24gMjAxMS4wNC4yOSBh
dCAxMToxOSArMTAwMCwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+ID4gPiBPSywgc28gdGhlIGNvbW1v
biBlbGVtZW50cyBoZXJlIGFwcGVhcnMgdG8gYmUgcm9vdCBmaWxlc3lzdGVtcwo+ID4gPiB3aXRo
IHNtYWxsIGxvZyBzaXplcywgd2hpY2ggbWVhbnMgdGhleSBhcmUgdGFpbCBwdXNoaW5nIGFsbCB0
aGUKPiA+ID4gdGltZSBtZXRhZGF0YSBvcGVyYXRpb25zIGFyZSBpbiBwcm9ncmVzcy4gRGVmaW5p
dGVseSBzZWVtcyBsaWtlIGEKPiA+ID4gcmFjZSBpbiB0aGUgQUlMIHdvcmtxdWV1ZSB0cmlnZ2Vy
IG1lY2hhbmlzbS4gSSdsbCBzZWUgaWYgSSBjYW4KPiA+ID4gcmVwcm9kdWNlIHRoaXMgYW5kIGNv
b2sgdXAgYSBwYXRjaCB0byBmaXggaXQuCj4gPiAKPiA+IEhtbSwgSSdtIHdvbmRlcmluZyBpZiB0
aGlzIGlzc3VlIGlzIHNvbWVob3cgcmVsYXRlZCB0byB0aGUgaHJ0aW1lciBidWcsCj4gPiB0aGF0
IFRob21hcyBHbGVpeG5lciBmaXhlZCB5ZXN0ZXJkYXk6Cj4gPiBodHRwOi8vZ2l0LnVzLmtlcm5l
bC5vcmcvP3A9bGludXgva2VybmVsL2dpdC90aXAvbGludXgtMi42LXRpcC5naXQ7YT1jb21taXQ7
aD1jZTMxMzMyZDNjNzc1MzJkNmVhOTdkZGNiNDc1YTJiMDJkZDM1OGI0Cj4gPiBodHRwOi8vdGhy
ZWFkLmdtYW5lLm9yZy9nbWFuZS5saW51eC5rZXJuZWwubW0vNjE5MDkvCj4gPiAKPiA+IEl0IGFs
c28gbG9va3Mgc2ltaWxhciB0byB0aGUgaXNzdWUgdGhhdCBKYW1lcyBCb3R0b21sZXkgcmVwb3J0
ZWQKPiA+IGVhcmxpZXI6IGh0dHA6Ly90aHJlYWQuZ21hbmUub3JnL2dtYW5lLmxpbnV4Lmtlcm5l
bC5tbS82MjE4NS8gCj4gCj4gSSdtIGdvaW5nIHRvIHNlZSwgSSd2ZSBhcHBsaWVkIFRob21hcycg
Zml4IG9uIHRoZSBib3ggc2VlaW5nIFhGUyBmcmVlemUgKHdpdGhvdXQKPiBvdGhlciBjaGFuZ2Vz
IHRvIGtlcm5lbCkuCj4gR29pbmcgdG8gcnVuIHRoYXQga2VybmVsIGZvciB0aGUgd2Vlay1lbmQg
YW5kIGJleW9uZCBpZiBpdCBzdXJ2aXZlcyB0byBzZWUgd2hhdAo+IGhhcHBlbnMuCgpIYXBwZW5l
ZCBhZ2FpbiAoYWZ0ZXIgYSBmZXcgaG91cnMgb2YgdXB0aW1lKSwgc28gaXQgZGVmaW5pdGVseSBp
cyBub3QKY2F1c2VkIGJ5IGhydGltZXIgYnVnIHRoYXQgVGhvbWFzIEdsZWl4bmVyIGZpeGVkLgoK
QnJ1bm8KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhm
cyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL3hmcwo=
