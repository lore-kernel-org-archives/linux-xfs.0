Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8NnR7i124935 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:49:28 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C47791C253CB
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:50:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	mPSAvi1MbuaCAP3D for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 15:50:53 -0800 (PST)
Date: Tue, 9 Nov 2010 10:50:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/16] xfs: connect up buffer reclaim priority hooks
Message-ID: <20101108235049.GU2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-12-git-send-email-david@fromorbit.com>
	<20101108112509.GA7654@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101108112509.GA7654@infradead.org>
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

T24gTW9uLCBOb3YgMDgsIDIwMTAgYXQgMDY6MjU6MDlBTSAtMDUwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gPiArLyoKPiA+ICsgKiBidWZmZXIgdHlwZXMgCj4gPiArICovCj4gPiArI2Rl
ZmluZQlCX0ZTX0RRVU9UCTEKPiA+ICsjZGVmaW5lCUJfRlNfQUdGTAkyCj4gPiArI2RlZmluZQlC
X0ZTX0FHRgkzCj4gPiArI2RlZmluZQlCX0ZTX0FUVFJfQlRSRUUJNAo+ID4gKyNkZWZpbmUJQl9G
U19ESVJfQlRSRUUJNQo+ID4gKyNkZWZpbmUJQl9GU19NQVAJNgo+ID4gKyNkZWZpbmUJQl9GU19J
Tk9NQVAJNwo+ID4gKyNkZWZpbmUJQl9GU19BR0kJOAo+ID4gKyNkZWZpbmUJQl9GU19JTk8JOQo+
IAo+IElzIHRoZXJlIGFueSBnb29kIHJlYXNvbiB0byBrZWVwL3JlaW50cm9kdWNlIHRoZSBidWZm
ZXIgdHlwZXM/ICBJbiB0aGlzCj4gc2VyaWVzIHdlJ3JlIG9ubHkgdXNpbmcgdGhlIHJlZmNvdW50
cywgYW5kIEkgY2FuJ3Qgc2VlIGFueSBnb29kIHVzZSBmb3IKPiB0aGUgdHlwZXMgZWl0aGVyLgoK
SSBqdXN0IHdhbnRlZCB0byB1c2UgdGhlIGV4aXN0aW5nIGhvb2tzIHdpdGhvdXQgbW9kaWZ5aW5n
IHRoZW0gdG8gYmUKcGxhaW4gInNldCByZWZlcmVuY2UiIGhvb2tzLiBJJ20gbm90IHJlYWxseSBm
dXNzZWQgLSB0aGlzIHdhcyBqdXN0CnRoZSBzaW1wbGVzdCB3YXkgdG8gZ2V0IHRoZSBob29r0ZUg
d29ya2luZy4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0
LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
