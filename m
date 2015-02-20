Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A17BC7F63
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 06:33:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FE008F8050
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 04:33:04 -0800 (PST)
Received: from mail-pd0-f178.google.com (mail-pd0-f178.google.com
	[209.85.192.178]) by cuda.sgi.com with ESMTP id
	zZqzmWH6BQjw2sum (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 04:33:02 -0800 (PST)
Received: by pdjg10 with SMTP id g10so7404734pdj.1
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 04:33:02 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: Documenting MS_LAZYTIME
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
Date: Fri, 20 Feb 2015 05:32:58 -0700
Message-Id: <44893EA7-B11A-469A-9911-6CE2E8B26EB4@dilger.ca>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
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
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

T24gRmViIDIwLCAyMDE1LCBhdCAxOjUwIEFNLCBNaWNoYWVsIEtlcnJpc2sgPG10ay5tYW5wYWdl
c0BnbWFpbC5jb20+IHdyb3RlOgo+IAo+IEhlbGxvIFRlZCwKPiAKPiBCYXNlZCBvbiB5b3VyIGNv
bW1pdCBtZXNzYWdlIDBhZTQ1ZjYzZDRlLCBJIEkgd3JvdGUgdGhlIGRvY3VtZW50YXRpb24KPiBi
ZWxvdyBmb3IgTVNfTEFaWVRJTUUsIHRvIGdvIGludG8gdGhlIG1vdW50KDIpIG1hbiBwYWdlLiBD
b3VsZCB5b3UKPiBwbGVhc2UgY2hlY2sgaXQgb3ZlciBhbmQgbGV0IG1lIGtub3cgaWYgaXQncyBh
Y2N1cmF0ZS4gSW4gcGFydGljdWxhciwKPiBJIGFkZGVkIHBpZWNlcyBtYXJrZWQgd2l0aCAiKiIg
YmVsb3cgdGhhdCB3ZXJlIG5vdCBwYXJ0IG9mIHRoZSBjb21taXQKPiBtZXNzYWdlIGFuZCBJJ2Qg
bGlrZSBjb25maXJtYXRpb24gdGhhdCB0aGV5J3JlIGFjY3VyYXRlLgo+IAo+IFRoYW5rcywKPiAK
PiBNaWNoYWVsCj4gCj4gW1sKPiAgICAgICBNU19MQVpZVElNRSAoc2luY2UgTGludXggMy4yMCkK
PiAgICAgICAgICAgICAgT25seSAgdXBkYXRlICBmaWxldGltZXMgKGF0aW1lLCBtdGltZSwgY3Rp
bWUpIG9uIHRoZSBpbi0KPiAgICAgICAgICAgICAgbWVtb3J5IHZlcnNpb24gb2YgdGhlIGZpbGUg
IGlub2RlLiAgIFRoZSAgb24tZGlzayAgdGltZeKAkAo+ICAgICAgICAgICAgICBzdGFtcHMgYXJl
IHVwZGF0ZWQgb25seSB3aGVuOgo+IAo+ICAgICAgICAgICAgICAoYSkgIHRoZSBpbm9kZSBuZWVk
cyB0byBiZSB1cGRhdGVkIGZvciBzb21lIGNoYW5nZSB1bnJl4oCQCj4gICAgICAgICAgICAgICAg
ICAgbGF0ZWQgdG8gZmlsZSB0aW1lc3RhbXBzOwo+IAo+ICAgICAgICAgICAgICAoYikgIHRoZSBh
cHBsaWNhdGlvbiAgZW1wbG95cyAgZnN5bmMoMiksICBzeW5jZnMoMiksICBvcgo+ICAgICAgICAg
ICAgICAgICAgIHN5bmMoMik7Cj4gCj4gICAgICAgICAgICAgIChjKSAgYW4gdW5kZWxldGVkIGlu
b2RlIGlzIGV2aWN0ZWQgZnJvbSBtZW1vcnk7IG9yCj4gCj4gKiAgICAgICAgICAgICAoZCkgIG1v
cmUgdGhhbiAyNCBob3VycyBoYXZlIHBhc3NlZCBzaW5jZSB0aGUgaS1ub2RlIHdhcwo+ICogICAg
ICAgICAgICAgICAgICB3cml0dGVuIHRvIGRpc2suCj4gCj4gICAgICAgICAgICAgIFRoaXMgbW91
bnQgb3B0aW9uIHNpZ25pZmljYW50bHkgcmVkdWNlcyAgd3JpdGVzICB0byAgdGhlCj4gICAgICAg
ICAgICAgIGlub2RlICB0YWJsZSAgZm9yIHdvcmtsb2FkcyB0aGF0IHBlcmZvcm0gZnJlcXVlbnQg
cmFuZG9tCj4gICAgICAgICAgICAgIHdyaXRlcyB0byBwcmVhbGxvY2F0ZWQgZmlsZXMuCj4gCj4g
KiAgICAgICAgICAgICBBcyBhdCBMaW51eCAzLjIwLCB0aGlzIG9wdGlvbiBpcyBzdXBwb3J0ZWQg
b25seSBvbiBleHQ0LgoKSSBfdGhpbmtfIHRoYXQgdGhlIGxhenl0aW1lIG1vdW50IG9wdGlvbiBp
cyBnZW5lcmljIGZvciBhbGwgZmlsZXN5c3RlbXMuCkkgYmVsaWV2ZSBleHQ0IGhhcyBhbiBleHRy
YSBvcHRpbWl6YXRpb24gZm9yIGl0LCBidXQgdGhhdCdzIGl0LgoKQ2hlZXJzLCBBbmRyZWFzCgoK
CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
