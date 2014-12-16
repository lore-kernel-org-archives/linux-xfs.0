Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48AFB7F58
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 05:39:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3683C304039
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 03:38:57 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id QWGzWAGxuhr3n62n (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Dec 2014 03:38:56 -0800 (PST)
Date: Tue, 16 Dec 2014 12:38:58 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141216123858.0004d97c@harpe.intellique.com>
In-Reply-To: <20141216075605.GA24633@infradead.org>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141215201036.GQ24183@dastard>
	<20141216075605.GA24633@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

TGUgTW9uLCAxNSBEZWMgMjAxNCAyMzo1NjowNSAtMDgwMApDaHJpc3RvcGggSGVsbHdpZyA8aGNo
QGluZnJhZGVhZC5vcmc+IMOpY3JpdmFpdDoKCj4gT24gVHVlLCBEZWMgMTYsIDIwMTQgYXQgMDc6
MTA6MzZBTSArMTEwMCwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+ID4gVGhlIGNvbnRyb2xsZXIgaXMg
YnJva2VuIGlmIGl0J3MgcmV0dXJuaW5nIEVJTyB0byByZWFkcyB3aGVuIGl0Cj4gPiBpcyBidXN5
Lgo+IAo+IFdoYXQgY29udHJvbGxlciBpcyB0aGlzPyAKCkFTUi03MTY4NSwgYnV0IHRoZSBwcm9i
bGVtIG9jY3VyZWQgc2V2ZXJhbCB0aW1lcyB3aXRoIHZhcmlvdXMgQVNSLTd4eDUKY29udHJvbGxl
cnMgYW5kIGRpZmZlcmVudCBmaXJtd2FyZSBhbmQgZHJpdmVycy4gCgo+IFNDU0kgZGV2aWNlcyBj
YW4gcmV0dXJuIGEgUVVFVUUgQlVTWQo+IGluZGljYXRvciwgc28gaGF2aW5nIGEgUkFJRCBjb250
cm9sbGVyIGRvIHNvbWV0aGluZyBzaW1pbGFyIGRvZXNuJ3QKPiBzb3VuZCB1bnVzdWFsLiAgQnV0
IHRoZSBkcml2ZXIgbmVlZHMgdG8gcmV0dXJucyB0cmFuc2xhdGUgdGhhdCBpbnRvCj4gYSBRVUVV
RSBCVVNZIHNvIHRoYXQgdGhlIFNDU0kgbWlkbGF5ZXIgY2FuIGhhbmRsZSBpdCBjb3JyZWN0bHku
Cj4gCj4gSXQgbWlnaHQgbWFrZSBzZW5zZSB0byB0YWtlIHRoaXMgdG8gbGludXgtc2NzaSB3aXRo
IHRoZSBkcml2ZXIKPiBtYWludGFpbmVyIGluIENjLgoKVGhlIGRyaXZlciB3b3VsZCBiZSBlaXRo
ZXIgYWFjcmFpZCBvciBzZCwgdGhlbj8KCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxv
cmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAgIHwgICBJ
bnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4K
ICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
