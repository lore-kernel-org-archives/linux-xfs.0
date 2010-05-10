Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AIF4se020593 for <xfs@oss.sgi.com>; Mon, 10 May 2010 13:15:05 -0500
Received: from v007470.home.net.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id BD18C1DEAE10
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 11:17:16 -0700 (PDT)
Received: from v007470.home.net.pl (v007470.home.net.pl [212.85.125.104]) by
	cuda.sgi.com with SMTP id dbeRbhdnsMjCfZlk for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 11:17:16 -0700 (PDT)
From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: posix_fallocate
Date: Mon, 10 May 2010 20:17:11 +0200
References: <201005071022.37863.kb@sysmikro.com.pl>
	<201005100911.52491.kb@sysmikro.com.pl>
	<4BE81AB4.7000600@sandeen.net>
In-Reply-To: <4BE81AB4.7000600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201005102017.11706.kb@sysmikro.com.pl>
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
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

T24gTW9uZGF5IDEwIE1heSAyMDEwIDE2OjM5LCBFcmljIFNhbmRlZW4gd3JvdGU6Cj4gS3J6eXN6
dG9mIELFgmFzemtvd3NraSB3cm90ZToKPiA+IE9uIEZyaWRheSAwNyBNYXkgMjAxMCAxODo1Mywg
RXJpYyBTYW5kZWVuIHdyb3RlOgo+ID4+IEVyaWMgU2FuZGVlbiB3cm90ZToKPiA+Pj4gS3J6eXN6
dG9mIELFgmFzemtvd3NraSB3cm90ZToKPiA+Pj4+IEhlbGxvLAo+ID4+Pj4KPiA+Pj4+IEkgdXNl
IHRoaXMgdG8gcHJlYWxsb2NhdGUgbGFyZ2Ugc3BhY2UgYnV0IGZvdW5kIGFuIGlzc3VlLgo+ID4+
Pj4gUG9zaXhfZmFsbG9jYXRlIHdvcmtzIHJpZ2h0IHdpdGggc2l6ZXMgbGlrZSAxMDBHLCAxVCBh
bmQgZXZlbiAxMFQgb24KPiA+Pj4+IHNvbWUgYm94ZXMgKG9uIHNvbWUgb3RoZXIgY2FuIGZhaWwg
YWZ0ZXIgZS5nLiA3VCB0aHJlc2hvbGQpIGJ1dCBpZiBpCj4gPj4+PiB0cmllZCBlLmcuIDE2VCB0
aGUgdXNlciBzcGFjZSBwcm9jZXNzIHdvdWxkIGJlICJSInVubmluZyBmb3JldmVyIGFuZAo+ID4+
Pj4gaXQgaXMgbm90IGludGVycnVwdGlibGUuIEZ1cnRoZXJtb3JlIHNvbWUgb3RoZXIgbm90IHJl
bGF0ZWQgcHJvY2Vzc2VzCj4gPj4+PiBsaWtlIHNzaGQsIGJhc2ggZW50ZXIgRCBzdGF0ZS4gVGhl
cmUgaXMgbm90aGluZyBpbiBrZXJuZWwgbG9nLgo+ID4+Cj4gPj4gT2gsIG9uZSB0aGluZyB5b3Ug
c2hvdWxkIGtub3cgaXMgdGhhdCBkZXBlbmRpbmcgb24geW91ciB2ZXJzaW9uIG9mCj4gPj4gZ2xp
YmMsIHBvc2l4X2ZhbGxvY2F0ZSBtYXkgYmUgd3JpdGluZyAwcyBhbmQgbm90IHVzaW5nIHByZWFs
bG9jYXRpb24KPiA+PiBjYWxscy4KPiA+Cj4gPiBJIGFtIGFic29sdXRlbHkgc3VyZSB0aGF0IHJl
Y2VudCBsaWJjIGRvZXNuJ3QgZW11bGF0ZSB0aGlzIHN5c2NhbGwKPgo+IHJpZ2h0LCByZWNlbnQg
Z2xpYmMgZG9lcyBub3QgKHVubGVzcyB0aGUgdW5kZXJseWluZyBmcyBkb2Vzbid0IHN1cHBvcnQg
aXQpCj4KPiAuLi4KPgo+ID4gV2Ugc3RpY2sgd2l0aCAyLjYuMzEuNSB3aGljaCBzZWVtcyB0byBi
ZSBnb29kIGZvciB1cy4gV2UgZG8gbm90IGNoYW5nZQo+ID4ga2VybmVscyBlYXNpbHksIGFzIHNv
b24gYXMgaGlnaGVyIHJldmlzaW9uIGFycml2ZXMgYmVjYXVzZSBpdCBkb2Vzbid0Cj4gPiBtYWtl
IHNlbnNlIGZyb20gc3RhYmlsaXR5IHBvaW50IG9mIHZpZXcuIFdlIGhhdmUgc2VlbiB0b28gbWFu
eSB0aW1lcwo+ID4gcmVncmVzc2lvbiBidWdzIHNvIGlmIHdlIGFyZSBjb25maWRlbnQgd2l0aCBz
b21lIHJldmlzaW9uIHRoZW4gdGhlcmUgaXMKPiA+IG5vIHBvaW50IHRvIGNoYW5nZSB0aGlzLgo+
Cj4gSXQgd2FzIGp1c3QgYSB0ZXN0aW5nIHN1Z2dlc3Rpb24sIGJ1dCBJIGFscmVhZHkgdGVzdGVk
IHVwc3RyZWFtIGFuZCB0aGUKPiBwcm9ibGVtIHBlcnNpc3RzLCBub3cganVzdCBuZWVkIHRvIGZp
bmQgdGhlIHRpbWUgdG8gZGlnIGludG8gaXQuCgpJIHNlZSBhbmQgSSBhbSBnbGFkIHlvdSBjb25m
aXJtZWQgdGhpcy4gRG8geW91IHRoaW5rIHRoYXQgZmFsbG9jYXRlIGNhbGxlZCAKbWFueSB0aW1l
cyB3aXRoIGZpeGVkIHNpemUgYW5kIGluY3JlYXNpbmcgb2Zmc2V0IHdpbGwgd29yayBiZXR0ZXIg
dGhhbiBvbmUgCnRpbWUgY2FsbCB3aXRoIGh1Z2Ugc2l6ZSBAIDAgb2Zmc2V0ID8KCktyenlzenRv
Zgo+Cj4gLUVyaWMKPgo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCj4geGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0
cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
