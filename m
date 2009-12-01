Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1Fhi03145837
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 09:43:44 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 921CF1DA0CC1
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 07:44:14 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 945uT0QnkTz4HDpR for
	<linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 07:44:14 -0800 (PST)
Message-ID: <4B1539C6.90000@sandeen.net>
Date: Tue, 01 Dec 2009 09:44:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>	
	<4B14936F.7040401@sandeen.net>	
	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>	
	<4B14B077.5090500@sandeen.net>	
	<389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>	
	<4B152BAD.1000004@sandeen.net>
	<389deec70912010732o72edd3c4q196088a1c01b801e@mail.gmail.com>
In-Reply-To: <389deec70912010732o72edd3c4q196088a1c01b801e@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

aGFuayBwZW5nIHdyb3RlOgo+IDIwMDkvMTIvMSBFcmljIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVl
bi5uZXQ+Ogo+PiBoYW5rIHBlbmcgd3JvdGU6Cj4+Cj4+PiBUb2RheSwgSSBlbmNvdW50ZXJlZCBh
IHByb2JsZW06Cj4+PiBJIHVzZSAieGZzX3JlcGFpciAtTCDigJwgb24gYSBkYW1hZ2VkIGZpbGVz
eXN0ZW0gYW5kIGEgbG90IG9mIG1lc3NhZ2VzCj4+IHdoeSBkaWQgeW91IHVzZSAtTCwgZGlkIGl0
IGZhaWwgdG8gbW91bnQgJiByZXBsYXkgdGhlIGxvZyBwcm9wZXJseT8KPj4KPiB1bW91bnQsIG1v
dW50LCB1bW91bnQgYW5kIHRoZW4geGZzX3JlcGFpciBmYWlsZWQsIHNvIEkgaGF2ZSB0byB1c2Ug
LUwuCgpGYWlsZWQgaG93PyAgdGhhdCdzIGEgYnVnLiAgKG9yLCAtTCBkaWQgbm90aGluZyBhbnl3
YXkgYmVjYXVzZSB0aGUgbG9nCndhc24ndCBkaXJ0eSBhZnRlciB0aGUgY2xlYW4gdW5tb3VudCkK
Cj4+PiBvdXRwdXQgd2hpY2ggaW5jbHVkZSAibW92aW5nIGRpc2Nvbm5lY3RlZCBpbm9kZXMgdG8g
bG9zdCtmb3VuZCAuLi4iLgo+Pj4gVGhlbiBJIGNhbiByZW1vdW50IHRoZSBmaWxlc3lzdGVtIHN1
Y2Nlc3NmdWxseSBhbmQgZGVjaWRlZCB0byByZW1vdmUKPj4+IHRob3NlIGZpbGVzIGluIGxvc3Qr
Zm91bmQgZGlyZWN0b3J5LCBidXQgaXQgcHJpbnRlZCB0aGUgZm9sbG93aW5nCj4+PiBtZXNzYWdl
Ogo+Pj4gcm9vdEAxMjM0ZGFodWE6L21udC9Qb29sX21kMS9zczEvbG9zdCtmb3VuZCMgcm0gLXJm
ICoKPj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzEwJzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+
PiBybTogY2Fubm90IHN0YXQgJzcyOCc6IFN0cnVjdHVyZSBuZWVkcyBjbGVhbmluZwo+Pj4gcm06
IGNhbm5vdCBzdGF0ICc3MjknOiBTdHJ1Y3R1cmUgbmVlZHMgY2xlYW5pbmcKPj4+IHJtOiBjYW5u
b3Qgc3RhdCAnNzMwJzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+PiBybTogY2Fubm90IHN0
YXQgJzczMSc6IFN0cnVjdHVyZSBuZWVkcyBjbGVhbmluZwo+Pj4gcm06IGNhbm5vdCBzdGF0ICc3
MzInOiBTdHJ1Y3R1cmUgbmVlZHMgY2xlYW5pbmcKPj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzMzJzog
U3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+PiBybTogY2Fubm90IHN0YXQgJzczNCc6IFN0cnVj
dHVyZSBuZWVkcyBjbGVhbmluZwo+Pj4gcm06IGNhbm5vdCBzdGF0ICc3MzUnOiBTdHJ1Y3R1cmUg
bmVlZHMgY2xlYW5pbmcKPj4gTG9vayBhdCBkbWVzZyB0byBzZWUgd2hhdCdzIGdvbmUgd3Jvbmcu
Li4uCj4+Cj4gCj4+PiBPdGhlciBkaXJlY3RvcmllcyBhbmQgZmlsZXMgc2VlbXMgbm9ybWFsIHRv
IGFjY2VzcywgaXMgaXQgbm90IGFsbG93ZWQKPj4+IHRvIGRlbGV0ZSBmaWxlcyBpbiBsb3N0K2Zv
dW5kIGRpcmVjdG9yeSBhZnRlciByZXBhaXIsIHRoZW4gd2hhdCBzaG91bGQKPj4+IEkgZG8/Cj4+
IFRoaXMgaXMgaW5kaWNhdGl2ZSBvZiBhIGJ1ZyBvciBJTyBlcnJvciB0aGF0IGNhdXNlZCB4ZnMg
dG8gc2h1dCBkb3duLgo+Pgo+PiBZb3UgaGF2ZW4ndCBtZW50aW9uZWQgd2hpY2gga2VybmVsIHZl
cnNpb24sIGFyY2hpdGVjdHVyZSwgb3IKPj4gdmVyc2lvbiBvZiB4ZnNwcm9ncyB5b3UncmUgdXNp
bmcgeWV0IC4uLiB0aGF0IG1heSBvZmZlciBzb21lIGNsdWVzLgo+Pgo+IAo+PiBJJ20gZ3Vlc3Np
bmcgYW4gb2xkZXIga2VybmVsIGFuZCB1c2Vyc3BhY2Ugb24gYXJtPyA6KQo+Pgo+IGtlcm5lbCB2
ZXJzaW9uIGlzIDIuNi4yMywgeGZzcHJvZ3MgaXMgMi45LjcsIENQVSBpcyBNUEM4NTQ4LCBwb3dl
cnBjIGFyY2guCj4gSSBhbSBhdCBob21lIG5vdywgTWF5YmUgSSBjYW4gcHJvdmlkZSBzb21lIGRl
dGFpbGVkIGluZm9ybWF0aW9uIHRvbW9ycm93LgoKSWYgdGhlcmUncyBhbnkgcG9zc2liaWxpdHkg
dG8gdGVzdCBuZXdlciBrZXJuZWwgJiB1c2Vyc3BhY2UsIHRoYXQnZCAKYmUgZ3JlYXQuICBNYW55
IGJ1Z3MgaGF2ZSBiZWVuIGZpeGVkIHNpbmNlIHRob3NlIHZlcnNpb25zLgoKLUVyaWMKCj4+IC1F
cmljCj4+Cj4gCj4gCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
