Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4M0b5bm038930 for <xfs@oss.sgi.com>; Fri, 21 May 2010 19:37:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ACE0365834
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 17:39:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	rRa9URhSUHQGCIIO for <xfs@oss.sgi.com>;
	Fri, 21 May 2010 17:39:25 -0700 (PDT)
Date: Sat, 22 May 2010 10:39:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/12] xfs: delayed logging V6
Message-ID: <20100522003922.GC8120@dastard>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274476881.2255.47.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274476881.2255.47.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

T24gRnJpLCBNYXkgMjEsIDIwMTAgYXQgMDQ6MjE6MjFQTSAtMDUwMCwgQWxleCBFbGRlciB3cm90
ZToKPiBPbiBUdWUsIDIwMTAtMDUtMTggYXQgMDk6MjQgKzEwMDAsIERhdmUgQ2hpbm5lciB3cm90
ZToKPiA+IEhpIEZvbGtzLAo+ID4gCj4gPiBUaGlzIGlzIHZlcnNpb24gNiBvZiB0aGUgZGVsYXll
ZCBsb2dnaW5nIHNlcmllcyBhbmQgaXMgdGhlIGZpcnN0Cj4gPiByZWxlYXNlIGNhbmRpZGF0ZSBm
b3IgaW5jbHXRlWlvbiBpbiB0aGUgeGZzLWRldiB0cmVlIGFuZCAyLjYuMzUtcmMxLgo+ID4gCj4g
PiBJIHdvbid0IHJlcGVhdCBldmVyeXRoaW5nIGFib3V0IHdoYXQgaXQgaXMsIGp1c3QgcG9pbnQg
eW91Cj4gPiBoZXJlOgo+ID4gCj4gPiBodHRwOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXhmcyZtPTEy
Njg2Mjc3NzExODk0NiZ3PTIKPiA+IAo+ID4gZm9yIHRoZSBkZXNjcmlwdGlvbiwgYW5kIGhlcmU6
Cj4gPiAKPiA+IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9k
Z2MveGZzLmdpdCBkZWxheWVkLWxvZ2dpbmcKPiAKPiBJJ3ZlIHJldmlld2VkIHRoZSB3aG9sZSBz
ZXJpZXMuICBJIHNlZSB0aGF0IHlvdQo+IHJlYmFzZWQgYW5kIHVwZGF0ZWQgdGhlIGNvZGUgb24g
eW91ciBkZWxheWVkLWxvZ2dpbmcKPiBicmFuY2ggc28gSSdsbCByZS1wdWxsIHRoZSB1cGRhdGVk
IHZlcnNpb24gYW5kIGFmdGVyCj4gSSBydW4gaXQgdGhyb3VnaCBzb21lIHRlc3Rpbmcgb2YgbXkg
b3duIEkgd2lsbAo+IHB1c2ggdGhlIHJlc3VsdCB0byBvc3Muc2dpLmNvbS4KClllYWgsIGl0IGFk
ZHJlc3NlcyB0aGUgYnVzeSBleHRlbnQgdHJhY2tpbmcgYnVnIHlvdSBmb3VuZC4gIEknbQpzdGls
bCB0ZXN0aW5nIGl0IG15c2VsZiwgYnV0IEkgaGF2ZW4ndCBmb3VuZCBhbnkgaXNzdWVzIHlldC4K
Q2hhbmdlbG9nIGlzOgoKQ2hhbmdlcyBmb3IgVjc6Cm8gZml4ZWQgdHlwb3MgaW4gY29tbWVudHMg
aW4gYnVzeSBleHRlbnQgdHJhY2tpbmcgY2hhbmdlcy4KbyBmaXhlZCBwb3RlbnRpYWwgbnVsbCBw
b2ludGVyIGRlZmVyZW5jZSB3aGVuIGluc2VydGluZyBidXN5IGV4dGVudHMKbyBjbGVhbmVkIHVw
IGJ1c3kgZXh0ZW50IGluc2VydCBsb29wCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVy
CmRhdmlkQGZyb21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
