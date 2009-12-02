Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB21Zgps188818
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 19:35:42 -0600
Received: from mail-pz0-f171.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD56ADA4CE0
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 17:36:12 -0800 (PST)
Received: from mail-pz0-f171.google.com (mail-pz0-f171.google.com
	[209.85.222.171]) by cuda.sgi.com with ESMTP id
	iIEurQDWsr3gJgN4 for <linux-xfs@oss.sgi.com>;
	Tue, 01 Dec 2009 17:36:12 -0800 (PST)
Received: by pzk1 with SMTP id 1so4235560pzk.33
	for <linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 17:36:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B15BE1C.2030209@sandeen.net>
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>
	<4B14936F.7040401@sandeen.net>
	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>
	<4B14B077.5090500@sandeen.net>
	<389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>
	<4B152BAD.1000004@sandeen.net>
	<389deec70912010732o72edd3c4q196088a1c01b801e@mail.gmail.com>
	<4B1539C6.90000@sandeen.net>
	<389deec70912011646y682a2cc2rd5d4ea8cfe78d2f5@mail.gmail.com>
	<4B15BE1C.2030209@sandeen.net>
Date: Wed, 2 Dec 2009 09:36:11 +0800
Message-ID: <389deec70912011736g28ff8c7bu829d05788c157430@mail.gmail.com>
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
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

MjAwOS8xMi8yIEVyaWMgU2FuZGVlbiA8c2FuZGVlbkBzYW5kZWVuLm5ldD46Cj4gaGFuayBwZW5n
IHdyb3RlOgo+PiAyMDA5LzEyLzEgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PjoK
Pgo+IC4uLgo+Cj4+Pj4ga2VybmVsIHZlcnNpb24gaXMgMi42LjIzLCB4ZnNwcm9ncyBpcyAyLjku
NywgQ1BVIGlzIE1QQzg1NDgsIHBvd2VycGMgYXJjaC4KPj4+PiBJIGFtIGF0IGhvbWUgbm93LCBN
YXliZSBJIGNhbiBwcm92aWRlIHNvbWUgZGV0YWlsZWQgaW5mb3JtYXRpb24gdG9tb3Jyb3cuCj4+
PiBJZiB0aGVyZSdzIGFueSBwb3NzaWJpbGl0eSB0byB0ZXN0IG5ld2VyIGtlcm5lbCAmIHVzZXJz
cGFjZSwgdGhhdCdkCj4+PiBiZSBncmVhdC4gwqBNYW55IGJ1Z3MgaGF2ZSBiZWVuIGZpeGVkIHNp
bmNlIHRob3NlIHZlcnNpb25zLgo+Pj4KPj4gV2UgZGlkIGhhdmUgcGxhbiB0byB1cGdyYWRlIGtl
cm5lbCB0byBsYXRlc3QgMi42LjMxLgo+Cj4gV2VsbCwgSSdtIGp1c3Qgc3VnZ2VzdGluZyB0ZXN0
aW5nIGl0IGZvciBub3csIG5vdCBuZWNlc3NhcmlseQo+IHVwZ3JhZGluZyB5b3VyIHByb2R1Y3Qu
IMKgV291bGQganVzdCBiZSBnb29kIHRvIGtub3cgaWYgdGhlIGJ1ZyB5b3UKPiBhcmUgc2VlaW5n
IHBlcnNpc3RzIHVwc3RyZWFtIG9uIHBwYy4KPgpTYWQsIG91ciB0ZXN0IGVuZ2luZWVyIGhhZCBk
ZWxldGVkIHRoYXQgZGFtYWdlZCBmaWxlc3lzdGVtLCBJIGhhdmUgdG8KcmVwcm9kdWNlIHRlc3Qg
YWdhaW4gYW5kIHdhaXQgZm9yIGl0IHRvIGhhcHBlbi4KSSB3aWxsIHJlcGxhY2UgbmV3ZXIga2Vy
bmVsIHRvIHRlc3QgaW1tZWRpYXRlbHkgd2hlbiB0aGlzIHByb2JsZW0Kb2NjdXJlIGFnYWluIGFu
ZCBsZXQgeW91IGtub3cgQVNBUC4KCj4+IEJUVywgSXMgdGhlcmUgc29tZSBwbGFjZSB3aGVyZSBJ
IGNhbiBjaGVjayB0aG9zZSBmaXhlZCBidWcgbGlzdCBhY3Jvc3MgdmVyc2lvbnM/Cj4KPiBZb3Ug
Y2FuIGxvb2sgYXQgdGhlIGNoYW5nZWxvZ3Mgb24ga2VybmVsLm9yZywgZm9yIGluc3RhbmNlOgo+
Cj4gaHR0cDovL3d3dy5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJuZWwvdjIuNi9DaGFuZ2VMb2ct
Mi42LjMyCj4KPiBPciB3aXRoIGdpdCwgZ2l0IGxvZyAtLXByZXR0eS1vbmVsaW5lIGZzL3hmcwo+
Cj4gVGhlcmUgaXNuJ3QgYSBncmVhdCBidWcgPC0+IGNvbW1pdCA8LT4ga2VybmVsdmVyc2lvbiBt
YXBwaW5nLCBJIGd1ZXNzLgo+Cj4gLUVyaWMKPgo+Pj4gLUVyaWMKPgo+CgoKCi0tIApUaGUgc2lt
cGxlc3QgaXMgbm90IGFsbCBiZXN0IGJ1dCB0aGUgYmVzdCBpcyBzdXJlbHkgdGhlIHNpbXBsZXN0
IQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
