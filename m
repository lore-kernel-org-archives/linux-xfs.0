Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0944C7F85
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 03:19:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCFF88F8068
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 01:19:18 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	l0LgnuGpFoyGAMOA for <xfs@oss.sgi.com>;
	Wed, 10 Jun 2015 01:19:16 -0700 (PDT)
Date: Wed, 10 Jun 2015 18:19:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150610081914.GV9143@dastard>
References: <20150610070604.GA9855@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150610070604.GA9855@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

T24gV2VkLCBKdW4gMTAsIDIwMTUgYXQgMTI6MDY6MDRBTSAtMDcwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gaGNoQGJyaWNrOn4vd29yay94ZnNwcm9ncyQgbWFrZQo+IEJ1aWxkaW5nIGlu
Y2x1ZGUKPiBCdWlsZGluZyBsaWJ4ZnMKPiAgICAgW1RFU1RdICAgIENSQzMyCj4gSW4gZmlsZSBp
bmNsdWRlZCBmcm9tIGNyYzMyLmM6NjE6MDoKPiBjcmMzMnRhYmxlLmg6NDoxOiBlcnJvcjog4oCY
X19sZTMy4oCZIHVuZGVjbGFyZWQgaGVyZSAobm90IGluIGEKPiBmdW5jdGlvbikKPiBjcmMzMnRh
YmxlLmg6NDoxOiBlcnJvcjogZXhwZWN0ZWQgZXhwcmVzc2lvbiBiZWZvcmUg4oCYX191MzLigJkK
PiBjcmMzMnRhYmxlLmg6NDoyMDogZXJyb3I6IGV4cGVjdGVkIGV4cHJlc3Npb24gYmVmb3JlIOKA
mF9fdTMy4oCZCj4gY3JjMzJ0YWJsZS5oOjQ6Mzk6IGVycm9yOiBleHBlY3RlZCBleHByZXNzaW9u
IGJlZm9yZSDigJhfX3UzMuKAmQo+IGNyYzMydGFibGUuaDo0OjU4OiBlcnJvcjogZXhwZWN0ZWQg
ZXhwcmVzc2lvbiBiZWZvcmUg4oCYX191MzLigJkKPiBjcmMzMnRhYmxlLmg6NToxOiBlcnJvcjog
ZXhwZWN0ZWQgZXhwcmVzc2lvbiBiZWZvcmUg4oCYX191MzLigJkKPiBjcmMzMnRhYmxlLmg6NToy
MDogZXJyb3I6IGV4cGVjdGVkIGV4cHJlc3Npb24gYmVmb3JlIOKAmF9fdTMy4oCZCj4gY3JjMzJ0
YWJsZS5oOjU6Mzk6IGVycm9yOiBleHBlY3RlZCBleHByZXNzaW9uIGJlZm9yZSDigJhfX3UzMuKA
mQo+IGNyYzMydGFibGUuaDo1OjU4OiBlcnJvcjogZXhwZWN0ZWQgZXhwcmVzc2lvbiBiZWZvcmUg
4oCYX191MzLigJkKPiAKPiAuLi4gYW5kIHNvIG9uCj4gCj4gU2VlbXMgbGlrZSB3ZSdyZSBub3Qg
Z2V0dGluZyB0aGUgcmlnaHQgaGVhZGVycyBpbmNsdWRlZCBpbiB0aGlzCj4gZ2VuZXJhdGVkIGZp
bGUsIGJ1dCBJJ20gbG9zdCBvbiB3aGF0IGV4YWN0bHkgaXMgdGhlIGVycm9yLgoKRG9lcyB0aGUg
cHJvYmxlbSBnbyBhd2F5IGFmdGVyIGEgJ21ha2UgZGlzdGNsZWFuJz8KCkNoZWVycywKCkRhdmUu
Ci0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
