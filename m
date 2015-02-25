Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2F607F54
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 05:49:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B170D304039
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 03:49:46 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id NDg7ePjDZqAoLAwV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Feb 2015 03:49:45 -0800 (PST)
Date: Wed, 25 Feb 2015 12:49:46 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS/LVM/Multipath on a single RAID volume
Message-ID: <20150225124946.1784b9ca@harpe.intellique.com>
In-Reply-To: <20150224223344.GE4251@dastard>
References: <5155F2B2.1010308@binghamton.edu> <20130331012231.GJ6369@dastard>
	<515C3BF3.60601@binghamton.edu> <51684382.50008@binghamton.edu>
	<5168AC0B.5010100@hardwarefreak.com>
	<516C649A.8010003@binghamton.edu>
	<20130416161841.GB13938@destitution>
	<54EA67B7.30805@binghamton.edu>
	<20150223121812.5077ff07@harpe.intellique.com>
	<54ECF573.9050106@binghamton.edu> <20150224223344.GE4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Hall <kdhall@binghamton.edu>, stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

TGUgV2VkLCAyNSBGZWIgMjAxNSAwOTozMzo0NCArMTEwMApEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IMOpY3JpdmFpdDoKCj4gPiBPbiBhbiBleGlzdGluZyBhcnJheSBiYXNlZCBv
biBzaW1pbGFyIGJ1dCBzbGlnaHRseSBzbG93ZXIgaGFyZHdhcmUsCj4gPiBJJ20gZ2V0dGluZyBt
aXNlcmFibGUgcGVyZm9ybWFuY2UuICBUaGUgYm90dGxlbmVjayBzZWVtcyB0byBiZSBvbgo+ID4g
dGhlIHNlcnZlciBzaWRlLiAgRm9yIHNwZWNpZmljcywgdGhlIGFycmF5IGlzIGxhaWQgb3V0IGFz
IGEgc2luZ2xlCj4gPiAyNlRCIHZvbHVtZSBhbmQgYXR0YWNoZWQgYnkgYSBzaW5nbGUgM0dicHMg
U0FTLiAgIAo+IAo+IFNvLCAzMDBNQi9zIG1heCB0aHJvdWdocHV0Lgo+IAoKQWggeWVzLCBtYXli
ZSBleHRlcm5hbCBSQUlEIGNvbnRyb2xsZXJzIGNhbiBvbmx5IHVzZSBvbmUgU0FTIGNoYW5uZWwK
b3V0IG9mIHRoZSA0IGF2YWlsYWJsZSwgdGhhdCB3b3VsZCBkZWZpbml0ZWx5IGxpbWl0IHBlcmZv
cm1hbmNlIGJhZGx5LgpUaGlzIGxpbWl0YXRpb24gZG9uJ3QgYXBwbHkgdG8gaW50ZXJuYWwgUkFJ
RCBjb250cm9sbGVycyAoQWRhcHRlYywgTFNJLApBcmVjYSkgZHJpdmluZyBhIEpCT0QgdGhvdWdo
LgoKSSdsbCBkbyBhIHNob3J0IGRpZ3Jlc3Npb24gb24gZXh0ZXJuYWwgc3RvcmFnZSBlbmNsb3N1
cmVzOiB0aGV5J3JlCm1vc3RseSB1c2VmdWwgdG8gcHJvdmlkZSByZWR1bmRhbnQgY29udHJvbGxl
cnMuIElmIHlvdSdyZSB1c2luZyBvbmx5IG9uZQpjb250cm9sbGVyLCBjaGVhcCBvbmVzIChzdWNo
IGFzIGluZm9ydHJlbmQsIFByb21pc2UgYW5kIHRoZSBsaWtlKSB3aWxsCmFsd2F5cyBwZXJmb3Jt
IHBvb3JseSBjb21wYXJlZCB0byBhIG1vZGVybiBQQ0llIFJBSUQgY29udHJvbGxlci4KCkhpZ2gt
ZW5kIHN0b3JhZ2UgZW5jbG9zdXJlcyAoRG90SGlsbCwgTmV0QXBwLCBldGMpIHdpdGggaGlnaC1i
YW5kd2lkdGgKYXR0YWNobWVudHMgKEZDIG9yIElCKSBwcm92aWRlIGJldHRlciBwZXJmb3JtYW5j
ZSBBTkQgcmVkdW5kYW5jeSwgYnV0CmF0IGEgaGVmdHkgcHJpY2UuCgpTbyBpZiB5b3Ugd2FudCBm
YXN0LCBjaGVhcCBhcnJheXMsIGRlZmluaXRlbHkgdXNlIEFkYXB0ZWMvTFNJL0FyZWNhIGFuZApz
aW1wbGUgSkJPRCBjaGFzc2lzIGxpa2Ugc3VwZXJtaWNybydzLgoKLS0gCi0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAg
ICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGlu
dGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
