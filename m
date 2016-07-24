Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 759E37CA0
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2016 07:48:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37ACB8F8035
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2016 05:48:34 -0700 (PDT)
Received: from relaycp01.dominioabsoluto.net (relaycp01.dominioabsoluto.net
	[217.116.26.68]) by cuda.sgi.com with ESMTP id g4Ks5GS9sYAVoMHC
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2016 05:48:31 -0700 (PDT)
Received: from smtp.movistar.es (smtp11.acens.net [86.109.99.135])
	by relaycp01.dominioabsoluto.net (Postfix) with ESMTP id 23E9642FE
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2016 14:48:30 +0200 (CEST)
Received: from [192.168.1.136] (81.33.74.237) by smtp.movistar.es (8.6.122.03)
	(authenticated as robin.listas2)
	id 5734BE9703DC6954 for xfs@oss.sgi.com; Sun, 24 Jul 2016 12:48:58 +0000
Subject: Re: hardlinking and deleting milions of small files
References: <201607241438.10035.arekm@maven.pl>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <d916e06d-f798-2789-1b6b-5ee717ab59c3@telefonica.net>
Date: Sun, 24 Jul 2016 14:48:29 +0200
MIME-Version: 1.0
In-Reply-To: <201607241438.10035.arekm@maven.pl>
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
To: XFS mailing list <xfs@oss.sgi.com>

T24gMjAxNi0wNy0yNCAxNDozOCwgQXJrYWRpdXN6IE1pxZtraWV3aWN6IHdyb3RlOgo+IAo+IEhl
bGxvLgo+IAo+IEknbSB1c2luZyByc25hcHNob3QgdG8gYmFja3VwIGJpZyBzZXJ2ZXJzIChsaWtl
IDVUQiBmcywgMjUgMDAwIDAwMCBpbm9kZXMsIAo+IHNtYWxsIGZpbGVzIC0gbWFpbGJveGVzIGlu
IGZvcm0gb2YgbWFpbGRpcnMsIHNvIGVhY2ggbWFpbCBpcyBhIHNlcGFyYXRlIGZpbGUpLiAKPiBC
YWNrdXAgc2VydmVyIC0ga2VybmVsIDQuNi4zLCBWNCB4ZnMgZmlsZXN5c3RlbXMuCj4gCj4gY3Ag
LWFsIGZvciB0aGF0IGFtb3VudCB0YWtlcyBhYm91dCAxLjUgZGF5Lgo+IHJtIC1yZiBvZiBoYXJk
bGlua2VkIGNvcHkgdGFrZXMgYW5vdGhlciAxLjUgZGF5CgpJIGhlc2l0YXRlIHRvIHN1Z2dlc3Qg
cmVpc2VyZnMuLi4KSSBrbm93IGl0IGlzIGdvb2QgaW4gdGhhdCBzaXR1YXRpb24sIGJ1dCBJIGRv
dWJ0IGl0IHNjYWxlcyB3ZWxsIG5vd2RheXMuCllvdXIgZmlsZXN5c3RlbXMgYXJlIGZhciBiaWdn
ZXIgdGhhbiBteSBleHBlcmllbmNlLgoKVGhlcmUgd2FzIHNvbWUgc3VnZ2VzdGlvbiB0aGF0IGJ0
cmZzIGNvdWxkIGRvIGl0ICh3aXRob3V0IHNuYXBzaG90cykuCkJ1dC4uLiA/IFRvbyBncmVlbj8g
WW91IGNvdWxkIHRyeSBpdCB1cCBpbiBhIHNwYXJlIHRlc3Qgc2VydmVyLgoKLS0gCkNoZWVycyAv
IFNhbHVkb3MsCgoJCUNhcmxvcyBFLiBSLgoKICAoZnJvbSBvcGVuU1VTRSBMZWFwIDQyLjEgeDg2
XzY0ICh0ZXN0KSkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
