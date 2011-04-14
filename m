Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3EEmCHw261850 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 09:48:12 -0500
Subject: Re: [PATCH, v2] xfs: cleanup duplicate initializations
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110413225327.GM31057@dastard>
References: <1301332373-24914-1-git-send-email-dsterba@suse.cz>
	<1301338370.2622.10.camel@doink> <1302732208.2023.146.camel@doink>
	<20110413225327.GM31057@dastard>
Date: Thu, 14 Apr 2011 09:50:39 -0500
Message-ID: <1302792639.2608.6.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: David Sterba <dsterba@suse.cz>, xfs@oss.sgi.com

T24gVGh1LCAyMDExLTA0LTE0IGF0IDA4OjUzICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
T24gV2VkLCBBcHIgMTMsIDIwMTEgYXQgMDU6MDM6MjhQTSAtMDUwMCwgQWxleCBFbGRlciB3cm90
ZToKLiAuIC4KPiA+IERhdmlkLCBwZXJoYXBzIHlvdSBjb3VsZCBzaWduIG9mZiBvbiB0aGlzIHZl
cnNpb24uCj4gPiBNZWFud2hpbGUsIGFub3RoZXIgcmV2aWV3ZXIgbWlnaHQgbWFrZSBzZW5zZS4K
PiAKPiBTZWVpbmcgYXMgeW91IG9ubHkgYWRkZWQgYSBodW5rLCBJJ2Qgc2F5IHRoYXQga2VlcGlu
ZyBoaXMgb2xkCj4gc9GWZ25vZmYgaXMganVzdCBmaW5lLgoKT0suCgo+ID4gCj4gPiAJCQkJCS1B
bGV4Cj4gPiAKPiA+IGZvbGxvdyB0aGVzZSBndWlkZWxpbmVzOgo+ID4gLSBsZWF2ZSBpbml0aWFs
aXphdGlvbiBpbiB0aGUgZGVjbGFyYXRpb24gYmxvY2sgaWYgaXQgZml0cyB0aGUgbGluZQo+ID4g
LSBtb3ZlIHRvIHRoZSBjb2RlIHdoZXJlIGl0J3MgbW9yZSBzdWl0YWJsZSAoJ2ZvcicgaW5pdCBi
bG9jaykKPiA+IAo+ID4gT3JpZ2luYWxseSBwcm9wb3NlZCBieSBEYXZpZCBTdGVyYmEgPGRzdGVy
YmFAc3VzZS5jej4KPiAKPiBUaGF0IGlzIHdoYXQgdGhlICJGcm9tOiIgdGFnIGlzIGZvciB3aGVu
IHlvdSBwb3N0IHNvbWVvbmUgZWxzZSdzCj4gcGF0Y2guIDspCgpHb29kIHRvIGtub3cuICBUaGFu
a3MgYSBsb3QgZm9yIHRoZSByZXZpZXcuCgo+IEFueXdheSwgbG9va3MgZ29vZCBub3cuCj4gCj4g
UmV2aWV3ZWQtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiAKPiBDaGVl
cnMsCj4gCj4gRGF2ZS4KCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
