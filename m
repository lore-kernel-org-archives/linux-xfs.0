Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2918C7F6F
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 05:33:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19861304043
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 03:33:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6zN4OGUZBOFu4TZ9 for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 03:33:20 -0700 (PDT)
Date: Thu, 3 Sep 2015 20:33:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/11] xfsprogs: add dummy mntent for OS X
Message-ID: <20150903103317.GV3902@dastard>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-10-git-send-email-jtulak@redhat.com>
	<20150831190120.GK349@infradead.org>
	<CACj3i73Px4Zxfyz1GMZN=4r_LeONPMwfLT=P7C7bNDDshJ1ipA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i73Px4Zxfyz1GMZN=4r_LeONPMwfLT=P7C7bNDDshJ1ipA@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

T24gVGh1LCBTZXAgMDMsIDIwMTUgYXQgMTE6MDE6NDRBTSArMDIwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IE9uIE1vbiwgQXVnIDMxLCAyMDE1IGF0IDk6MDEgUE0sIENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAaW5mcmFkZWFkLm9yZz4KPiB3cm90ZToKPiAKPiA+IE9uIFdlZCwgQXVnIDI2LCAyMDE1IGF0
IDAyOjAyOjM0UE0gKzAyMDAsIEphbiBUdWxhayB3cm90ZToKPiA+ID4gQmVjYXVzZSB0aGVzZSBj
YWxscyBhcmUgdXNlZCBvbmx5IGJ5IHhmc19mc3IsIHdoaWNoIGNhbid0Cj4gPiA+IHdvcmsgb24g
T1MgWCB1bmxlc3MgYSB3YXkgaG93IHRvIG1vdW50IFhGUyBpcyBmb3VuZCwKPiA+ID4gdGhlcmUg
aXMgbm90IHVzZSBpbiBpbXBsZW1lbnRpbmcgdGhlc2UgY2FsbHMuCj4gPgo+ID4gVGFrZSBhIGxv
b2sgYXQgdGhlIHF1b3RhIGNvZGUgZm9yIHRoZSBCU0QgYWx0ZXJuYXRpdmUgdG8gbW50ZW50Lgo+
ID4gVGhhdCBjb2RlIHNob3VsZCBiZSBtb3ZlZCBpbnRvIGEgY29tbW9uIGxvY2F0aW9uIGFuZCB1
c2VkIGJ5IGZzci4KPiA+Cj4gCj4g4oCLSSB0cmllZCB0byBmaW5kIGl0LCBidXQgZGlkbid0IGZv
dW5kLi4uIENvdWxkIHlvdSBwb2ludCBtZSB3aGVyZSBpdCBpcz8KPiBRdW90YS9mcmVlYnNkLmgg
aGFzIGp1c3QgZmV3IGxpbmVzIHdpdGggb25lIGRlZmluaXRpb24gd2l0aCBlcnJubyA9Cj4gLUVO
T1NZUywgYW5kIGluIG90aGVyIGZpbGVzIGluIHF1b3RhLywgSSBkaWRuJ3Qgc2F3IGFueXRoaW5n
IEJTRCBzcGVjaWZpYy4KCkkgdGhpbmsgQ2hyaXN0b3BoIGlzIHJlZmVyaW5nIHRvIHRoZSBjb2Rl
IGluIGxpYnhjbWQvcGF0aHMuYzoKCiNpZiBkZWZpbmVkKEhBVkVfR0VUTU5URU5UKQouLi4uCiNl
bGlmIGRlZmluZWQoSEFWRV9HRVRNTlRJTkZPKQouLi4uCiNlbHNlCiMgZXJyb3IgIkhvdyBkbyBJ
IGV4dHJhY3QgaW5mbyBhYm91dCBtb3VudGVkIGZpbGVzeXN0ZW1zIG9uIHRoaXMgcGxhdGZvcm0/
IgojZW5kaWYKIwoKSEFWRV9HRVRNTlRJTkZPIGlzIGZvciBCU0Qgc3lzdGVtcywgSUlSQy4KCkNo
ZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
