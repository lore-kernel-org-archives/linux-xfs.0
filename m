Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C0BB27F3F
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 03:54:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 41D98AC006
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 01:54:11 -0700 (PDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
	[209.85.215.41]) by cuda.sgi.com with ESMTP id nNz5jH65uILZCDsx
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Sep 2014 01:54:10 -0700 (PDT)
Received: by mail-la0-f41.google.com with SMTP id s18so10277163lam.14
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 01:54:08 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: "No space left on device" from hell
Date: Wed, 24 Sep 2014 10:54:05 +0200
References: <201409240903.46899.arekm@maven.pl>
	<CAM5tkX-mOO6EtJczQZC-23-vk7LwSczTL8CB6pgLTSLH0q94fg@mail.gmail.com>
In-Reply-To: <CAM5tkX-mOO6EtJczQZC-23-vk7LwSczTL8CB6pgLTSLH0q94fg@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201409241054.06983.arekm@maven.pl>
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
To: Fran Tsao =?utf-8?q?Sant=C3=ADn?= <tsao@members.fsf.org>
Cc: xfs@oss.sgi.com

T24gV2VkbmVzZGF5IDI0IG9mIFNlcHRlbWJlciAyMDE0LCBGcmFuIFRzYW8gU2FudMOtbiB3cm90
ZToKPiAyMDE0LTA5LTI0IDk6MDMgR01UKzAyOjAwIEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJl
a21AbWF2ZW4ucGw+Ogo+ID4gSGVsbG8uCj4gPiAKPiA+IDMuMTAuNDAga2VybmVsIGFuZCBjcmVh
dGluZyBmaWxlcyBjYXVzZXMgIk5vIHNwYWNlIGxlZnQgb24gZGV2aWNlIi4gQWZ0ZXIKPiA+IGRl
bGV0aW5nIHNvbWUgZmlsZXMgSSBjYW4gY3JlYXRlIG5ldyBmaWxlcyBhZ2FpbiB1bnRpbCB0aGUg
cHJvYmxlbQo+ID4gaGFwcGVucyBhZ2Fpbi4KPiAKPiBBcmUgeW91IHN1cmUgdGhlIHByb2JsZW0g
aXMgdGhlIGZpbGVzeXN0ZW0gZGV2aWNlPyBNYXliZSB5b3UgYXJlIHJ1bm5pbmcgYQo+IHByb2Nl
c3MgdGhhdCBmaWxscyB1cCBhbm90aGVyIGRldmljZSBpLmUuIHNobS4KCkRhdmUgQ2hpbm5lciBm
aWd1cmVkIG91dCB0aGUgcHJvYmxlbSBhbHJlYWR5IChvbiBpcmMpLgoKQmFzaWNhbGx5IHRoaXMg
ZnMgd2FzIGdyb3duIGZyb20gMzAwR0IgdG8gNjAwR0IgYnV0IGR1ZSB0byBidWcgKGZpeGVkIGJ5
IApjb21taXQgOWRlNjdjMyAoInhmczogYWxsb3cgaW5vZGUgYWxsb2NhdGlvbnMgaW4gcG9zdC1n
cm93ZnMgZGlzayBzcGFjZSIpKSAKdGhhdCBuZXcgc3BhY2Ugd2FzIG5ldmVyIHVzZWQgZm9yIG5l
dyBpbm9kZXMuCgpTbyBlbmRlZCB1cCB3aXRoIGZ1bGwgQUdzIDAtMyAoeGZzX2RiIC1yIC1jICJm
cmVlc3AgLXMgLWEgWFgiICAvZGV2L3h5eiBzaG93cyAKdGhhdCBmb3IgZWFjaCBBRyBYWCkuCgpG
cyB3YXMgbmV2ZXIgdW5tb3VudGVkIGFmdGVyIGdyb3dzIGJ1dCBmb3J0dW5hdGVseSBtb3VudCAt
byByZW1vdW50LGlub2RlMzIgCi4uLiBmb2xsb3dlZCBieSBtb3VudCAtbyByZW1vdW50LGlub2Rl
NjQgY3VyZWQgaXQgd2l0aG91dCBhIG5lZWQgdG8gcmVib290LCBzbyAKbm93IG5ldyBpbm9kZXMg
YXJlIGRpc3RyaWJ1dGVkIHRvIGFsbCBBR3MuCgpJIHN0aWxsIG5lZWQgdG8gZnJlZSBzb21lIHNw
YWNlIGluIEFHcyAwLTMgdGhvdWdoIChieSBtb3ZpbmcgZGF0YSB0byBuZXcgZGlycyAKYWxsb2Nh
dGVkIGluIG5ldyBBR3M7IHhmc19kYiAtciAtYyAiY29udmVydCBpbm9kZSBESVJfSU5PREVfTlIg
YWdubyIgL2Rldi94eXogCnNob3dzIGluIHdoaWNoIEFHIG5ldyBkaXIgZ290IGFsbG9jYXRlZCku
CgpUaGVyZSBhcmUgbW9yZSBidWdzIGhpZGluZyAobGlrZSBpZiBFTk9TUEMgb24gc29tZSBBRyBo
YXBwZW5zIGl0IHNob3VsZCB0cnkgCm5leHQgQUcgaW5zdGVhZCBvZiBmYWlsaW5nKS4gRGF2ZSBr
bm93cyBhbGwgdGhhdCBtYWdpYy4KCkJpZyB0aGFua3MgdG8gRGF2ZSEKCi0tIApBcmthZGl1c3og
TWnFm2tpZXdpY3osIGFyZWttIC8gbWF2ZW4ucGwKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
