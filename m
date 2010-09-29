Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8THrfkt072167 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 12:53:41 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93853B2BDD
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 10:54:38 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id K1fze0Ngqsd6nw6g for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 10:54:38 -0700 (PDT)
Received: from chello087207113141.chello.pl ([87.207.113.141]:38232
	helo=tarm.maven.pl)
	by smtp-relay.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.72) (envelope-from <arekm@maven.pl>) id 1P10rU-0002WF-A7
	for xfs@oss.sgi.com; Wed, 29 Sep 2010 19:54:36 +0200
Received: from arekm by tarm.maven.pl with local (Exim 4.72)
	(envelope-from <arekm@maven.pl>) id 1P10rQ-000625-Bv
	for xfs@oss.sgi.com; Wed, 29 Sep 2010 19:54:32 +0200
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: [PATCH 2/2] xfstests: Use $MKFS_OPTIONS in _scratch_mkfs_*()
Date: Wed, 29 Sep 2010 19:54:32 +0200
References: <1285770951-27000-1-git-send-email-lczerner@redhat.com>
	<1285770951-27000-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1285770951-27000-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Message-Id: <201009291954.32292.arekm@maven.pl>
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

T24gV2VkbmVzZGF5IDI5IG9mIFNlcHRlbWJlciAyMDEwLCBMdWthcyBDemVybmVyIHdyb3RlOgo+
IFBhc3MgTUtGU19PUFRJT05TIHRvIG1rZnMuJEZTVFlQIGluIF9zY3JhdGNoX21rZnNfc2l6ZWQo
KS4KPiBQcmVzZXJ2ZSB1c2VyIGRlZmluZWQgTUtGU19PUFRJT05TIGluIF9zY3JhdGNoX21rZnNf
Z2VvbSgpLgo+IC0tLQo+ICBjb21tb24ucmMgfCAgICA2ICsrKy0tLQo+ICAxIGZpbGVzIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvY29t
bW9uLnJjIGIvY29tbW9uLnJjClsuLi5dCj4gICAgICBjYXNlICRGU1RZUCBpbgo+ICAgICAgeGZz
KQo+IC0JTUtGU19PUFRJT05TPSItYiBzaXplPSRibG9ja3NpemUsIC1kIHN1PSRzdW5pdF9ieXRl
cyxzdz0kc3dpZHRoX211bHQiCj4gKwlNS0ZTX09QVElPTlMrPSItYiBzaXplPSRibG9ja3NpemUs
IC1kIHN1PSRzdW5pdF9ieXRlcyxzdz0kc3dpZHRoX211bHQiCgpjb21tb24ucmMgdXNlcyAvYmlu
L3NoIGFuZCArPSBub3RhdGlvbiBpcyBhIGJhc2hpem0uIFdvbid0IHdvcmsgb24gc3RyaWN0IApw
b3NpeCBzaGVsbHMuCgotLSAKQXJrYWRpdXN6IE1pxZtraWV3aWN6ICAgICAgICBQTEQvTGludXgg
VGVhbQphcmVrbSAvIG1hdmVuLnBsICAgICAgICAgICAgaHR0cDovL2Z0cC5wbGQtbGludXgub3Jn
LwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
