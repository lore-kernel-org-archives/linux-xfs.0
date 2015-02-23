Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CE4F7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 05:18:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CE2B8F8052
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 03:18:14 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id 5a3f2ECMoqHhLfx1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 03:18:11 -0800 (PST)
Date: Mon, 23 Feb 2015 12:18:12 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS/LVM/Multipath on a single RAID volume
Message-ID: <20150223121812.5077ff07@harpe.intellique.com>
In-Reply-To: <54EA67B7.30805@binghamton.edu>
References: <5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
	<515361B5.8050603@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu> <20130331012231.GJ6369@dastard>
	<515C3BF3.60601@binghamton.edu> <51684382.50008@binghamton.edu>
	<5168AC0B.5010100@hardwarefreak.com>
	<516C649A.8010003@binghamton.edu>
	<20130416161841.GB13938@destitution>
	<54EA67B7.30805@binghamton.edu>
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
To: Dave Hall <kdhall@binghamton.edu>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

TGUgU3VuLCAyMiBGZWIgMjAxNSAxODozNToxOSAtMDUwMApEYXZlIEhhbGwgPGtkaGFsbEBiaW5n
aGFtdG9uLmVkdT4gw6ljcml2YWl0OgoKPiBTbyBzaW5jZSBJIGhhdmUgYSBmcmVzaCBhcnJheSB0
aGF0J3Mgbm90IGluIHByb2R1Y3Rpb24geWV0IEkgd2FzCj4gaG9waW5nIHRvIGdldCBzb21lIHBv
aW50ZXJzIG9uIGhvdyB0byBjb25maWd1cmUgaXQgdG8gbWF4aW1pemUgWEZTIAo+IHBlcmZvcm1h
bmNlLiAgSW4gcGFydGljdWxhciwgSSd2ZSBzZWVuIGEgc3VnZ2VzdGlvbiB0aGF0IGEKPiBtdWx0
aXBhdGhlZCBhcnJheSBzaG91bGQgYmUgc2xpY2VkIHVwIGludG8gbG9naWNhbCBkcml2ZXMgYW5k
IHBhc3RlZAo+IGJhY2sgdG9nZXRoZXIgd2l0aCBMVk0uICBXb25kZXJpbmcgYWxzbyBhYm91dCBw
dXR0aW5nIHRoZSBqb3VybmFsIGluCj4gYSBzZXBhcmF0ZSBsb2dpY2FsIGRyaXZlIG9uIHRoZSBz
YW1lIGFycmF5LgoKV2hhdCdzIHRoZSBoYXJkd2FyZSBjb25maWd1cmF0aW9uIGxpa2U/IGJlZm9y
ZSBtdWx0aXBhdGhpbmcsIHlvdSBuZWVkCnRvIGtub3cgaWYgeW91ciBSQUlEIGNvbnRyb2xsZXIg
YW5kIGRpc2tzIGNhbiBhY3R1YWxseSBzYXR1cmF0ZSB5b3VyCmxpbmsuIEdlbmVyYWxseSBTQVMt
YXR0YWNoZWQgZW5jbG9zdXJlcyBhcmUgZHJpdmVuIHRocm91Z2ggYSA0IHdheQpTRkYtODA4OCBj
YWJsZSwgd2l0aCBhIGJhbmR3aWR0aCBvZiA0eCA2R2JwcyAobWF4aW11bSB0aHJvdWdocHV0IHBl
cgpsaW5rOiAzIEdCL3MpIG9yIDQgeCAxMiBHYnBzIChtYXggdGhydXB1dDogNiBHQi9zKS4KCj4g
SSBhbSBhYmxlIHRvIHNldCB1cCBhIDItd2F5IG11bHRpcGF0aCByaWdodCBub3csIGFuZCBJIG1p
Z2h0IGJlIGFibGUKPiB0byBqdXN0aWZ5IGFkZGluZyBhIHNlY29uZCBjb250cm9sbGVyIHRvIHRo
ZSBhcnJheSB0byBnZXQgYSA0LXdheQo+IG11bHRpcGF0aCBnb2luZy4KCkEgbXVsdGlwYXRoIGNh
biBkb3VibGUgdGhlIHRocm91Z2hwdXQsIHByb3ZpZGVkIHRoYXQgeW91IGhhdmUgZW5vdWdoCmRy
aXZlczogeW91J2xsIG5lZWQgYWJvdXQgMjQgN2sgUlBNIGRyaXZlcyB0byBzYXR1cmF0ZSBfb25l
XyA0eDZHYnBzClNBUyBsaW5rLiBJZiB5b3UgaGF2ZSBvbmx5IDEyIGRyaXZlcywgZHVhbCBhdHRh
Y2htZW50IHByb2JhYmx5IHdvbid0CnlpZWxkIG11Y2guCgo+IEV2ZW4gaWYgdGhlIExWTSBhcHBy
b2FjaCBpcyB0aGUgd3Jvbmcgb25lLCBJIGNsZWFybHkgaGF2ZSBhIHJhcmUKPiBjaGFuY2UgdG8g
c2V0IHRoaXMgYXJyYXkgdXAgdGhlIHJpZ2h0IHdheS4gIFBsZWFzZSBsZXQgbWUga25vdyBpZiB5
b3UKPiBoYXZlIGFueSBzdWdnZXN0aW9ucy4KCkluIG15IGV4cGVyaWVuY2UsIHNvZnR3YXJlIFJB
SUQtMCB3aXRoIG1kIGdpdmVzIHNsaWdodGx5IGJldHRlcgpwZXJmb3JtYW5jZSB0aGFuIExWTSwg
dGhvdWdoIG5vdCBtdWNoLgoKCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAg
ICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxp
cXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAg
ICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
