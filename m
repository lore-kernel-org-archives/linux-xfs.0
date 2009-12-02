Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB20jqxS184603
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 18:45:52 -0600
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EE86C414F
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 16:46:21 -0800 (PST)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id iEOnL1tFotU7QY2Z
	for <linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 16:46:21 -0800 (PST)
Received: by pwj11 with SMTP id 11so2842827pwj.12
	for <linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 16:46:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B1539C6.90000@sandeen.net>
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>
	<4B14936F.7040401@sandeen.net>
	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>
	<4B14B077.5090500@sandeen.net>
	<389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>
	<4B152BAD.1000004@sandeen.net>
	<389deec70912010732o72edd3c4q196088a1c01b801e@mail.gmail.com>
	<4B1539C6.90000@sandeen.net>
Date: Wed, 2 Dec 2009 08:46:20 +0800
Message-ID: <389deec70912011646y682a2cc2rd5d4ea8cfe78d2f5@mail.gmail.com>
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

MjAwOS8xMi8xIEVyaWMgU2FuZGVlbiA8c2FuZGVlbkBzYW5kZWVuLm5ldD46Cj4gaGFuayBwZW5n
IHdyb3RlOgo+PiAyMDA5LzEyLzEgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PjoK
Pj4+IGhhbmsgcGVuZyB3cm90ZToKPj4+Cj4+Pj4gVG9kYXksIEkgZW5jb3VudGVyZWQgYSBwcm9i
bGVtOgo+Pj4+IEkgdXNlICJ4ZnNfcmVwYWlyIC1MIOKAnCBvbiBhIGRhbWFnZWQgZmlsZXN5c3Rl
bSBhbmQgYSBsb3Qgb2YgbWVzc2FnZXMKPj4+IHdoeSBkaWQgeW91IHVzZSAtTCwgZGlkIGl0IGZh
aWwgdG8gbW91bnQgJiByZXBsYXkgdGhlIGxvZyBwcm9wZXJseT8KPj4+Cj4+IHVtb3VudCwgbW91
bnQsIHVtb3VudCBhbmQgdGhlbiB4ZnNfcmVwYWlyIGZhaWxlZCwgc28gSSBoYXZlIHRvIHVzZSAt
TC4KPgo+IEZhaWxlZCBob3c/IMKgdGhhdCdzIGEgYnVnLiDCoChvciwgLUwgZGlkIG5vdGhpbmcg
YW55d2F5IGJlY2F1c2UgdGhlIGxvZwo+IHdhc24ndCBkaXJ0eSBhZnRlciB0aGUgY2xlYW4gdW5t
b3VudCkKPgo+Pj4+IG91dHB1dCB3aGljaCBpbmNsdWRlICJtb3ZpbmcgZGlzY29ubmVjdGVkIGlu
b2RlcyB0byBsb3N0K2ZvdW5kIC4uLiIuCj4+Pj4gVGhlbiBJIGNhbiByZW1vdW50IHRoZSBmaWxl
c3lzdGVtIHN1Y2Nlc3NmdWxseSBhbmQgZGVjaWRlZCB0byByZW1vdmUKPj4+PiB0aG9zZSBmaWxl
cyBpbiBsb3N0K2ZvdW5kIGRpcmVjdG9yeSwgYnV0IGl0IHByaW50ZWQgdGhlIGZvbGxvd2luZwo+
Pj4+IG1lc3NhZ2U6Cj4+Pj4gcm9vdEAxMjM0ZGFodWE6L21udC9Qb29sX21kMS9zczEvbG9zdCtm
b3VuZCMgcm0gLXJmICoKPj4+PiBybTogY2Fubm90IHN0YXQgJzcxMCc6IFN0cnVjdHVyZSBuZWVk
cyBjbGVhbmluZwo+Pj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzI4JzogU3RydWN0dXJlIG5lZWRzIGNs
ZWFuaW5nCj4+Pj4gcm06IGNhbm5vdCBzdGF0ICc3MjknOiBTdHJ1Y3R1cmUgbmVlZHMgY2xlYW5p
bmcKPj4+PiBybTogY2Fubm90IHN0YXQgJzczMCc6IFN0cnVjdHVyZSBuZWVkcyBjbGVhbmluZwo+
Pj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzMxJzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+Pj4g
cm06IGNhbm5vdCBzdGF0ICc3MzInOiBTdHJ1Y3R1cmUgbmVlZHMgY2xlYW5pbmcKPj4+PiBybTog
Y2Fubm90IHN0YXQgJzczMyc6IFN0cnVjdHVyZSBuZWVkcyBjbGVhbmluZwo+Pj4+IHJtOiBjYW5u
b3Qgc3RhdCAnNzM0JzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+Pj4gcm06IGNhbm5vdCBz
dGF0ICc3MzUnOiBTdHJ1Y3R1cmUgbmVlZHMgY2xlYW5pbmcKPj4+IExvb2sgYXQgZG1lc2cgdG8g
c2VlIHdoYXQncyBnb25lIHdyb25nLi4uLgo+Pj4KPj4KPj4+PiBPdGhlciBkaXJlY3RvcmllcyBh
bmQgZmlsZXMgc2VlbXMgbm9ybWFsIHRvIGFjY2VzcywgaXMgaXQgbm90IGFsbG93ZWQKPj4+PiB0
byBkZWxldGUgZmlsZXMgaW4gbG9zdCtmb3VuZCBkaXJlY3RvcnkgYWZ0ZXIgcmVwYWlyLCB0aGVu
IHdoYXQgc2hvdWxkCj4+Pj4gSSBkbz8KPj4+IFRoaXMgaXMgaW5kaWNhdGl2ZSBvZiBhIGJ1ZyBv
ciBJTyBlcnJvciB0aGF0IGNhdXNlZCB4ZnMgdG8gc2h1dCBkb3duLgo+Pj4KPj4+IFlvdSBoYXZl
bid0IG1lbnRpb25lZCB3aGljaCBrZXJuZWwgdmVyc2lvbiwgYXJjaGl0ZWN0dXJlLCBvcgo+Pj4g
dmVyc2lvbiBvZiB4ZnNwcm9ncyB5b3UncmUgdXNpbmcgeWV0IC4uLiB0aGF0IG1heSBvZmZlciBz
b21lIGNsdWVzLgo+Pj4KPj4KPj4+IEknbSBndWVzc2luZyBhbiBvbGRlciBrZXJuZWwgYW5kIHVz
ZXJzcGFjZSBvbiBhcm0/IDopCj4+Pgo+PiBrZXJuZWwgdmVyc2lvbiBpcyAyLjYuMjMsIHhmc3By
b2dzIGlzIDIuOS43LCBDUFUgaXMgTVBDODU0OCwgcG93ZXJwYyBhcmNoLgo+PiBJIGFtIGF0IGhv
bWUgbm93LCBNYXliZSBJIGNhbiBwcm92aWRlIHNvbWUgZGV0YWlsZWQgaW5mb3JtYXRpb24gdG9t
b3Jyb3cuCj4KPiBJZiB0aGVyZSdzIGFueSBwb3NzaWJpbGl0eSB0byB0ZXN0IG5ld2VyIGtlcm5l
bCAmIHVzZXJzcGFjZSwgdGhhdCdkCj4gYmUgZ3JlYXQuIMKgTWFueSBidWdzIGhhdmUgYmVlbiBm
aXhlZCBzaW5jZSB0aG9zZSB2ZXJzaW9ucy4KPgpXZSBkaWQgaGF2ZSBwbGFuIHRvIHVwZ3JhZGUg
a2VybmVsIHRvIGxhdGVzdCAyLjYuMzEuCkJUVywgSXMgdGhlcmUgc29tZSBwbGFjZSB3aGVyZSBJ
IGNhbiBjaGVjayB0aG9zZSBmaXhlZCBidWcgbGlzdCBhY3Jvc3MgdmVyc2lvbnM/Cj4gLUVyaWMK
Pgo+Pj4gLUVyaWMKPj4+Cj4+Cj4+Cj4+Cj4KPgoKCgotLSAKVGhlIHNpbXBsZXN0IGlzIG5vdCBh
bGwgYmVzdCBidXQgdGhlIGJlc3QgaXMgc3VyZWx5IHRoZSBzaW1wbGVzdCEKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
