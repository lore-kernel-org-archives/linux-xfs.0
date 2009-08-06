Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n768kkUX041104
	for <linux-xfs@oss.sgi.com>; Thu, 6 Aug 2009 03:46:47 -0500
Received: from mail-fx0-f207.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38B91B05A1D
	for <linux-xfs@oss.sgi.com>; Thu,  6 Aug 2009 01:57:08 -0700 (PDT)
Received: from mail-fx0-f207.google.com (mail-fx0-f207.google.com
	[209.85.220.207]) by cuda.sgi.com with ESMTP id
	gRdPg2mTWSsLLpnD for <linux-xfs@oss.sgi.com>;
	Thu, 06 Aug 2009 01:57:08 -0700 (PDT)
Received: by fxm3 with SMTP id 3so471156fxm.8
	for <linux-xfs@oss.sgi.com>; Thu, 06 Aug 2009 01:47:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7732BF.6020207@sandeen.net>
References: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
	<4A6D075B.9060601@sandeen.net>
	<389deec70907262347g1ca3637fn469596ec1e05148@mail.gmail.com>
	<4A6DAE5D.6060704@sandeen.net>
	<389deec70908030732n29d35220mc9acdb912ab10899@mail.gmail.com>
	<4A7732BF.6020207@sandeen.net>
Date: Thu, 6 Aug 2009 16:47:34 +0800
Message-ID: <389deec70908060147j6048ed83wacf82b04195e9bae@mail.gmail.com>
Subject: Re: How to solve "No space left" problem on my 32bit machine?
From: hank peng <pengxihan@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

MjAwOS84LzQgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PjoKPiBoYW5rIHBlbmcg
d3JvdGU6Cj4+IDIwMDkvNy8yNyBFcmljIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+Ogo+
Pj4gaGFuayBwZW5nIHdyb3RlOgo+Pj4+IDIwMDkvNy8yNyBFcmljIFNhbmRlZW4gPHNhbmRlZW5A
c2FuZGVlbi5uZXQ+Ogo+Pj4+PiBoYW5rIHBlbmcgd3JvdGU6Cj4+Pj4+PiBIaSwgZm9sa3M6Cj4+
Pj4+PiBJIGhhdmUgYSAyLjVUIGZpbGUgc3lzdGVtIGZvcm1hdHRlZCB3aXRoIFhGUywgZGYgdGVs
bHMgbWUgaXQgc3RpbGwKPj4+Pj4+IGhhdmUgYWJvdXQgMTBHIHNwYWNlIGF2YWlsYWJsZSwgYnV0
IEkgY2FuJ3QgY3JlYXRlIG5ldyBmaWxlcyBvcgo+Pj4+Pj4gZGlyZWN0b3J5IGFueSBtb3JlLiBS
ZXR1cm4gbWVzc2FnZSBpcyAiTm8gc3BhY2UgbGVmdCBvbiB0aGlzIGRldmljZSIuCj4+Pj4+PiBJ
IHNlYXJjaGVkIHNvbHV0aW9uIGZvciB0aGlzIHByb2JsZW0gdGhyb3VnaCBnb29nbGUsIGFuZCBm
b3VuZCB0aGlzOgo+Pj4+Pj4gaHR0cDovL29zcy5zZ2kuY29tL2FyY2hpdmVzL3hmcy8yMDA1LTA2
L21zZzAwMzQ3Lmh0bWwuIEkgdGhpbmsgaXQgaXMgYQo+Pj4+Pj4ga25vd24gIk5vIHNwYWNlIGxl
ZnQiIHByb2JsZW0uIEkgd29uZGVyIHdoZXRoZXIgaXQgY2FuIG9ubHkKPj4+Pj4+IGJlIHNvbHZl
ZCBvbiA2NC1iaXQgbWFjaGluZT8gSWYgb24gbXkgMzItYml0IG1hY2hpbmUsIHdoYXQgc2hvdWxk
IEkgZG8/Cj4+Pj4+IE9uIHZlcnkgcmVjZW50IGtlcm5lbHMgeW91IGNhbiB1c2UgNjQtYml0IGlu
b2RlcyBvbiAzMi1iaXQgbWFjaGluZXM7IHlvdQo+Pj4+PiBjYW4gdHJ5IG1vdW50aW5nIHdpdGgg
LW8gaW5vZGU2NCB0IGFsbG93IHRoaXMuCj4+Pj4+Cj4+Pj4gSSB0cmllZCAtbyBpbm9kZTY0IG9w
dGlvbiwgYnV0IGtlcm5lbCBnaXZlcyBtZSBlcnJvciBtZXNzYWdlOgo+Pj4+IFhGUzogaW5vZGU2
NCBvcHRpb24gbm90IGFsbG93ZWQgb24gdGhpcyBzeXN0ZW0KPj4+PiBJIGRvdWJ0IHRoaXMgb3B0
aW9uIGNhbid0IGJlIHVzZWQgb24gMzItYml0IG1hY2hpbmUuCj4+PiBUaGF0J3Mgd2h5IEkgc2Fp
ZCB5b3UgbmVlZCBhIHZlcnkgcmVjZW50IGtlcm5lbCwgaXQgd2FzIGFkZGVkIHJlbGF0aXZlbHkK
Pj4+IHJlY2VudGx5Ogo+Pj4KPj4+IGNvbW1pdCA2YzMxYjkzYTE0YTQ1M2M4NzU2ZmZkMjI4ZTI0
OTEwZmZkZjMwYzVkCj4+PiBBdXRob3I6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFkZWFk
Lm9yZz4KPj4+IERhdGU6IMKgIEZyaSBOb3YgMjggMTQ6MjM6MzIgMjAwOCArMTEwMAo+Pj4KPj4+
IMKgIMKgW1hGU10gYWxsb3cgaW5vZGU2NCBtb3VudCBvcHRpb24gb24gMzIgYml0IHN5c3RlbXMK
Pj4+Cj4+PiBJIGJlbGlldmUgdGhpcyB3ZW50IGludG8gMi42LjI5Lgo+Pj4KPj4gSSB0cmllZCAy
LjYuMzAgYW5kIHRlc3QgaXQKPj4gMS4gY3JlYXRlIGFuIGV4YWN0IDJUIExWTQo+PiAyLiBjcmVh
dGUgWEZTIG9uIGl0Cj4+IDMuIG1vbnQgaXQgd2l0aCBpbm9kZTY0IG9wdGlvbgo+PiA0LiB3cml0
ZSBmaWxlcyBvbiBpdCB0byBmdWxsIGV4dGVudAo+PiA1LiB1c2UgeGZzX2dyb3cgdG8gZXhwYW5k
IGl0IHRvIDIuNVQKPj4gNi4gdG91Y2ggYSBmaWxlIGFuZCBubyBlcnJvciBtZXNzYWdlIHJldHVy
bmVkCj4+IDcuICdscyAtbCcgY2FuIG5vdCBzaG93IHRoZSBmaWxlIEkgY3JlYXRlZCBhYm92ZS4K
Pj4KPj4gU28gSSB0aGluayBJIHNob3VsZCBkbyBzb21ldGhpbmcgb24gdXNlcnNwYWNlIHRvb2xz
LCBidXQgaG93Pwo+Cj4gRG9lc24ndCBzb3VuZCBsaWtlIGEgdXNlcnNwYWNlIHByb2JsZW0uIMKg
U28gdG91Y2ggc3VjY2VlZHMgKG1heWJlIGVjaG8KPiAkPyBhZnRlciB0byBiZSBzdXJlKSBidXQg
bHMgc2hvd3Mgbm8gZmlsZT8gwqBBbnl0aGluZyBpbiBkbWVzZyBhZnRlciB0aGF0Pwo+Cj4gSSdk
IGhhdmUgdG8gZmluZCBhIDMyLWJpdCBib3ggdy8gPiAyVCB0byB0ZXN0IHRoaXMgSSBndWVzcy4g
wqA6KQo+Ckl0IGlzIGJlY2F1c2UgSSB1c2UgImxzIiBjb21tYW5kIGluIG9sZCB2ZXJzaW9uIG9m
IGJ1c3lib3gsIGFmdGVyIEkKdXBkYXRlIGJ1c3lib3ggdG8gdGhlIGxhdGVzdCwgaXQgaXMgT0sg
bm93LgoKSSBkb24ndCBjaGVjayB0aGUgc291cmNlIGNvZGUgb2Ygb2xkIHZlcnNpb24sIGJ1dCBp
IGFtIHN1cmUgaXQgaXMgdGhlIHJlYXNvbi4KCgoKPiAtRXJpYwo+CgoKCi0tIApUaGUgc2ltcGxl
c3QgaXMgbm90IGFsbCBiZXN0IGJ1dCB0aGUgYmVzdCBpcyBzdXJlbHkgdGhlIHNpbXBsZXN0IQoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxp
bmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGlu
Zm8veGZzCg==
