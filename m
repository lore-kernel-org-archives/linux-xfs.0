Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T2QULl028779 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 21:26:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80FCC120C4DF
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:28:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Liwo4Ar6aCm2A1zA for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 19:28:34 -0700 (PDT)
Date: Thu, 29 Apr 2010 12:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: write both features2 fields when xfs_admin
	changes lazy_count
Message-ID: <20100429022825.GD2512@dastard>
References: <4BD8E9F8.4090701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BD8E9F8.4090701@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Marcin =?utf-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>, xfs-oss <xfs@oss.sgi.com>

T24gV2VkLCBBcHIgMjgsIDIwMTAgYXQgMDk6MDc6NTJQTSAtMDUwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IHhmc19hZG1pbiAtYyBpbnZva2VzIHJlcGFpciBkaXJlY3RseSB0byBjaGFuZ2UgbGF6
eV9jb3VudCwKPiBidXQgaXQgZG9lc24ndCB3cml0ZSBib3RoIGZlYXR1cmVzMiBmaWVsZHMsIHNv
IHRoaXM6Cj4gCj4gIyBta2ZzLnhmcyAtZGZpbGUsbmFtZT1mc2ZpbGUsc2l6ZT0xMGcgLWxsYXp5
LWNvdW50PTAKPiAjIHhmc19hZG1pbiAtYyAxIGZzZmlsZQo+ICMgeGZzX3JlcGFpciBmc2ZpbGUK
PiAKPiB5aWVsZHMgZXJyb3JzLgo+IAo+IFJlcG9ydGVkLWJ5OiBNYXJjaW4gTWlyb3PFgmF3IDxt
YXJjaW5AbWVqb3IucGw+Cj4gU2lnbmVkLW9mZi1ieTogRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNh
bmRlZW4ubmV0PgoKUmV2aWV3ZWQtYnk6IERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNv
bT4KCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3Nz
LnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
