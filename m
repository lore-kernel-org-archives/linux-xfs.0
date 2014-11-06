Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B7F17F55
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 08:27:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39A73304043
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 06:27:56 -0800 (PST)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id 9ili2qyfv2EzmDAN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 06:27:39 -0800 (PST)
Date: Thu, 6 Nov 2014 15:27:41 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: EIO and data corruption on XFS file system
Message-ID: <20141106152741.2655245d@harpe.intellique.com>
In-Reply-To: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>
References: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>
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
To: GuangYang <yguang11@outlook.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

TGUgVGh1LCA2IE5vdiAyMDE0IDEzOjAzOjQ1ICswMDAwCkd1YW5nWWFuZyA8eWd1YW5nMTFAb3V0
bG9vay5jb20+IMOpY3JpdmFpdDoKCj4gSGVsbG8sV2hpbGUgd29ya2luZyBvbiB0aGUgc3RvcmFn
ZSBzeXN0ZW0sIEkgZ290IG9uZSBxdWVzdGlvbiBpbgo+IHRlcm1zIG9mIHRoZSBYRlMgdXRpbGl0
aWVzIHRvIGZpeCBmaWxlIHN5c3RlbSBjb3JydXB0aW9uLiBCYXNpY2FsbHksCj4gb3VyIHN0b3Jh
Z2Ugc3lzdGVtIHB1dCAzIGNvcGllcyBvZiBkYXRhIGFuZCB0aGUgc3lzdGVtIHdvdWxkIGRldGVj
dAo+IGRhdGEgaW5jb25zaXN0ZW5jeSBvbiByZWd1bGFyIGJhc2lzLCB0aGVyZSBhcmUgdHdvIHBh
dHRlcm5zIHdlCj4gb2JzZXJ2ZWQgc28gZmFyOiAxKSB0aGUgZGF0YSBpcyBjb3JydXB0ZWQgd2hp
Y2ggcmVzdWx0IGluIGFuIEVJTywgMikKPiBkYXRhIGlzIHN0aWxsIGFjY2Vzc2libGUgYnV0IHRo
ZSBjb250ZW50IGlzIGNoYW5nZWQuIEkgYW0gd29uZGVyaW5nCj4gdGhlIHdheSB0byBmaXggc3Vj
aCBpc3N1ZXMgZnJvbSBmaWxlIHN5c3RlbSdzIHBlcnNwZWN0aXZlLCBkbyB3ZQo+IGV4cGVjdCBo
YXJkd2FyZSBmYWlsdXJlIGZvciBib3RoIGNhc2VzIG9yIHNvbWUgeGZzIHJlcGFpcmluZyB0b29s
cwo+IGNvdWxkIGhlbHAgZm9yIHN1Y2ggY2FzZT8KClhGUyByZWxpZXMgb24gdGhlIHVuZGVybHlp
bmcgaGFyZHdhcmUgdG8gbWFpbnRhaW4gZGF0YSBpbnRlZ3JpdHkuIFRoZQpsYXRlc3QgWEZTIHZl
cnNpb24gY29tZXMgd2l0aCBtZXRhZGF0YSBjaGVja3N1bXMsIHdoaWNoIGFsbG93cwpjb3JyZWN0
aW5nIGludmFsaWQgZGF0YSBpbiBmaWxlc3lzdGVtIHN0cnVjdHVyZXMsIGJ1dCBub3QgZGF0YS4K
CkdlbmVyYWxseSBzcGVha2luZywgaWYgdGhlIGRhdGEgaXMgY29ycnVwdGVkIGJlY2F1c2Ugb2Yg
ZmF1bHR5IGhhcmR3YXJlLAp4ZnNfcmVwYWlyIGNhbid0IGhlbHAuCgpyZWdhcmRzLAotLSAKLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCkVtbWFudWVsIEZsb3JhYyAgICAgfCAgIERpcmVjdGlvbiB0ZWNobmlxdWUK
ICAgICAgICAgICAgICAgICAgICB8ICAgSW50ZWxsaXF1ZQogICAgICAgICAgICAgICAgICAgIHwJ
PGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+CiAgICAgICAgICAgICAgICAgICAgfCAgICszMyAxIDc4
IDk0IDg0IDAyCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
