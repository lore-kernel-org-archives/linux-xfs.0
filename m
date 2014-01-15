Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E20747F4E
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 09:54:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F762AC004
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 07:54:04 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BY3bM7sY3tloH5ZN for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 07:54:02 -0800 (PST)
Message-ID: <52D6AF1A.8010604@sandeen.net>
Date: Wed, 15 Jan 2014 09:54:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
References: <20140113031947.GG3469@dastard>	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>	<20140113192732.GI3469@dastard>	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>	<20140114022414.GM3469@dastard>	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>	<20140115015350.GR3469@dastard>	<61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>	<20140115034803.GT3469@dastard>	<1E5E569C-2E11-42A1-A771-89D4800BC412@kotlarek.com>
	<20140115063722.GW3469@dastard>
In-Reply-To: <20140115063722.GW3469@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Zachary Kotlarek <zach@kotlarek.com>
Cc: xfs@oss.sgi.com

T24gMS8xNS8xNCwgMTI6MzcgQU0sIERhdmUgQ2hpbm5lciB3cm90ZToKPiBPbiBUdWUsIEphbiAx
NCwgMjAxNCBhdCAwOTozMDo1N1BNIC0wODAwLCBaYWNoYXJ5IEtvdGxhcmVrIHdyb3RlOgo+Pgo+
PiBPbiBKYW4gMTQsIDIwMTQsIGF0IDc6NDggUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9y
Yml0LmNvbT4gd3JvdGU6Cj4+Cj4+PiBJdCdzIGNhbGxlZCAqQVNDSUkqIENhc2UgSW5zZW5zaXRp
dml0eSBmb3IgYSByZWFzb246IGl0IGRvZXNuJ3QKPj4+IHN1cHBvcnQgYW55dGhpbmcgb3RoZXIg
dGhhbiBBU0NJSS4gU28geW91ciB1c2FnZSBpcyBub3QgYWN0dWFsbHkKPj4+IHN1cHBvcnRlZCBh
dCBhbGwsIGhlbmNlIGl0J3Mgbm8gc3VycHJpc2UgdGhhdCBpdCBoYXMgY2F1c2VkCj4+PiBicmVh
a2FnZS4KPj4KPj4gT2theS4gVGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb24uCj4+Cj4+IEZXSVcs
IEkgcmVhZCDigJxBU0NJSS1vbmx5IGNhc2UtaW5zZW5zaXRpdmXigJ0gdG8gbWVhbiDigJxvbmx5
IGNhc2UtaW5zZW5zaXRpdmUgZm9yIEFTQ0lJ4oCdIGFzIGluIMOxIGFuZCDDkSB3b3VsZCBub3Qg
bWF0Y2ggZWFjaCBvdGhlci4gSWYgaXQgYWN0dWFsbHkgbWVhbnMg4oCcYW55dGhpbmcgb3RoZXIg
dGhhbiBBU0NJSSBpcyBzdWJqZWN0IHRvIGNvbXBsZXRlIGJyZWFrYWdl4oCdIGEgbW9yZSBudWFu
Y2VkIGV4cGxhbmF0aW9uIGluIHRoZSBtYW4gcGFnZSBtaWdodCBiZSBkZXNpcmFibGUuCj4gCj4g
U3VyZS4gQ2FuIHlvdSB3cml0ZSBhIHBhdGNoIHRvIGFkZCBleHBsYW5hdGlvbiB0aGF0IGV4cGxh
aW4gdGhlCj4gcHJvYmxlbSB5b3UndmUgaGFkPwo+IAo+PiBJIGRvbuKAmXQgc3VwcG9zZSB0aGVy
ZeKAmXMgYW55IHdheSB0byBkaXNhYmxlIHRoYXQgc2V0dGluZyBzaG9ydCBvZiBjcmVhdGluZyBh
IG5ldyBmaWxlIHN5c3RlbT8KPiAKPiBOb3Qgb2ZmaWNpYWxseS4gQ2hhbmdpbmcgaXQgbWVhbnMg
eW91IGhhdmUgdG8gY2hhbmdlIGV2ZXJ5IHNpbmdsZQo+IGhhc2ggZm9yIGV2ZXJ5IGRpcmVjdG9y
eSBlbnRyeS4gSSAqdGhpbmsqIHRoYXQgeW91IGNvdWxkIHByb2JhYmx5IGRvCj4gaXQgd2l0aCBh
IGJpdCBvZiB4ZnNfZGIgbWFnaWMgYW5kIGFuZCB4ZnNfcmVwYWlyIHBhc3MuCj4gCj4gRmlyc3Qs
IEEgd2FybmluZywgc29tZSBhZHZpY2UgYW5kIGEgZGlzY2xhaW1lcjogYmFjayB1cCBhbnl0aGlu
ZyB5b3UKPiBkb24ndCB3YW50IHRvIGxvc2UsIGJlY2F1c2UgaWYgdGhpcyBzY3Jld3MgdXAgaXQn
bGwgdHJhc2ggdGhlCj4gZGlyZWN0b3J5IHN0cnVjdHVyZSBhbmQgeW91IG1heSAqTE9TRSogKkFM
TCogKllPVVIqICpEQVRBKi4gVGhpcyBpcwo+IGRhbmdlcm91cywgbm90IHJlY29tbWVuZGVkIGFu
ZCBJIHRha2Ugbm8gcmVzcG9uc2liaWxpdHkgZm9yIHdoYXQKPiBoYXBwZW5zIGlmIHlvdSB0cnkg
aXQgYW5kIGl0IGZhaWxzLgo+IAo+IEFmdGVyIHRha2luZyBhIGJhY2t1cCwgdXNlIHhmc19tZXRh
ZHVtcCB0byBzZXQgdXAgZm9yIGEKPiBub24tZGVzdHJ1Y3RpdmUgdHJpYWwgcnVuLiAgdGFrZSBh
IGNvcHkgb2YgdGhlIGZpbGVzeXN0ZW0gbWV0YWRhdGEKPiB1c2luZyB4ZnNfbWV0YWR1bXA6Cj4g
Cj4gIyB4ZnNfbWV0YWR1bXAgPGRldj4gc2NyYXRjaC5tZXRhZHVtcAoKTkI6IFlvdSdsbCB3YW50
IHRvIGFkZCB0aGUgIi1vIiBvcHRpb24gdG8gbm90IG9iZnVzY2F0ZSBmaWxlbmFtZXMsIG9yCnlv
dSdsbCBwcm9iYWJseSBoYXZlIG5vIGlkZWEgaWYgRGF2ZSdzIGxhdGVyIHN0ZXBzIGFyZSB3b3Jr
aW5nIG9yIG5vdC4KCgooSSBoYXZlbid0IHJlYWQgdGhlIHdob2xlIHRocmVhZCwgYnV0IGlzIHRo
ZXJlIG5vIHdheSBmb3IgYXNjaWktY2kgbW9kZQp0byByZWplY3Qgbm9uLWFzY2lpIG5hbWVzIGlu
IHRoZSBmaXJzdCBwbGFjZT8gIFRoaXMgc2VlbXMgbGlrZSBxdWl0ZQp0aGUgcGl0ZmFsbC4pCgot
RXJpYwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
