Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 127B67F4E
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 10:06:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C04D98F804B
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 08:06:09 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id WEHbedRL6pzSREwo (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 May 2014 08:06:08 -0700 (PDT)
Subject: Bug#748483: xfsprogs: Let's add a watch file
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.748483.B.14006846383354@bugs.debian.org>
Message-ID: <1400684630.4058.0.camel@lamella>
From: Vincent Blut <vincent.debian@free.fr>
Date: Wed, 21 May 2014 17:03:50 +0200
In-Reply-To: <20140521144701.GA3580@infradead.org>
References: <20140517175957.5232.71552.reportbug@lamella>
	<20140521144701.GA3580@infradead.org>
Mime-Version: 1.0
Reply-To: Vincent Blut <vincent.debian@free.fr>, 748483@bugs.debian.org
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Debian Bug Tracking System <submit@bugs.debian.org>, 748483@bugs.debian.org

TGUgbWVyY3JlZGkgMjEgbWFpIDIwMTQgw6AgMDc6NDcgLTA3MDAsIENocmlzdG9waCBIZWxsd2ln
IGEgw6ljcml0IDoKPiBPbiBTYXQsIE1heSAxNywgMjAxNCBhdCAwNzo1OTo1N1BNICswMjAwLCBW
aW5jZW50IEJsdXQgd3JvdGU6Cj4gPiBTb3VyY2U6IHhmc3Byb2dzCj4gPiBWZXJzaW9uOiAzLjEu
OQo+ID4gU2V2ZXJpdHk6IHdpc2hsaXN0Cj4gPiAKPiA+IEhleSBndXlzLAo+ID4gCj4gPiBFdmVu
IGlmIGl0IGRvZXNuJ3QgbmVjZXNzYXJpbHkgaW1wcm92ZSB5b3VyIHdvcmtmbG93LCB0aGUgd2F0
Y2ggZmlsZSBjb3VsZCAKPiA+IGltcHJvdmUgc29tZSBEZWJpYW4gdG9vbHMgdGhhdCBjaGVjayBp
dCAoZS5nLiBVREQpLiAKPiA+IENvdWxkIHlvdSBwbGVhc2UgYXBwbHkgdGhlIGF0dGFjaGVkIG9u
ZSBpbiB5b3VyIG5leHQgdXBsb2FkPwo+IAo+IEknbGwgYXNzdW1lIHRoaXMgc2hvdWxkIGdvIGlu
dG8gZGViaWFuL3dhdGNoPwoKSW5kZWVkIQoKPiAKPiBJdCdzIHByb2JhYmx5IGJlc3QgaWYgeW91
IHNpbXBseSBzdWJtaXQgYSBwYXRjaCB0aGF0IGFkZHMgaXQgd2l0aAo+IHByb3BlciBGcm9tOiwg
U3ViamVjdDogYW5kIFNpZ25lZC1vZmYtYnk6IHRhZ3Mgc28gaXQgY2FuIGJlIGFwcGxpZWQKPiBh
cy1pcy4KPiAKCldpbGwgZG8uCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
