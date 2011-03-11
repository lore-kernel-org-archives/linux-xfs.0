Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2BM0KRG184727 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 16:00:25 -0600
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6866633BEC6
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 14:02:58 -0800 (PST)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id GYRVYAD7vV5GlCIU for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2011 14:02:58 -0800 (PST)
Received: from 87-207-113-141.dynamic.chello.pl ([87.207.113.141]:36999
	helo=tarm.maven.pl)
	by smtp-relay.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.73) (envelope-from <arekm@maven.pl>) id 1PyAQD-0008CE-UY
	for xfs@oss.sgi.com; Fri, 11 Mar 2011 23:02:57 +0100
Received: from arekm by tarm.maven.pl with local (Exim 4.74)
	(envelope-from <arekm@maven.pl>) id 1PyAQD-0001zM-FJ
	for xfs@oss.sgi.com; Fri, 11 Mar 2011 23:02:57 +0100
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.37: mount with quota eats all available memory
Date: Fri, 11 Mar 2011 23:02:57 +0100
References: <201103112258.48742.arekm@maven.pl>
In-Reply-To: <201103112258.48742.arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201103112302.57445.arekm@maven.pl>
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
IEkgaGF2ZSBhIG1hY2hpbmUgd2l0aCA0R0IsIHJ1bm5pbmcgNjRiaXQgMi42LjM3LCB4ZnMgb24g
dG9wIG9mIHNvZnQgcmFpZDUuCj4gCj4gUmVjZW50bHkgYWZ0ZXIgdXNpbmcgeGZzX2ZzciAoYW5k
IGdldHRpbmcgYSBvb3BzKSBoYWQgdG8gZG8geGZzX3JlcGFpciBhbmQKPiBub3cgSSdtIG5vIGxv
bmdlciBhYmxlIHRvIG1vdW50IHRoaXMgZmlsZXN5c3RlbSB3aXRoIHVzcnF1b3RhIGFuZAo+IGdy
cHF1b3RhLgoKClNvbWUgZGF0YSBhYm91dCBmczoKIyBMQ19BTEw9QyB4ZnNfaW5mbyAvaG9tZQpt
ZXRhLWRhdGE9L2Rldi9tZDMgICAgICAgICAgICAgICBpc2l6ZT0yNTYgICAgYWdjb3VudD0zMiwg
YWdzaXplPTY1NjQxMjggYmxrcwogICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBzZWN0
c3o9NDA5NiAgYXR0cj0wCmRhdGEgICAgID0gICAgICAgICAgICAgICAgICAgICAgIGJzaXplPTQw
OTYgICBibG9ja3M9MjEwMDUxNzc2LCBpbWF4cGN0PTI1CiAgICAgICAgID0gICAgICAgICAgICAg
ICAgICAgICAgIHN1bml0PTE2ICAgICBzd2lkdGg9NDggYmxrcwpuYW1pbmcgICA9dmVyc2lvbiAy
ICAgICAgICAgICAgICBic2l6ZT00MDk2ICAgYXNjaWktY2k9MApsb2cgICAgICA9aW50ZXJuYWwg
ICAgICAgICAgICAgICBic2l6ZT00MDk2ICAgYmxvY2tzPTMyNzY4LCB2ZXJzaW9uPTIKICAgICAg
ICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTQwOTYgIHN1bml0PTEgYmxrcywgbGF6
eS1jb3VudD0wCnJlYWx0aW1lID1ub25lICAgICAgICAgICAgICAgICAgIGV4dHN6PTE5NjYwOCBi
bG9ja3M9MCwgcnRleHRlbnRzPTAKIyBjYXQgL3Byb2MvbWRzdGF0ClBlcnNvbmFsaXRpZXMgOiBb
cmFpZDEwXSBbcmFpZDFdIFtyYWlkNl0gW3JhaWQ1XSBbcmFpZDRdCm1kMyA6IGFjdGl2ZSByYWlk
NSBzZGE0WzBdIHNkZDRbM10gc2RjNFsyXSBzZGI0WzFdCiAgICAgIDg0MDIwNzE2OCBibG9ja3Mg
bGV2ZWwgNSwgNjRrIGNodW5rLCBhbGdvcml0aG0gMiBbNC80XSBbVVVVVV0KICAgICAgYml0bWFw
OiAyLzMgcGFnZXMgWzhLQl0sIDY1NTM2S0IgY2h1bmsKCgotLSAKQXJrYWRpdXN6IE1pxZtraWV3
aWN6ICAgICAgICBQTEQvTGludXggVGVhbQphcmVrbSAvIG1hdmVuLnBsICAgICAgICAgICAgaHR0
cDovL2Z0cC5wbGQtbGludXgub3JnLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
