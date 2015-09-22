Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5247E7F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 03:25:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3DE0C8F8033
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 01:25:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wHPUE4x3tlgsdoQM for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 01:25:11 -0700 (PDT)
Date: Tue, 22 Sep 2015 18:25:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: add [-U uuid] option
Message-ID: <20150922082509.GD3902@dastard>
References: <1442855060-38259-1-git-send-email-mel@ohmu.fi>
	<20150921221839.GC19114@dastard>
	<2640913C-6C95-4128-9055-B155AECA0206@ohmu.fi>
	<20150921233627.GE19114@dastard>
	<5E0C9EC9-8ABE-47CC-BB7F-2BC0A872AEDB@ohmu.fi>
	<20150922075249.GI19114@dastard>
	<AF226911-F11E-42E8-91F1-10C0E2E31E1D@ohmu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AF226911-F11E-42E8-91F1-10C0E2E31E1D@ohmu.fi>
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
To: Mika Eloranta <mika.eloranta@ohmu.fi>
Cc: xfs@oss.sgi.com

T24gVHVlLCBTZXAgMjIsIDIwMTUgYXQgMTE6MDY6MzVBTSArMDMwMCwgTWlrYSBFbG9yYW50YSB3
cm90ZToKPiA+IE9uIDIyIFNlcCAyMDE1LCBhdCAxMDo1MiwgRGF2ZSBDaGlubmVyIDxkYXZpZEBm
cm9tb3JiaXQuY29tPiB3cm90ZToKPiA+IERvbid0IGdldCBtZSB3cm9uZyBoZXJlIC0gSSB3aWxs
IHRha2UgYW4gdXBkYXRlZCBwYXRjaCBmcm9tIHlvdSBmb3IKPiA+IHRoaXMgZnVuY3Rpb25hbGl0
eS4gQm90aCB5b3UgYW5kIEVyaWMgaGF2ZSB2ZXJ5IGdvb2QgcG9pbnRzIGFzIHRvCj4gPiB3aHkg
bWtmcyBzaG91bGQgYWxsb3cgdGhpcywgYnV0IEkgbmVlZCB0byBtYWtlIHN1cmUgL0kvIHVuZGVy
c3RhbmQKPiA+IHRoZSBiaWdnZXIgcGljdHVyZSBiZWZvcmUgY29tbWl0dGluZyBpdOKApgo+IAo+
IExlc3NvbiBsZWFybmVkLiBDb21pbmcgZnJvbSBteSBwcm9ibGVtIGRvbWFpbiB0aGUgZmVhdHVy
ZSBzZWVtZWQKPiBvYnZpb3VzLCBidXQgSSBjYW4gc2VlIHRoZSBuZWVkIGZvciBiZWluZyBtb3Jl
IHZlcmJvc2UgYWJvdXQgdGhlIOKAnHdoeT/igJ0KPiBwYXJ0LiBJIGRpZCBub3QgcmVhbGl6ZSB0
aGlzIGZlYXR1cmUgaXMgbm90IHNvIGNvbW1vbmx5IHVzZWQuCgpUaGUgdXN1YWwgcHJvYmxlbSAt
IHdlJ3JlIGFsbCBzdWJqZWN0IG1hdHRlciBleHBlcnRzIGluCm91ciBvd24gZG9tYWlucywgYW5k
IHdoYXQgaXMgb2J2aW91cyB0byB1cyBpc24ndCBvYnZpb3VzIHRvCnNvbWVvbmUgaW4gYSBzbGln
aHRseSBkaWZmZXJlbnQgZG9tYWluLCBldmVuIHRob3VnaCB0aGV5IGludGVyYWN0IGF0CnNvbWUg
bGV2ZWwuCgo+IFJlZ2FyZGluZyB1cGRhdGluZyB0aGUgcGF0Y2g6IOKAnC1VIHV1aWTigJ0gKG1r
ZnMuZXh0Ki9ta2ZzLmJ0cmZzIC1zdHlsZSkgb3IKPiAiLW0gdXVpZD08dXVpZD7igJ0gYXMgcGVy
IHByb3Bvc2FsIGJ5IENhcmxvcz8KCi1tIHV1aWQ9PHV1aWQ+LCBwbGVhc2UuCgpDaGVlcnMsCgpE
YXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9z
cy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
