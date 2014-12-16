Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A046C7F3F
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 11:22:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F556304043
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 09:22:01 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id Fe5w77RNWhrWAchb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Dec 2014 09:21:56 -0800 (PST)
Date: Tue, 16 Dec 2014 18:21:57 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141216182157.6499749d@harpe.intellique.com>
In-Reply-To: <20141216123858.0004d97c@harpe.intellique.com>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141215201036.GQ24183@dastard>
	<20141216075605.GA24633@infradead.org>
	<20141216123858.0004d97c@harpe.intellique.com>
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

TGUgVHVlLCAxNiBEZWMgMjAxNCAxMjozODo1OCArMDEwMApFbW1hbnVlbCBGbG9yYWMgPGVmbG9y
YWNAaW50ZWxsaXF1ZS5jb20+IMOpY3JpdmFpdDoKCj4gPiBTQ1NJIGRldmljZXMgY2FuIHJldHVy
biBhIFFVRVVFIEJVU1kKPiA+IGluZGljYXRvciwgc28gaGF2aW5nIGEgUkFJRCBjb250cm9sbGVy
IGRvIHNvbWV0aGluZyBzaW1pbGFyIGRvZXNuJ3QKPiA+IHNvdW5kIHVudXN1YWwuICBCdXQgdGhl
IGRyaXZlciBuZWVkcyB0byByZXR1cm5zIHRyYW5zbGF0ZSB0aGF0IGludG8KPiA+IGEgUVVFVUUg
QlVTWSBzbyB0aGF0IHRoZSBTQ1NJIG1pZGxheWVyIGNhbiBoYW5kbGUgaXQgY29ycmVjdGx5Lgo+
ID4gCj4gPiBJdCBtaWdodCBtYWtlIHNlbnNlIHRvIHRha2UgdGhpcyB0byBsaW51eC1zY3NpIHdp
dGggdGhlIGRyaXZlcgo+ID4gbWFpbnRhaW5lciBpbiBDYy4gIAoKSnVzdCBpbiBjYXNlLCBJJ2xs
IHJlZG8gdGhlIHRlc3Qgb25jZSBtb3JlIHdpdGhvdXQgTFZNLgoKLS0gCi0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAg
ICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGlu
dGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
