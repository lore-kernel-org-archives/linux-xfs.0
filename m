Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p13M0INk219564 for <xfs@oss.sgi.com>; Thu, 3 Feb 2011 16:00:18 -0600
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4E83162EE08
	for <xfs@oss.sgi.com>; Thu,  3 Feb 2011 14:02:43 -0800 (PST)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	oyL03qhO6afvHtEu for <xfs@oss.sgi.com>;
	Thu, 03 Feb 2011 14:02:43 -0800 (PST)
Received: by eyh6 with SMTP id 6so1066978eyh.26
	for <xfs@oss.sgi.com>; Thu, 03 Feb 2011 14:02:42 -0800 (PST)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: [GIT PULL] XFS update for 2.6.38-rc3
Date: Thu, 3 Feb 2011 23:02:31 +0100
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
	<4D482E21.5040803@teksavvy.com> <20110203000757.GT11040@dastard>
In-Reply-To: <20110203000757.GT11040@dastard>
MIME-Version: 1.0
Message-Id: <201102032302.31780.a.miskiewicz@gmail.com>
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: Mark Lord <kernel@teksavvy.com>, stable@kernel.org, Alex Elder <aelder@sgi.com>

T24gVGh1cnNkYXkgMDMgb2YgRmVicnVhcnkgMjAxMSwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IE9u
IFR1ZSwgRmViIDAxLCAyMDExIGF0IDExOjAwOjMzQU0gLTA1MDAsIE1hcmsgTG9yZCB3cm90ZToK
PiA+IE9uIDExLTAxLTMxIDExOjQyIEFNLCBBbGV4IEVsZGVyIHdyb3RlOgo+ID4gPiBMaW51cywg
cGxlYXNlIGFjY2VwdCB0aGUgZm9sbG93aW5nIHVwZGF0ZXMgZm9yIFhGUywgZm9yIDIuNi4zOC1y
YzMKPiA+ID4gKGlmIGl0J3Mgbm90IHRvbyBsYXRlKSBvciAyLjYuMzgtcmM0Lgo+ID4gPiAKPiA+
ID4gVGhleSBhcmUgYWxsIGZpeGVzIGZvciBidWdzIHRoYXQgaGF2ZSBzb21lIHByZXR0eSB1bmRl
c2lyYWJsZQo+ID4gPiBjb25zZXF1ZW5jZXMuIAoKWy4uLl0KCj4gPiBBcmUgdGhlc2UgYnVncyBh
bGwgbmV3IGluIDIuNi4zOCwgb3Igc2hvdWxkIHNvbWUgb2YgdGhlc2UgZml4ZXMKPiA+IGFsc28g
Z28gb3V0IHRvIC1zdGFibGUgZm9yIGVhcmxpZXIgcmV2aXNpb25zPwo+ID4gPiAgICAgICB4ZnM6
IGZpeCBkcXVvdCBzaGFrZXIgZGVhZGxvY2sKPiAKPiBUaGF0J3MgYSByZWdyZXNzaW9uLCBzbyBt
YXliZS4KCkRlZmluaXRlbHksIHhmc19mc3IgY2FuIGhpdCB0aGlzIGV2ZW4gZmV3IHRpbWVzIGEg
ZGF5IChoYXBwZW5lZCBhbHJlYWR5KS4KClN0YWJsZSB0ZWFtLCBwbGVhc2UgaW5jbHVkZSB0aGlz
IG9uZSBmb3IgMi42LjM3LjE6Cgpjb21taXQgMGZiY2E0ZDFjMzkzMmMyN2M0Nzk0YmY1YzJiNWZj
OTYxY2Y1YTU0ZgpBdXRob3I6IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KRGF0
ZTogICBGcmkgSmFuIDI4IDExOjIwOjQ2IDIwMTEgKzExMDAKCiAgICB4ZnM6IGZpeCBkcXVvdCBz
aGFrZXIgZGVhZGxvY2sKCiAgICBDb21taXQgMzY4ZTEzNiAoInhmczogcmVtb3ZlIGR1cGxpY2F0
ZSBjb2RlIGZyb20gZHF1b3QgcmVjbGFpbSIpIGZhaWxzCiAgICB0byB1bmxvY2sgdGhlIGRxdW90
IGZyZWVsaXN0IHdoZW4gdGhlIG51bWJlciBvZiBsb29wIHJlc3RhcnRzIGlzCiAgICBleGNlZWRl
ZCBpbiB4ZnNfcW1fZHFyZWNsYWltX29uZSgpLiBUaGlzIGNhdXNlcyBoYW5ncyBpbiBtZW1vcnkK
ICAgIHJlY2xhaW0uCgogICAgUmV3b3JrIHRoZSBsb29wIGNvbnRyb2wgbG9naWMgaW50byBhbiB1
bndpbmQgc3RhY2sgdGhhdCBhbGwgdGhlCiAgICBkaWZmZXJlbnQgY2FzZXMganVtcCBpbnRvLiBU
aGlzIG1lYW5zIHRoZXJlIGlzIG9ubHkgb25lIHNldCBvZiBjb2RlCiAgICB0aGF0IHByb2Nlc3Nl
cyB0aGUgbG9vcCBleGl0IGNyaXRlcmlhLCBhbmQgc2ltcGxpZmllcyB0aGUgdW5sb2NraW5nCiAg
ICBvZiBhbGwgdGhlIGl0ZW1zIGZyb20gZGlmZmVyZW50IHBvaW50cyBpbiB0aGUgbG9vcC4gSXQg
YWxzbyBmaXhlcyBhCiAgICBkb3VibGUgaW5jcmVtZW50IG9mIHRoZSByZXN0YXJ0IGNvdW50ZXIg
ZnJvbSB0aGUgcWlfZHFsaXN0X2xvY2sKICAgIGNhc2UuCgogICAgUmVwb3J0ZWQtYnk6IE1hbGNv
bG0gU2NvdHQgPGxrbWxAbWFsYy5vcmcudWs+CiAgICBTaWduZWQtb2ZmLWJ5OiBEYXZlIENoaW5u
ZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+CiAgICBSZXZpZXdlZC1ieTogQWxleCBFbGRlciA8YWVs
ZGVyQHNnaS5jb20+CgoKPiBDaGVlcnMsCj4gCj4gRGF2ZS4KCgotLSAKQXJrYWRpdXN6IE1pxZtr
aWV3aWN6ICAgICAgICBQTEQvTGludXggVGVhbQphcmVrbSAvIG1hdmVuLnBsICAgICAgICAgICAg
aHR0cDovL2Z0cC5wbGQtbGludXgub3JnLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
