Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 968A329DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 15:08:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89251304039
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 13:08:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pDah0CO86z7vMyQr for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 13:08:07 -0800 (PST)
Date: Thu, 16 Jan 2014 08:08:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Message-ID: <20140115210803.GX3469@dastard>
References: <20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
	<20140115015350.GR3469@dastard>
	<61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>
	<20140115034803.GT3469@dastard>
	<1E5E569C-2E11-42A1-A771-89D4800BC412@kotlarek.com>
	<20140115063722.GW3469@dastard> <52D6AF1A.8010604@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52D6AF1A.8010604@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Zachary Kotlarek <zach@kotlarek.com>, xfs@oss.sgi.com

T24gV2VkLCBKYW4gMTUsIDIwMTQgYXQgMDk6NTQ6MDJBTSAtMDYwMCwgRXJpYyBTYW5kZWVuIHdy
b3RlOgo+IE9uIDEvMTUvMTQsIDEyOjM3IEFNLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4gPiBPbiBU
dWUsIEphbiAxNCwgMjAxNCBhdCAwOTozMDo1N1BNIC0wODAwLCBaYWNoYXJ5IEtvdGxhcmVrIHdy
b3RlOgo+ID4+Cj4gPj4gT24gSmFuIDE0LCAyMDE0LCBhdCA3OjQ4IFBNLCBEYXZlIENoaW5uZXIg
PGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOgo+ID4+Cj4gPj4+IEl0J3MgY2FsbGVkICpBU0NJ
SSogQ2FzZSBJbnNlbnNpdGl2aXR5IGZvciBhIHJlYXNvbjogaXQgZG9lc24ndAo+ID4+PiBzdXBw
b3J0IGFueXRoaW5nIG90aGVyIHRoYW4gQVNDSUkuIFNvIHlvdXIgdXNhZ2UgaXMgbm90IGFjdHVh
bGx5Cj4gPj4+IHN1cHBvcnRlZCBhdCBhbGwsIGhlbmNlIGl0J3Mgbm8gc3VycHJpc2UgdGhhdCBp
dCBoYXMgY2F1c2VkCj4gPj4+IGJyZWFrYWdlLgo+ID4+Cj4gPj4gT2theS4gVGhhbmtzIGZvciB0
aGUgZXhwbGFuYXRpb24uCj4gPj4KPiA+PiBGV0lXLCBJIHJlYWQg4oCcQVNDSUktb25seSBjYXNl
LWluc2Vuc2l0aXZl4oCdIHRvIG1lYW4g4oCcb25seSBjYXNlLWluc2Vuc2l0aXZlIGZvciBBU0NJ
SeKAnSBhcyBpbiDDsSBhbmQgw5Egd291bGQgbm90IG1hdGNoIGVhY2ggb3RoZXIuIElmIGl0IGFj
dHVhbGx5IG1lYW5zIOKAnGFueXRoaW5nIG90aGVyIHRoYW4gQVNDSUkgaXMgc3ViamVjdCB0byBj
b21wbGV0ZSBicmVha2FnZeKAnSBhIG1vcmUgbnVhbmNlZCBleHBsYW5hdGlvbiBpbiB0aGUgbWFu
IHBhZ2UgbWlnaHQgYmUgZGVzaXJhYmxlLgo+ID4gCj4gPiBTdXJlLiBDYW4geW91IHdyaXRlIGEg
cGF0Y2ggdG8gYWRkIGV4cGxhbmF0aW9uIHRoYXQgZXhwbGFpbiB0aGUKPiA+IHByb2JsZW0geW91
J3ZlIGhhZD8KPiA+IAo+ID4+IEkgZG9u4oCZdCBzdXBwb3NlIHRoZXJl4oCZcyBhbnkgd2F5IHRv
IGRpc2FibGUgdGhhdCBzZXR0aW5nIHNob3J0IG9mIGNyZWF0aW5nIGEgbmV3IGZpbGUgc3lzdGVt
Pwo+ID4gCj4gPiBOb3Qgb2ZmaWNpYWxseS4gQ2hhbmdpbmcgaXQgbWVhbnMgeW91IGhhdmUgdG8g
Y2hhbmdlIGV2ZXJ5IHNpbmdsZQo+ID4gaGFzaCBmb3IgZXZlcnkgZGlyZWN0b3J5IGVudHJ5LiBJ
ICp0aGluayogdGhhdCB5b3UgY291bGQgcHJvYmFibHkgZG8KPiA+IGl0IHdpdGggYSBiaXQgb2Yg
eGZzX2RiIG1hZ2ljIGFuZCBhbmQgeGZzX3JlcGFpciBwYXNzLgo+ID4gCj4gPiBGaXJzdCwgQSB3
YXJuaW5nLCBzb21lIGFkdmljZSBhbmQgYSBkaXNjbGFpbWVyOiBiYWNrIHVwIGFueXRoaW5nIHlv
dQo+ID4gZG9uJ3Qgd2FudCB0byBsb3NlLCBiZWNhdXNlIGlmIHRoaXMgc2NyZXdzIHVwIGl0J2xs
IHRyYXNoIHRoZQo+ID4gZGlyZWN0b3J5IHN0cnVjdHVyZSBhbmQgeW91IG1heSAqTE9TRSogKkFM
TCogKllPVVIqICpEQVRBKi4gVGhpcyBpcwo+ID4gZGFuZ2Vyb3VzLCBub3QgcmVjb21tZW5kZWQg
YW5kIEkgdGFrZSBubyByZXNwb25zaWJpbGl0eSBmb3Igd2hhdAo+ID4gaGFwcGVucyBpZiB5b3Ug
dHJ5IGl0IGFuZCBpdCBmYWlscy4KPiA+IAo+ID4gQWZ0ZXIgdGFraW5nIGEgYmFja3VwLCB1c2Ug
eGZzX21ldGFkdW1wIHRvIHNldCB1cCBmb3IgYQo+ID4gbm9uLWRlc3RydWN0aXZlIHRyaWFsIHJ1
bi4gIHRha2UgYSBjb3B5IG9mIHRoZSBmaWxlc3lzdGVtIG1ldGFkYXRhCj4gPiB1c2luZyB4ZnNf
bWV0YWR1bXA6Cj4gPiAKPiA+ICMgeGZzX21ldGFkdW1wIDxkZXY+IHNjcmF0Y2gubWV0YWR1bXAK
PiAKPiBOQjogWW91J2xsIHdhbnQgdG8gYWRkIHRoZSAiLW8iIG9wdGlvbiB0byBub3Qgb2JmdXNj
YXRlIGZpbGVuYW1lcywgb3IKPiB5b3UnbGwgcHJvYmFibHkgaGF2ZSBubyBpZGVhIGlmIERhdmUn
cyBsYXRlciBzdGVwcyBhcmUgd29ya2luZyBvciBub3QuCj4gCj4gCj4gKEkgaGF2ZW4ndCByZWFk
IHRoZSB3aG9sZSB0aHJlYWQsIGJ1dCBpcyB0aGVyZSBubyB3YXkgZm9yIGFzY2lpLWNpIG1vZGUK
PiB0byByZWplY3Qgbm9uLWFzY2lpIG5hbWVzIGluIHRoZSBmaXJzdCBwbGFjZT8gIFRoaXMgc2Vl
bXMgbGlrZSBxdWl0ZQo+IHRoZSBwaXRmYWxsLikKClRoZSB1dGYtOCBwYXRjaGVzIGFkZCBhICJp
cyB0aGlzIHZhbGlkIHV0Zi04IiBjaGVjayB0byBhbGwgdGhlCm9wZXJhdGlvbnMgdGhhdCBjYXJl
LiBXZSBjb3VsZCBwcm9iYWJseSBkbyB0aGF0IGZvciB0aGUgQVNDSUktQ0kKc3R1ZmYgaWYgeW91
IGNhbiBkZWZpbmUgd2hhdCBBU0NJSSBtZWFucy4uLi4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZl
IENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
