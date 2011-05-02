Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p425Zvgu214198 for <xfs@oss.sgi.com>; Mon, 2 May 2011 00:35:57 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61E5D16474AF
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 22:39:32 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id kTcyK8CsN7bzrL4m
	for <xfs@oss.sgi.com>; Sun, 01 May 2011 22:39:32 -0700 (PDT)
Received: by vws13 with SMTP id 13so4432755vws.26
	for <xfs@oss.sgi.com>; Sun, 01 May 2011 22:39:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinfqmqPTuLFDW_jv_Dn4jNsP5gLcQ@mail.gmail.com>
References: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
	<20110422065120.GB14189@infradead.org>
	<BANLkTi=3V0TohK6c6MYOvPQc3ADd_Pya3A@mail.gmail.com>
	<BANLkTinfqmqPTuLFDW_jv_Dn4jNsP5gLcQ@mail.gmail.com>
Date: Mon, 2 May 2011 11:09:32 +0530
Message-ID: <BANLkTinx_DF=cgY9um=h_0z+gC3fDakoUw@mail.gmail.com>
Subject: Re: [patch] xfsprogs: fixes a regression hang in xfs_repair phase 4
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

SXQgd2lsbCBiZSBmaW5lIGZvciBtZSwgaWYgeW91IGhhdmUgcmVjZWl2ZWQgdGhlIHhmc19tZXRh
ZHVtcCBmaWxlIEkKc2VudCBpbiBsYXN0IG1haWwuCkkgYW0gc3VyZSBpdCB3aWxsIGhlbHAgeW91
IGZpbmQgcHJvYmxlbSBpbiByZXBhaXIgYnRyZWUsIHBsZWFzZQpjb3JyZWN0IG1lIGlmIEkgbGVm
dCB5b3UgYW55dGhpbmcgZnJvbSBteSBzaWRlLgoKT24gVHVlLCBBcHIgMjYsIDIwMTEgYXQgNTo1
OSBQTSwgQWplZXQgWWFkYXYgPGFqZWV0LnlhZGF2Ljc3QGdtYWlsLmNvbT4gd3JvdGU6Cj4gU29y
cnkgZm9yIGRlbGF5LCBwbGVhc2UgZmluZCBhdHRhY2hlZCB0aGUgeGZzX21ldGFkdW1wIG9mIHhm
cyBmaWxlIHN5c3RlbQo+Cj4gT24gVHVlLCBBcHIgMjYsIDIwMTEgYXQgMTI6NDcgUE0sIEFqZWV0
IFlhZGF2IDxhamVldC55YWRhdi43N0BnbWFpbC5jb20+IHdyb3RlOgo+PiBTb3JyeSBmb3IgZGVs
YXksIHBsZWFzZSBmaW5kIHRoZSBtZXRhZHVtcCBvZiBmaWxlIHN5c3RlbS4KPj4KPj4gT24gRnJp
LCBBcHIgMjIsIDIwMTEgYXQgMTI6MjEgUE0sIENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFk
ZWFkLm9yZz4gd3JvdGU6Cj4+PiBUaGUgcGF0Y2ggbG9va3MgZ29vZCB0byBtZS4gwqBCdXQgSSdt
IGEgYml0IHdvcnJpZWQgYWJvdXQgdGhlIGxhY2sgb2YKPj4+IHRlc3QgY292ZXJhZ2UuIMKgQXMg
RXJpYyBzYWlkIGlmIHlvdSdyZSBhYmxlIHRvIGdldCBhIG1ldGFkdW1wIG9mCj4+PiBhIGZpbGVz
eXN0ZW0gdGhhdCBzaG93cyB0aGlzIGlzc3VlIGl0IHdvdWxkIGNvbWUgaW4gdXNlZnVsIGZvcgo+
Pj4gcmVncmVzc2lvbiB0ZXN0aW5nLgo+Pj4KPj4+Cj4+Cj4KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
