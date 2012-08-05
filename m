Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q75FsLHC234451 for <xfs@oss.sgi.com>; Sun, 5 Aug 2012 10:54:21 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id gmr3GN4AhJVchg53 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 05 Aug 2012 08:54:20 -0700 (PDT)
Message-ID: <501E9734.8020905@profihost.ag>
Date: Sun, 05 Aug 2012 17:54:28 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs_growfs / planned resize / performance impact
References: <5017E426.2040709@profihost.ag> <501B4D7E.1000303@sandeen.net>
	<501B6B04.2090002@profihost.ag>
	(sfid-20120803_140801_426027_0A33D973)
	<201208051303.09337.Martin@lichtvoll.de>
In-Reply-To: <201208051303.09337.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

QW0gMDUuMDguMjAxMiAxMzowMywgc2NocmllYiBNYXJ0aW4gU3RlaWdlcndhbGQ6Cj4gQW0gRnJl
aXRhZywgMy4gQXVndXN0IDIwMTIgc2NocmllYiBTdGVmYW4gUHJpZWJlIC0gUHJvZmlob3N0IEFH
Ogo+IEJ1dCB0aGVuIHlvdSBkaWRuwrR0IGRlc2NyaWJlIHdoZXJlIHRob3NlIFZNIGRpc2tzIGFy
ZSBsb2NhdGVkLiBJZiB0aGF0Cj4gbG9jYXRpb24gaGFzIG1hbnkgc3BpbmRsZXMgaXQgbWlnaHQg
bm90IG1hdHRlciBhdCBhbGwgb3IgZXZlbiBpbXByb3ZlCj4gcGVyZm9ybWFuY2UuCjMwIGRpc2tz
IHJhaWQgNTAgdmlhIExJTyBpU0NTSSBhbmQgTFZNLgoKPiBBbnl3YXksIEkgZG8gbm90IHNlZSBt
dWNoIHNlbnNlIHRvIG1ha2UgdGhlbSAzMCBHaUIgd2hlbiB0aGV5IGNhbiBncm93IHRvCj4gNTAw
IEdpQiDigJMgYXQgbGVhc3QgcHJvdmlkZWQgdGhhdCB5b3UgdXNlIHRoaW4gcHJvdmlzaW9uaW5n
LiBDYXVzZQo+IHhmc19ncm93ZnMgYW5kIHJlc2l6aW5nIHRoZSBpbWFnZSB3aWxsIGxpa2VseSBi
ZSBhIG1hbnVhbCBzdGVwIHdoaWxlIHRoaW4KPiBwcm92aXNpb25pbmcgZ29lcyBhdXRvbWF0aWNh
bGx5IGFuZCBvbmx5IG5lZWRzIHRvIGJlIG1vbml0b3JlZC4KSSBkbyBub3QgdXNlIHRoaW4gcHJv
dmlzaW9uaW5nIGFzIGRtIHRoaW4gaXMgbm90IHByb2R1Y3Rpb24gcmVhZHkgaXNuJ3QgaXQ/Cgo+
IFRoYXQgbWFudWFsIHN0ZXAgbWFrZXMgc2Vuc2UgdG91Z2ggaWYgeW91IHdhbnQgdG8gZ3VhcmVu
dGVlIGFsbCB0aGUgc3BhY2UKPiB0aGF0cyB2aXNpYmx5IGluIGRmIG91dHB1dCBpcyByZWFsbHkg
cGh5c2ljYWxseSBhdmFpbGFibGUsIHdpdGhvdXQKPiBwcm92aWRpbmcgZm9yIHggdGltZXMgNTAw
IEdpQiBpbml0aWFsbHkuCk9oIGkgY2FuIGVhc2lseSBhdXRvbWF0ZSB0aGUgd2hvbGUgcmVzaXpp
bmcgc3R1ZmYuCgpTdGVmYW4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
