Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 939DA7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:17:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64E888F8035
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 04:17:18 -0700 (PDT)
Received: from mr002msb.fastweb.it (mr002msb.fastweb.it [85.18.95.86]) by
	cuda.sgi.com with ESMTP id 5ucqAuQkc9S9RCvq for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 04:17:15 -0700 (PDT)
Subject: Re: LVM snapshot and log record CRC mismatch
References: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
	<20160524221205.GM21200@dastard> <57455645.5040608@assyoma.it>
	<20160526122315.4112f713@harpe.intellique.com>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <5746DB30.5040006@assyoma.it>
Date: Thu, 26 May 2016 13:17:04 +0200
MIME-Version: 1.0
In-Reply-To: <20160526122315.4112f713@harpe.intellique.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Gionatan Danti <g.danti@assyoma.it>, xfs@oss.sgi.com

T24gMjYvMDUvMjAxNiAxMjoyMywgRW1tYW51ZWwgRmxvcmFjIHdyb3RlOgo+IExlIFdlZCwgMjUg
TWF5IDIwMTYgMDk6Mzc6NDEgKzAyMDAKPiBHaW9uYXRhbiBEYW50aSA8Zy5kYW50aUBhc3N5b21h
Lml0PiDDqWNyaXZhaXQ6Cj4KPj4gVGhlIHNuYXBzaG90IGlzIGFjY29tcGxpc2hlZCB1c2luZyB0
aGUgZm9sbG93aW5nIGNvbW1hbmRzOgo+Pgo+PiBsdmNyZWF0ZSAtcyBoeXBlcnZpc29yL0tWTV9T
dG9yYWdlIC0tbmFtZSBCYWNrdXBfU05BUAo+PiBsdmNoYW5nZSAtYXkgLUsgaHlwZXJ2aXNvci9C
YWNrdXBfU05BUAo+PiBtb3VudCAtbyBub3V1aWQgL2Rldi9oeXBlcnZpc29yL0JhY2t1cF9TTkFQ
IC9tbnQvbHZtLwo+Pgo+Cj4gWW91IG5lZWQgdG8gdXNlIHhmc19mcmVlemUgdG8gbWFrZSB0aGUg
ZmlsZXN5c3RlbSBjb2hlcmVudCBiZWZvcmUKPiBzbmFwc2hvdDoKPgo+IHhmc19mcmVlemUgL2Rl
di9oeXBlcnZpc29yL0tWTV9TdG9yYWdlCj4gbHZjcmVhdGUgLXMgaHlwZXJ2aXNvci9LVk1fU3Rv
cmFnZSAtLW5hbWUgQmFja3VwX1NOQVAKPiB4ZnNfZnJlZXplIC11IC9kZXYvaHlwZXJ2aXNvci9L
Vk1fU3RvcmFnZQo+IGx2Y2hhbmdlIC1heSAtSyBoeXBlcnZpc29yL0JhY2t1cF9TTkFQCj4KCkl0
IHdhcyBteSB1bmRlcnN0YW5kaW5nIHRoYXQgZmlsZXN5c3RlbSBmcmVlemluZyB3YXMgYXV0b21h
dGljYWxseSAKbWFuYWdlZCBieSBMVk0sIGFuZCBpbnRlZ3JhdGVkIGludG8gVkZTIGxvbmcgYWdv
LgoKSSBhbSBtaXNzaW5nIHNvbWV0aGluZz8KCi0tIApEYW50aSBHaW9uYXRhbgpTdXBwb3J0byBU
ZWNuaWNvCkFzc3lvbWEgUy5yLmwuIC0gd3d3LmFzc3lvbWEuaXQKZW1haWw6IGcuZGFudGlAYXNz
eW9tYS5pdCAtIGluZm9AYXNzeW9tYS5pdApHUEcgcHVibGljIGtleSBJRDogRkY1RjMyQTgKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5n
IGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZv
L3hmcwo=
