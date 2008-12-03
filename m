Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3Lm4xE021694 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 15:48:04 -0600
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61A5A16879EA
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 13:48:02 -0800 (PST)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id 68343KExoGsKaFpH for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 13:48:02 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: 2.6.27.7 vanilla,
	project quota enabled and process stuck in D state (repeatable every
	time)
Date: Wed, 3 Dec 2008 22:42:29 +0100
References: <200812021949.55463.arekm@maven.pl>
	<200812031406.41882.arekm@maven.pl>
	<20081203213028.GW18236@disturbed>
In-Reply-To: <20081203213028.GW18236@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812032242.29326.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: xfs@oss.sgi.com

T24gV2VkbmVzZGF5IDAzIG9mIERlY2VtYmVyIDIwMDgsIERhdmUgQ2hpbm5lciB3cm90ZToKCj4g
PiBELXN0YXRlIGxvY2sgaXMgYWxzbyBoYXBwZW5pbmcgaWYgSSBkcm9wIHVzcnF1b3RhLHByanF1
b3RhLCByZWJvb3QgYW5kCj4gPiByZXRyeSB0aGUgdGVzdC4gSSBhc3N1bWUgc29tZXRoaW5nIHdh
cyB3cml0dGVuIG9uIGRpc2sgdGhhdCB0cmlnZ2VycyB0aGUKPiA+IHByb2JsZW0uCj4KPiBVbmxp
a2VseSAtIGxvY2tpbmcgZG9lc24ndCBnZW5lcmFsbHkgZ2V0IHN0dWNrIGR1ZSB0byBvbiBkaXNr
Cj4gY29ycnVwdGlvbi4gQXJlIHRoZXJlIGFueSBvdGhlciBibG9ja2VkIHByb2Nlc3NlcyBpbiB0
aGUgbWFjaGluZT8KPiBpLmUuIHdoYXQgaXMgdGhlIGVudGlyZSBvdXRwdXQgb2YgJ2VjaG8gdyA+
IC9wcm9jL3N5c3JxLXRyaWdnZXInPwoKT25seSB0aGlzIG9uZSBwcm9ncmFtIHRyYWNlIHZpc2li
bGUgaW4gc3lzcnEtdyBvdXRwdXQuIE5vIG90aGVyIHRyYWNlcyAtIHNvIG5vIApvdGhlciBibG9j
a2VkIHByb2dyYW1zLgoKPiBBcmUgdGhlcmUgYW55IG90aGVyIHNpZ25zIG9mIGdlbmVyYWwgdW53
ZWxsbmVzcyAoZS5nLiBhIENQVSBydW5uaW5nCj4gYXQgMTAwJSB3aGVuIGl0IHNob3VsZG4ndCBi
ZSk/CgpOb3RoaW5nIHdyb25nLgoKPiBGV0lXLCBpZiB5b3UgYXJlIHNlZWluZyB0aGlzIG9uIHR3
byBob3N0cywgY2FuIHlvdSB0cnkgdG8gYnVpbGQKPiBhIHJlcHJvZHVjYWJsZSB0ZXN0IGNhc2Ug
dXNpbmcgYSBtaW5pbWFsIGRhdGEgc2V0IGFuZCBhIHNpbXBsZQo+IHNldCBvZiBjb21tYW5kcz8g
SWYgeW91IGNhbiBkbyB0aGlzIGFuZCBzdXBwbHkgdXMgd2l0aCBhCj4geGZzX21ldGFkdW1wIGlt
YWdlIG9mIHRoZSBmaWxlc3lzdGVtIHBsdXMgdGhlIGNvbW1hbmRzIHRvIHJlcHJvZHVjZQo+IHRo
ZSBwcm9ibGVtIHdlJ2xsIGJlIGFibGUgdG8gZmluZCB0aGUgcHJvYmxlbSBwcmV0dHkgcXVpY2ts
eS4uLi4KCkkgd2FzIGFibGUgdG8gcmVwcm9kdWNlIGl0IHdpdGg6CgotIG1vdW50IGZzIHdpdGgg
dXNycXVvdGEscHJqcXVvdGEKLSBzZXR1cCAvaG9tZS91c2Vycy9hcmVrbS9ycG0gYXMgcHJvamVj
dCBxdW90YSBpZCA9IDEwCi0gcnVuIHByb2dyYW0gYmVsb3cgdHdpY2UKClthcmVrbUBmYXJtIHJw
bV0kIG1vcmUgYS5jCiNpbmNsdWRlIDxzdGRpby5oPgogCmludCBtYWluKCkgewogICAgICAgIGlu
dCBpOwogCiAgICAgICAgaSA9IApyZW5hbWUoIi9ob21lL3VzZXJzL2FyZWttL3RtcC9hYSIsICIv
aG9tZS91c2Vycy9hcmVrbS9ycG0vdGVzdGluZyIpOwogICAgICAgIHByaW50ZigicmV0PSVkICVt
XG4iLCBpKTsKICAgICAgICByZXR1cm4gMDsKfQpbYXJla21AZmFybSBycG1dJCB0b3VjaCAvaG9t
ZS91c2Vycy9hcmVrbS90bXAvYWEKW2FyZWttQGZhcm0gcnBtXSQgLi9hLm91dApyZXQ9LTEgSW52
YWxpZCBjcm9zcy1kZXZpY2UgbGluawpbYXJla21AZmFybSBycG1dJCAuL2Eub3V0CgpzZWNvbmQg
cnVuIGhhbmdzIHdpdGggRC1zdGF0ZS4gCgpGb3IgY2xhcmlmaWNhdGlvbiwgcnBtIGFuZCB0bXAg
ZGlyZWN0b3JpZXMgYXJlIG9uIHRoZSBzYW1lIApmaWxlc3lzdGVtL3BhcnRpdGlvbiAoaGRhMiks
IHJwbS8gZGlyIGJlbG9uZ3MgdG8gcHJvamVjdCBxdW90YSBpZD0xMCwgdG1wIApkb2Vzbid0IGJl
bG9uZyB0byBhbnkgcHJvamVjdCBxdW90YS4KCkZvciB0aGUgcmVzdCBvZiB5b3VyIHF1ZXN0aW9u
cyAtICBDaHJpc3RvcGggcHJvbWlzZWQgdG8gbG9vayBhdCB0aGUgaXNzdWUgCnRvZGF5LCBzbyBJ
J2xsIHdhaXQgdW50aWwgdG9tb3Jyb3cgYW5kIGlmIHRoZSBpc3N1ZSB3aWxsIHN0aWxsIGJlIGEg
bXlzdGVyeSAKdGhlbiBJJ2xsIGRpZyBvdXQgYWxsIGRhdGEgeW91IGFza2VkIGZvci4KCj4gQ2hl
ZXJzLAo+Cj4gRGF2ZS4KCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3ogICAgICAgIFBMRC9MaW51
eCBUZWFtCmFyZWttIC8gbWF2ZW4ucGwgICAgICAgICAgICBodHRwOi8vZnRwLnBsZC1saW51eC5v
cmcvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMg
bWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9s
aXN0aW5mby94ZnMK
