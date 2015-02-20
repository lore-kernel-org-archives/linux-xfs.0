Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB24D7F6F
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 07:22:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B935E304032
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 05:22:34 -0800 (PST)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
	[209.85.217.174]) by cuda.sgi.com with ESMTP id
	2ADMCwTTGQbrhrEr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 05:22:29 -0800 (PST)
Received: by lbvn10 with SMTP id n10so6225080lbv.4
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 05:22:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <44893EA7-B11A-469A-9911-6CE2E8B26EB4@dilger.ca>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<44893EA7-B11A-469A-9911-6CE2E8B26EB4@dilger.ca>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 20 Feb 2015 14:22:07 +0100
Message-ID: <CAKgNAkj4EtiWpxOPFtfYn4=E1ukLjESwe7yvyNHdp04BP+kj-g@mail.gmail.com>
Subject: Re: Documenting MS_LAZYTIME
Reply-To: mtk.manpages@gmail.com
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-man <linux-man@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

T24gMjAgRmVicnVhcnkgMjAxNSBhdCAxMzozMiwgQW5kcmVhcyBEaWxnZXIgPGFkaWxnZXJAZGls
Z2VyLmNhPiB3cm90ZToKPiBPbiBGZWIgMjAsIDIwMTUsIGF0IDE6NTAgQU0sIE1pY2hhZWwgS2Vy
cmlzayA8bXRrLm1hbnBhZ2VzQGdtYWlsLmNvbT4gd3JvdGU6Cj4+Cj4+IEhlbGxvIFRlZCwKPj4K
Pj4gQmFzZWQgb24geW91ciBjb21taXQgbWVzc2FnZSAwYWU0NWY2M2Q0ZSwgSSBJIHdyb3RlIHRo
ZSBkb2N1bWVudGF0aW9uCj4+IGJlbG93IGZvciBNU19MQVpZVElNRSwgdG8gZ28gaW50byB0aGUg
bW91bnQoMikgbWFuIHBhZ2UuIENvdWxkIHlvdQo+PiBwbGVhc2UgY2hlY2sgaXQgb3ZlciBhbmQg
bGV0IG1lIGtub3cgaWYgaXQncyBhY2N1cmF0ZS4gSW4gcGFydGljdWxhciwKPj4gSSBhZGRlZCBw
aWVjZXMgbWFya2VkIHdpdGggIioiIGJlbG93IHRoYXQgd2VyZSBub3QgcGFydCBvZiB0aGUgY29t
bWl0Cj4+IG1lc3NhZ2UgYW5kIEknZCBsaWtlIGNvbmZpcm1hdGlvbiB0aGF0IHRoZXkncmUgYWNj
dXJhdGUuCj4+Cj4+IFRoYW5rcywKPj4KPj4gTWljaGFlbAo+Pgo+PiBbWwo+PiAgICAgICBNU19M
QVpZVElNRSAoc2luY2UgTGludXggMy4yMCkKPj4gICAgICAgICAgICAgIE9ubHkgIHVwZGF0ZSAg
ZmlsZXRpbWVzIChhdGltZSwgbXRpbWUsIGN0aW1lKSBvbiB0aGUgaW4tCj4+ICAgICAgICAgICAg
ICBtZW1vcnkgdmVyc2lvbiBvZiB0aGUgZmlsZSAgaW5vZGUuICAgVGhlICBvbi1kaXNrICB0aW1l
4oCQCj4+ICAgICAgICAgICAgICBzdGFtcHMgYXJlIHVwZGF0ZWQgb25seSB3aGVuOgo+Pgo+PiAg
ICAgICAgICAgICAgKGEpICB0aGUgaW5vZGUgbmVlZHMgdG8gYmUgdXBkYXRlZCBmb3Igc29tZSBj
aGFuZ2UgdW5yZeKAkAo+PiAgICAgICAgICAgICAgICAgICBsYXRlZCB0byBmaWxlIHRpbWVzdGFt
cHM7Cj4+Cj4+ICAgICAgICAgICAgICAoYikgIHRoZSBhcHBsaWNhdGlvbiAgZW1wbG95cyAgZnN5
bmMoMiksICBzeW5jZnMoMiksICBvcgo+PiAgICAgICAgICAgICAgICAgICBzeW5jKDIpOwo+Pgo+
PiAgICAgICAgICAgICAgKGMpICBhbiB1bmRlbGV0ZWQgaW5vZGUgaXMgZXZpY3RlZCBmcm9tIG1l
bW9yeTsgb3IKPj4KPj4gKiAgICAgICAgICAgICAoZCkgIG1vcmUgdGhhbiAyNCBob3VycyBoYXZl
IHBhc3NlZCBzaW5jZSB0aGUgaS1ub2RlIHdhcwo+PiAqICAgICAgICAgICAgICAgICAgd3JpdHRl
biB0byBkaXNrLgo+Pgo+PiAgICAgICAgICAgICAgVGhpcyBtb3VudCBvcHRpb24gc2lnbmlmaWNh
bnRseSByZWR1Y2VzICB3cml0ZXMgIHRvICB0aGUKPj4gICAgICAgICAgICAgIGlub2RlICB0YWJs
ZSAgZm9yIHdvcmtsb2FkcyB0aGF0IHBlcmZvcm0gZnJlcXVlbnQgcmFuZG9tCj4+ICAgICAgICAg
ICAgICB3cml0ZXMgdG8gcHJlYWxsb2NhdGVkIGZpbGVzLgo+Pgo+PiAqICAgICAgICAgICAgIEFz
IGF0IExpbnV4IDMuMjAsIHRoaXMgb3B0aW9uIGlzIHN1cHBvcnRlZCBvbmx5IG9uIGV4dDQuCj4K
PiBJIF90aGlua18gdGhhdCB0aGUgbGF6eXRpbWUgbW91bnQgb3B0aW9uIGlzIGdlbmVyaWMgZm9y
IGFsbCBmaWxlc3lzdGVtcy4KPiBJIGJlbGlldmUgZXh0NCBoYXMgYW4gZXh0cmEgb3B0aW1pemF0
aW9uIGZvciBpdCwgYnV0IHRoYXQncyBpdC4KCkFoIHllcywgbG9va2luZyBhdCB0aGUgY29kZSBh
Z2FpbiwgdGhhdCBtYWtlcyBzZW5zZS4gSSB0aGluayB5b3UncmUKcmlnaHQsIGFuZCBJJ3ZlIHN0
cnVjayB0aGF0IGxhc3Qgc2VudGVuY2UuIFRoYW5rcywgQW5kcmVhcy4KCkNoZWVycywKCk1pY2hh
ZWwKCgotLSAKTWljaGFlbCBLZXJyaXNrCkxpbnV4IG1hbi1wYWdlcyBtYWludGFpbmVyOyBodHRw
Oi8vd3d3Lmtlcm5lbC5vcmcvZG9jL21hbi1wYWdlcy8KTGludXgvVU5JWCBTeXN0ZW0gUHJvZ3Jh
bW1pbmcgVHJhaW5pbmc6IGh0dHA6Ly9tYW43Lm9yZy90cmFpbmluZy8KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9z
cy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
