Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VBwDa9175745
	for <linux-xfs@oss.sgi.com>; Wed, 31 Oct 2012 06:58:14 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id ssb6rDD68Lqif3hN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Wed, 31 Oct 2012 05:00:03 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1TTWxn-0002dg-Or
	for linux-xfs@oss.sgi.com; Wed, 31 Oct 2012 13:00:03 +0100
Received: from 46.245.145.42 ([46.245.145.42])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 31 Oct 2012 13:00:03 +0100
Received: from gaudenz by 46.245.145.42 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 31 Oct 2012 13:00:03 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1
	=?utf-8?b?b3IJZmlsZXN0cmVhbXM=?= option toxic ?)
Date: Wed, 31 Oct 2012 11:45:12 +0000 (UTC)
Message-ID: <loom.20121031T123118-966@post.gmane.org>
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard> <20121029012540.GO29378@dastard>
	<20121029121851.GQ29378@dastard> <508E79D4.5090507@univ-nantes.fr>
	<20121030013309.GX29378@dastard>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

CkhpCgpEYXZlIENoaW5uZXIgPGRhdmlkIDxhdD4gZnJvbW9yYml0LmNvbT4gd3JpdGVzOgoKPiAK
PiBPbiBNb24sIE9jdCAyOSwgMjAxMiBhdCAwMTo0MzowMFBNICswMTAwLCBZYW5uIER1cG9udCB3
cm90ZToKPiA+IExlIDI5LzEwLzIwMTIgMTM6MTgsIERhdmUgQ2hpbm5lciBhIMOpY3JpdCA6Cj4g
PiBPSywgdmVyeSBnbGFkIHRvIGhlYXIgeW91IHdlcmUgYWJsZSB0byByZXByb2R1Y2UgaXQuCj4g
PiBHb29kIGx1Y2ssIGFuZCBub3cgbGV0IHRoZSBjaGFzZSBiZWdpbiA6KQo+IAo+IE5vdCByZWFs
bHkgYSBodWdlIGNoYXNlLCBqdXN0IGEgc2ltcGxlIG1hdHRlciBvZiBpc29sYXRpb24uIFRoZQo+
IHBhdGNoIGJlbG93IHNob3VsZCBmaXggdGhlIHByb2JsZW0uCj4gCgpJIHJhbiBpbnRvIHRoZSBz
YW1lIGJ1ZyB0aGlzIG1vcm5pbmcgd2l0aCBteSBob21lIHBhcnRpdGlvbiBhZnRlciBhIGNyYXNo
IG9uCnN1c3BlbmQgdG8gcmFtLiBJIGNhbiBjb25maXJtIHRoYXQgdGhlIHBhdGNoIHBvc3RlZCB0
byB0aGUgbGlzdCBieSBEYXZlIGZpeGVzCnRoZSBwcm9ibGVtLiBJIGhhdmUgYSBiYWNrdXAgb2Yg
dGhlIHJhdyBsb2cgYW5kIHRoZSB3aG9sZSBmaWxlc3lzdGVtIGlmIHlvdSBuZWVkCml0IGZvciBm
dXJ0aGVyIGludmVzdGlnYXRpb24uCgpCVFc6IElzIHRoaXMgZml4IGFscmVhZHkgc2VudCB1cHN0
cmVhbT8gSSBjb3VsZCBub3QgZmluZCBpdCBhbnl3aGVyZS4gQnV0IHRoZW4KaXQgbWF5IGp1c3Qg
bm90IGJlIHRoZXJlIHlldC4KCkdhdWRlbnoKCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
