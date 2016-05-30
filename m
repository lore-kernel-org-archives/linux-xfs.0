Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B4287CA0
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 17:09:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB0A3AC002
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 15:08:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Wj9uSVTBtQEivTKW for <xfs@oss.sgi.com>;
	Mon, 30 May 2016 15:08:53 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs: fix broken multi-fsb buffer logging
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20160530140836.GA18031@bfoster.bfoster>
Date: Mon, 30 May 2016 17:08:52 -0500
Message-Id: <6F890F4E-AAAF-40B5-82BE-B6779E264D29@sandeen.net>
References: <1464204667-10199-1-git-send-email-bfoster@redhat.com>
	<20160530140836.GA18031@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Cgo+IE9uIE1heSAzMCwgMjAxNiwgYXQgOTowOCBBTSwgQnJpYW4gRm9zdGVyIDxiZm9zdGVyQHJl
ZGhhdC5jb20+IHdyb3RlOgo+IAo+PiAuLi4KPiAKPiBUaGlzIGhhcyBwYXNzZWQgbXkgdGVzdHMg
d2l0aG91dCBhbnkgb2J2aW91cyBwcm9ibGVtcyBvciByZWdyZXNzaW9ucy4KPiBBbnkgb3RoZXIg
dGhvdWdodHMvY29tbWVudHMgb3IgcmV2aWV3cz8gSSdkIGxpa2UgdG8gZ2V0IGEgYmFja3BvcnQg
Z29pbmcKPiBmb3IgdGhpcywgYnV0IGNhbid0IGRvIHNvIHVudGlsIHRoZXJlIGlzIGF0IGxlYXN0
IHNvbWUga2luZCBvZgo+IGFja25vd2xlZGdlbWVudCB0aGlzIGlzIGFjY2VwdGFibGUuCj4gCj4g
QnJpYW4KPiAKU29ycnkgQnJpYW4sIEkgbWVhbnQgdG8gcmV2aWV3IHRoaXMgbGFzdCBGcmlkYXks
IGJ1dCBnb3Qgd3JhcHBlZCB1cCBpbiBvdGhlciB0aGluZ3PigKYgTXkgZmlyc3QgcGFzcyBvdmVy
IGl0IGxvb2tzIGZpbmUsIEkganVzdCB3YW50IHRvIGdpdmUgaXQgYSBsaXR0bGUgbW9yZSBpbiBk
ZXB0aCByZXZpZXcsIGFuZCBJIHdpbGwgZG8gbXkgYmVzdCB0byBnZXQgdGhhdCBkb25lIHRvbW9y
cm93LgoKRXJpYwoKPj4gQnJpYW4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
