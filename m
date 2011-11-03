Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3B4NS4001014 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 06:04:23 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFA1421C769
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 04:04:22 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id LrUVFaMjdpTmTes4
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 04:04:22 -0700 (PDT)
Received: by bkbzs8 with SMTP id zs8so1192735bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 04:04:21 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 6/8] xfstests: add fiemap operation to fsstress
In-Reply-To: <FA2EDC7F-92EC-449E-9FBC-B7955283DFAC@mit.edu>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-7-git-send-email-dmonakhov@openvz.org>
	<20111102195534.GB22500@infradead.org>
	<FA2EDC7F-92EC-449E-9FBC-B7955283DFAC@mit.edu>
Date: Thu, 03 Nov 2011 15:04:17 +0400
Message-ID: <87wrbhxya6.fsf@dmbot.sw.ru>
MIME-Version: 1.0
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
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de, aelder@sgi.com

T24gVGh1LCAzIE5vdiAyMDExIDA2OjU0OjE2IC0wNDAwLCBUaGVvZG9yZSBUc28gPHR5dHNvQG1p
dC5lZHU+IHdyb3RlOgo+IAo+IE9uIE5vdiAyLCAyMDExLCBhdCAzOjU1IFBNLCBDaHJpc3RvcGgg
SGVsbHdpZyB3cm90ZToKPiAKPiA+IEFsZXgsIEVyaWMsIERhdmUgLSBzaG91bGQgd2UgYWRkIG5l
dyB0ZXN0cyB3aXRoIHRoZSBuZXcgb3BlcmF0aW9ucwo+ID4gRG1pdHJ5IGFkZGVkLCBvciBpcyBh
ZGRpbmcgbmV3IG9wcyB0byB0aGUgZXhpc3RpbmcgdGVzdHMgZmluZT8KPiAKPiBPbmUgYXJndW1l
bnQgZm9yIGFkZGluZyBuZXcgb3BzIHRvIGV4aXN0aW5nIHRlc3RzIGlzIHRoYXQgaXQgbWFrZXMg
dGhlIHJ1biB0aW1lIG9mIHRoZSBlbnRpcmUgdGVzdCBzdWl0ZSB0YWtlIGxvbmdlci4gICBBIFFB
IHBhc3MgaXMgYWxyZWFkeSB0YWtpbmcgcXVpdGUgYSB3aGlsZSwgYW5kIGl0IHdvdWxkIGJlIG5p
Y2UgaWYgd2UgY291bGQga2VlcCB4ZnN0ZXN0cyBhcyBlZmZpY2llbnQgYXMgcG9zc2libGUgaW4g
dGVybXMgb2YgdGhlIG1heGltdW0gdGVzdGluZyBjb3ZlcmFnZSBwZXIgdGltZSBzcGVudCBydW5u
aW5nIHRoZSB0ZXN0IHN1aXRl4oCmLgpZZXMsIGJ1dCByZWdyZXNzaW9uIHRlc3Qgd2l0aCBleHBs
aWNpdCBzZWVkIG9wdGlvbiBzaG91bGQgYmUKcHJlc2VydmVkLiBOdW1iZXIgb2Ygc3VjaCB0ZXN0
IGlzIG5vdCB0b28gYmlnLCBzbyBpdCBpcyByZWFzb25hYmxlIHRvCmhhcmRjb2RlIHNldCBvZiBv
cGVyYXRpb25zIGluIHN1Y2ggdGVzdHMgYW5kIGxldCBhbGwgb3RoZXJzIHVzZSBuZXcgZmVhdHVy
ZXMuCj4gCj4gLS0gVGVkCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
