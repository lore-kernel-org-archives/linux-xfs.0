Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24C177CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 10:33:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 896A4AC003
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 08:33:30 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id A5eeLKTXPGJnId2g (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 08:33:26 -0700 (PDT)
Date: Mon, 6 Jun 2016 17:33:36 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair fails after trying to format log cycle?
Message-ID: <20160606173336.027917f5@harpe.intellique.com>
In-Reply-To: <57523CE6.7020906@shaw.ca>
References: <56F6DE67.60403@shaw.ca> <20160328085541.GA27040@bfoster.bfoster>
	<570C8D4D.3060304@shaw.ca> <20160412140512.GA59690@bfoster.bfoster>
	<570D578D.5010706@shaw.ca> <570DB6CD.1000007@shaw.ca>
	<20160413045129.GO567@dastard> <57523CE6.7020906@shaw.ca>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andrew Ryder <tireman@shaw.ca>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

TGUgRnJpLCAzIEp1biAyMDE2IDIyOjI4OjU0IC0wNDAwCkFuZHJldyBSeWRlciA8dGlyZW1hbkBz
aGF3LmNhPiDDqWNyaXZhaXQ6Cgo+IFNvcnJ5IHRvIGRpZyB1cCBvbGQgc3R1ZmYgaGVyZSBidXQg
YWZ0ZXIgcmVwbGFjaW5nIGhhcmR3YXJlIGFuZAo+IHB1bGxpbmcgbXkgaGFpciBvdXQgdG8gbm8g
ZW5kLCBJIHRyYWNlZCB0aGUgc291cmNlIG9mIHRoZSBwcm9ibGVtIG91dC4KPiAKPiBPbiBldmVy
eSBkcml2ZSBpbiB0aGUgYXJyYXksIHRoZSBwb2ludHMgb24gdGhlIFBDQiB3aGljaCB0aGUgY29u
dGFjdHMgCj4gZm9yIHRoZSBkcml2ZXMgbW90b3JzIGFuZCBoZWFkL2FjdHVhdG9ycyBtYWtlIGNv
bnRhY3Qgd2l0aCB3ZXJlCj4gb3hpZGl6ZWQgZW5vdWdoIHRvIGNhdXNlIHRoZSBpc3N1ZS4gSSBl
bmRlZCB1cCBwdWxsaW5nIHRoZSBQQ0Igb2ZmCj4gZWFjaCBkcml2ZSBhbmQgY2xlYW5pbmcgdGhl
bSBhcyB3ZWxsIGFzIGNsZWFuaW5nIG91dCBhbGwgb3RoZXIgY2FibGUKPiBhbmQgZHJpdmUgY29u
bmVjdG9ycyBmcm9tIHRoZSBIQkEgb3V0d2FyZCBhbmQgZXZlcnl0aGluZyBpcyBoYXBweQo+IGFn
YWluLgo+IAo+IGh0dHA6Ly9zMzMucG9zdGltZy5vcmcvdWhqbXZ3NGRyL05vdF9DbGVhbmVkLmpw
Zwo+IGh0dHA6Ly9zMzMucG9zdGltZy5vcmcveG85NGllaWk3L1BhcnRpYWxfQ2xlYW5lZF8xLmpw
Zwo+IGh0dHA6Ly9zMzMucG9zdGltZy5vcmcvaG9xZ3l1bWdmL1BhcnRpYWxfQ2xlYW5lZF8yLmpw
Zwo+IGh0dHA6Ly9zMzMucG9zdGltZy5vcmcvNjhrMjB0OGE3L1BhcnRpYWxfQ2xlYW5lZF8zLmpw
Zwo+IAoKR29vZCBqb2IsIHRoYXQgd2FzIHF1aXRlIHVuZXhwZWN0ZWQgOikgQXJlIHlvdSBuZXh0
IHRvIHRoZQpzZWFzaG9yZT8KCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAg
ICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxp
cXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAg
ICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
