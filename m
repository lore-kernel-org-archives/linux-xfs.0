Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A4EC7FA7
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 04:26:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4ACEAC003
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 02:26:28 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id 81mbSZ5I6DXJjFyd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2015 02:26:22 -0700 (PDT)
Date: Thu, 2 Jul 2015 11:26:23 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-ID: <20150702112623.1c83d473@harpe.intellique.com>
In-Reply-To: <DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
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
To: Rasmus Borup Hansen <rbh@intomics.com>
Cc: xfs@oss.sgi.com

TGUgVGh1LCAyIEp1bCAyMDE1IDA5OjU4OjE5ICswMjAwClJhc211cyBCb3J1cCBIYW5zZW4gPHJi
aEBpbnRvbWljcy5jb20+IMOpY3JpdmFpdDoKCj4gVGhlIGZpbGUgdGhlbiB0dXJucyB1cCBpbiBs
b3N0K2ZvdW5kIGFuZCB3aGVuIEkgImxzIiBpdCBJIGdldCB0aGUKPiBzYW1lIGVycm9ycyBhZ2Fp
bi4gSSd2ZSB0cmllZCBkZWxldGluZyBpdCBmcm9tIGxvc3QrZm91bmQsIGJ1dCB0aGVuCj4geGZz
X3JlcGFpciBmaW5kcyBpdCBhZ2FpbiB3aXRoIGV4YWN0bHkgdGhlIHNhbWUgb3V0cHV0IGFzIHNo
b3cgYWJvdmUKPiBhbmQgcHV0cyBpdCBiYWNrLgo+IAo+IEFwYXJ0IGZyb20gdGhhdCwgZXZlcnl0
aGluZyBhcHBhcmVudGx5IHdvcmtzIGZpbmUuCj4gCj4gSXMgdGhlcmUgYSB3YXkgdG8gcGVybWFu
ZW50bHkgZ2V0IHJpZCBvZiB0aGUgZmlsZSBpbiBsb3N0K2ZvdW5kPyBJdHMKPiBzaXplIGlzIGFw
cGFyZW50bHkgMCBieXRlcy4KCllvdSBzaG91bGQgdHJ5IHRoZSBsYXRlc3QgeGZzX3JlcGFpciAo
My4yLjMgSUlSQykgaW5zdGVhZCBvZiB0aGUgc3RvY2sKVWJ1bnR1IHZlcnNpb24gKDMuMS54IHBy
b2JhYmx5KS4KCkluIGNhc2UgeW91IGRvbid0IGtub3cgaG93IHRvIGNvbXBpbGUgaXQsIEkndmUg
anVzdCB1cGxvYWRlZCBpdCB0aGVyZToKCmh0dHA6Ly91cGRhdGUuaW50ZWxsaXF1ZS5jb20vcHVi
L3hmc19yZXBhaXItMy4yLjMuZ3oKCm1kNXN1bSA6Cjc1NmEyODIyOGM3ZTY1N2NlODYyNmQyNzg1
MGY2MjYxICB4ZnNfcmVwYWlyLTMuMi4zLmd6CgpCZXdhcmUgb2YgYmluYXJpZXMgcHJvdmlkZWQg
Ynkgc3RyYW5nZXJzLCBob3dldmVyIHRoaXMgb25lIHNob3VsZCBiZQpmaW5lIDopIGd1bnppcCBp
dCBiZWZvcmUgdXNlLi4uCgotLSAKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkVtbWFudWVsIEZsb3JhYyAgICAg
fCAgIERpcmVjdGlvbiB0ZWNobmlxdWUKICAgICAgICAgICAgICAgICAgICB8ICAgSW50ZWxsaXF1
ZQogICAgICAgICAgICAgICAgICAgIHwJPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+CiAgICAgICAg
ICAgICAgICAgICAgfCAgICszMyAxIDc4IDk0IDg0IDAyCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
