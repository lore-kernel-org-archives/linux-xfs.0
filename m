Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2C6n4YV206368 for <xfs@oss.sgi.com>; Sat, 12 Mar 2011 00:49:09 -0600
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 158BF1DE7DBE
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 22:51:43 -0800 (PST)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id gPcBt2XBkD2GwFDd for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2011 22:51:43 -0800 (PST)
Received: from 87-207-113-141.dynamic.chello.pl ([87.207.113.141]:46749
	helo=tarm.maven.pl)
	by smtp-relay.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.73) (envelope-from <arekm@maven.pl>) id 1PyIfu-0003Vu-AO
	for xfs@oss.sgi.com; Sat, 12 Mar 2011 07:51:42 +0100
Received: from arekm by tarm.maven.pl with local (Exim 4.74)
	(envelope-from <arekm@maven.pl>) id 1PyIft-00054l-Oc
	for xfs@oss.sgi.com; Sat, 12 Mar 2011 07:51:41 +0100
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.37: mount with quota eats all available memory
Date: Sat, 12 Mar 2011 07:51:41 +0100
References: <201103112258.48742.arekm@maven.pl>
	<201103112302.57445.arekm@maven.pl>
In-Reply-To: <201103112302.57445.arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201103120751.41704.arekm@maven.pl>
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
To: xfs@oss.sgi.com

T24gRnJpZGF5IDExIG9mIE1hcmNoIDIwMTEsIEFya2FkaXVzeiBNaXNraWV3aWN6IHdyb3RlOgo+
IE9uIEZyaWRheSAxMSBvZiBNYXJjaCAyMDExLCBBcmthZGl1c3ogTWlza2lld2ljeiB3cm90ZToK
PiA+IEkgaGF2ZSBhIG1hY2hpbmUgd2l0aCA0R0IsIHJ1bm5pbmcgNjRiaXQgMi42LjM3LCB4ZnMg
b24gdG9wIG9mIHNvZnQKPiA+IHJhaWQ1Lgo+ID4gCj4gPiBSZWNlbnRseSBhZnRlciB1c2luZyB4
ZnNfZnNyIChhbmQgZ2V0dGluZyBhIG9vcHMpIGhhZCB0byBkbyB4ZnNfcmVwYWlyCj4gPiBhbmQg
bm93IEknbSBubyBsb25nZXIgYWJsZSB0byBtb3VudCB0aGlzIGZpbGVzeXN0ZW0gd2l0aCB1c3Jx
dW90YSBhbmQKPiA+IGdycHF1b3RhLgo+IAo+IFNvbWUgZGF0YSBhYm91dCBmczoKPiAjIExDX0FM
TD1DIHhmc19pbmZvIC9ob21lCj4gbWV0YS1kYXRhPS9kZXYvbWQzICAgICAgICAgICAgICAgaXNp
emU9MjU2ICAgIGFnY291bnQ9MzIsIGFnc2l6ZT02NTY0MTI4Cj4gYmxrcyA9ICAgICAgICAgICAg
ICAgICAgICAgICBzZWN0c3o9NDA5NiAgYXR0cj0wCj4gZGF0YSAgICAgPSAgICAgICAgICAgICAg
ICAgICAgICAgYnNpemU9NDA5NiAgIGJsb2Nrcz0yMTAwNTE3NzYsIGltYXhwY3Q9MjUKPiAgICAg
ICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBzdW5pdD0xNiAgICAgc3dpZHRoPTQ4IGJsa3MK
PiBuYW1pbmcgICA9dmVyc2lvbiAyICAgICAgICAgICAgICBic2l6ZT00MDk2ICAgYXNjaWktY2k9
MAo+IGxvZyAgICAgID1pbnRlcm5hbCAgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9
MzI3NjgsIHZlcnNpb249Mgo+ICAgICAgICAgID0gICAgICAgICAgICAgICAgICAgICAgIHNlY3Rz
ej00MDk2ICBzdW5pdD0xIGJsa3MsIGxhenktY291bnQ9MAo+IHJlYWx0aW1lID1ub25lICAgICAg
ICAgICAgICAgICAgIGV4dHN6PTE5NjYwOCBibG9ja3M9MCwgcnRleHRlbnRzPTAKPiAjIGNhdCAv
cHJvYy9tZHN0YXQKPiBQZXJzb25hbGl0aWVzIDogW3JhaWQxMF0gW3JhaWQxXSBbcmFpZDZdIFty
YWlkNV0gW3JhaWQ0XQo+IG1kMyA6IGFjdGl2ZSByYWlkNSBzZGE0WzBdIHNkZDRbM10gc2RjNFsy
XSBzZGI0WzFdCj4gICAgICAgODQwMjA3MTY4IGJsb2NrcyBsZXZlbCA1LCA2NGsgY2h1bmssIGFs
Z29yaXRobSAyIFs0LzRdIFtVVVVVXQo+ICAgICAgIGJpdG1hcDogMi8zIHBhZ2VzIFs4S0JdLCA2
NTUzNktCIGNodW5rCgpNb3JlIGluZm8sIHRlc3RlZCBjdXJyZW50IGxpbnVzIDIuNi4zOGdpdCBp
bmNsdWRpbmcgInhmczogUmVkdWNlIE9PTSBraWxsIApwcm9ibGVtcyB1bmRlciBoZWF2eSBsb2Fk
IFYyIiBwYXRjaHNldCBidXQgdGhlIHJlc3VsdCB3YXNuJ3QgbXVjaCBiZXR0ZXI6CgozNTQ5OTIx
IDM1NDk5MjEgMTAwJSAgICAxLjA2SyAxMzI3OTEgICAgICAgMzAgICA0MjQ5MzEySyB4ZnNfaW5v
ZGUKKGZyb20gc2xhYnRvcCksIG1hY2hpbmUgYmVjYW1lIHVucmVzcG9uc2libGUgYW5kIHJlYm9v
dGVkLgoKSSB3b25kZXIgaWYgOEdCIG9mIHJhbSB3b3VsZCBiZSBlbm91Z2ggZm9yIHRoaXMgODAw
R0IgZnMgdG8gbW91bnQuCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3ogICAgICAgIFBMRC9MaW51
eCBUZWFtCmFyZWttIC8gbWF2ZW4ucGwgICAgICAgICAgICBodHRwOi8vZnRwLnBsZC1saW51eC5v
cmcvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMg
bWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9s
aXN0aW5mby94ZnMK
