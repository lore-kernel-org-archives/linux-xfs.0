Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F16FE7F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 18:36:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF8B98F8037
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 16:36:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pKcrAWCnzrd80cT6 for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 16:36:29 -0700 (PDT)
Date: Tue, 22 Sep 2015 09:36:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: add [-U uuid] option
Message-ID: <20150921233627.GE19114@dastard>
References: <1442855060-38259-1-git-send-email-mel@ohmu.fi>
	<20150921221839.GC19114@dastard>
	<2640913C-6C95-4128-9055-B155AECA0206@ohmu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2640913C-6C95-4128-9055-B155AECA0206@ohmu.fi>
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
To: Mika Eloranta <mika.eloranta@ohmu.fi>
Cc: xfs@oss.sgi.com

T24gVHVlLCBTZXAgMjIsIDIwMTUgYXQgMDE6NTY6NTNBTSArMDMwMCwgTWlrYSBFbG9yYW50YSB3
cm90ZToKPiBPbiAyMiBTZXAgMjAxNSwgYXQgMDE6MTgsIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJv
bW9yYml0LmNvbT4KPiB3cm90ZToKPiA+IAo+ID4gT24gTW9uLCBTZXAgMjEsIDIwMTUgYXQgMDg6
MDQ6MjBQTSArMDMwMCwgTWlrYSBFbG9yYW50YSB3cm90ZToKPiA+PiBUaGUgVVVJRCBjYW4gbm93
IGJlIG9wdGlvbmFsbHkgc3BlY2lmaWVkIGR1cmluZyBmaWxlc3lzdGVtCj4gPj4gY3JlYXRpb24u
Cj4gPiAKPiA+IFdoaWNoIFVVSUQgYXJlIHlvdSB3YW50aW5nIHRvIHNldCAtIHRoZSBtZXRhZGF0
YSB1dWlkIG9yIHRoZQo+ID4gdXNlciB2aXNpYmxlIFVVSUQgbGFiZWw/IE9yIGJvdGg/IENhbiB5
b3UgZXhwbGFpbiB0aGUgdXNlIGNhc2UKPiA+IGZvciB0aGlzPyAgaS5lLiBJJ20gdHJ5aW5nIHRv
IHdvcmsgb3V0IHdoeSBXaHkgZG9lc24ndCBta2ZzLnhmcwo+ID4gKyB4ZnNfYWRtaW4gLVUgPHV1
aWQ+IGRvZXNuJ3Qgd29yayBmb3IgeW91Pwo+IAo+IEkgd2FudCB0byBzZXQgdGhlIHVzZXIgdmlz
aWJsZSBVVUlEIChzYW1lIGFzIHhmc19hZG1pbiAtVS8tdSkuCj4gV2hldGhlciB0aGlzIGltcGFj
dHMgdGhlICJtZXRhZGF0YSB1dWlk4oCdIG9yIG5vdCwgSSBkbyBub3QKPiBrbm93LCBJ4oCZbSBu
b3QgYW4gZXhwZXJ0IG9uIHRoZSBYRlMgaW50ZXJuYWxzLCBqdXN0IGEgdXNlci4KCldoaWNoIHRl
bGxzIG1lIHdoYXQgSSBuZWVkIHRvIGtub3cgLSBZb3UgYXJlIHRyeWluZyB0byB1c2UgdGhlIFVV
SUQKYXMgYSB1c2VyIGNvbnRyb2xsZWQgZmlsZXN5c3RlbSBsYWJlbC4gRnVubmlseSBlbm91Z2gs
IHdlIGhhdmUgYQp0aGluZyBmb3IgdGhpcyBhbHJlYWR5IC0gYSB1c2VyIGNvbnRyb2xsZWQgZmls
ZXN5c3RlbSBsYWJlbDoKCiMgbWtmcy54ZnMgLUwgImxhYmVsIiAuLi4uCgpJdCdzIDEyIGNoYXJh
Y3RlcnMgbG9uZywgc28gbW9yZSB0aGFuIGVub3VnaCBmb3IgYW55IHNvcnQgb2YgdW5pcXVlCmlk
ZW50aWZpY2F0aW9uIHNjaGVtZSB5b3Ugd2FudCB0byB1c2UgZm9yIHlvdXIgZmlsZXN5c3RlbXMu
Cnhmc19hZG1pbiBlbmFibGVzIHlvdSB0byBjaGFuZ2UgaXQgYWZ0ZXIgdGhlIGZhY3QsIGFsbCBt
YWpvcgpmaWxlc3lzdGVtcyBzdXBwb3J0IGl0IGFuZCBhbGwgdGhlIGluZnJhc3RydWN0dXJlIGtu
b3cgYWJvdXQgaXQKKGxzYmxrLCAvZXRjL2ZzdGFiLiAvZGV2L2Rpc2svYnktbGFiZWwsIGV0Yykg
c28gdXNpbmcgaXQgaXMgbm8KZGlmZmVyZW50IHRvIHVzaW5nIFVVSURzLiBFeGNlcHQgdGhhdCwg
dW5saWtlIFVVSURzLCB5b3UgY2FuIG1ha2UKZmlsZXlzdGVtIGxhYmVscyBodW1hbiByZWFkYWJs
ZS4gOikKClBlcmhhcHMgeW91IHNob3VsZCB0cnkgdXNpbmcgZmlsZXN5c3RlbSBsYWJlbHMgc2Vl
aW5nIGFzIGV2ZXJ5dGhpbmcKeW91IG5lZWQgaXMgYWxyZWFkeSB0aGVyZT8KCkNoZWVycywKCkRh
dmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3Nz
LnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
