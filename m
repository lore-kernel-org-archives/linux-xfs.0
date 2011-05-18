Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4INqSK8004086 for <xfs@oss.sgi.com>; Wed, 18 May 2011 18:52:28 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F719CE447F
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 16:52:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Y6Ixr7r5lGvL3r5v for <xfs@oss.sgi.com>;
	Wed, 18 May 2011 16:52:25 -0700 (PDT)
Date: Thu, 19 May 2011 09:52:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issue with xfs on dm snapshots
Message-ID: <20110518235223.GB32466@dastard>
References: <4DD3876F.2080805@onet.eu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DD3876F.2080805@onet.eu>
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
To: sdrb <sdrb@onet.eu>
Cc: xfs@oss.sgi.com

T24gV2VkLCBNYXkgMTgsIDIwMTEgYXQgMTA6NDY6MzlBTSArMDIwMCwgc2RyYiB3cm90ZToKPiBI
ZWxsbwo+IAo+IEkgZW5jb3VudGVyZWQgc29tZSBwcm9ibGVtcyB1c2luZyBYRlMgb24gTFZNIGFu
ZCBzbmFwc2hvdHMgb24gbGludXggMi42LjM1Lgo+IFRoZSBwcm9ibGVtIGlzIHRoYXQgd2hlbiB0
aGVyZSBhcmUgc2V2ZXJhbCBzbmFwc2hvdHMgYW5kIHNvbWUgb2YKPiB0aGVtIHJlYWNoZWQgdGhl
aXJzIG1heGltdW0gc3BhY2UgYW5kIGRpc2tzIGFyZSB1bmRlciBoZWF2eSBsb2FkIC0KPiBpdCBj
YXVzZXMgdGhhdCB0aGUgdGFza3MgdGhhdCByZWx5IHNvbWVob3cgb24gZGV2aWNlIG1hcHBlciAt
IGp1c3QKPiBodW5nLgoKWXVwLiBSdW5uaW5nIHlvdXIgc2hhcHNob3QgdGFyZ2V0IG91dCBvZiBk
aXNrIHNwYWNlIGNhdXNlcyBCYWQKVGhpbmdzIFRvIEhhcHBlbi4gVHlwaWNhbCBwcm9ibGVtIGlz
IHRoYXQgbWV0YWRhdGEgd3JpdGUgSU8ncyBmYWlsCmFuZCBYRlMgc2h1dNGVIHRoZSBmaWxlc3l0
ZW0gZG93biBpbiByZXNwb25zZSB0byB0aGUgY29ycnVwdGlvbiB0aGF0CnRoZSBmYWlsaW5nIElP
IGhhcyBjYXVzZWQuCgpMb29raW5nIGF0IHlvdXIgbG9nLCBpIHNlZSB0aGF0IGlzIGV4YWN0bHkg
d2hhdCBYRlMgaGFzIGRvbmUuCgpUaGUgbG9ja2RlcCByZXBvcnRzIGFyZSBhYm91dCBkbS1zbmFw
c2hvdCBsb2NrcyBhbmQgYXJlIG5vdCBYRnMKcmVsYXRlZCwgc28gdGhhdCdzIHByb2JhYmx5IHdo
ZXJlIHRoZSBoYW5nIGlzIG9jY3VycmluZy4gSSdtIHN1cmUKeW91IGNvdWxkIHByb2R1Y2UgdGhl
IHNhbWUgaGFuZyB1c2luZyBleHQ0IGluc3RlYWQgb2YgWEZTLiBZb3Ugc2hvdWxkCnJlcG9ydCB0
aGlzIHRvIHRoZSBkbS1kZXZlbCBsaXN0LgoKVGhlIHRha2UgYXdheSBtZXNzYWdlOiBEb24ndCBs
ZXQgeW91ciBzbmFwc2hvdCB2b2x1bWVzIHJ1biBvdXQgb2YKc3BhY2UgLSB5b3UnbGwgY29ycnVw
dCBkYXRhIGFuZC9vciB5b3VyIGZpbGVzeXN0ZW0uCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBD
aGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6
Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
