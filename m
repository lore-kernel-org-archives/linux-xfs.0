Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F181E29DF9
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 12:03:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAA6D304051
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 10:03:28 -0800 (PST)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id fBBqpQ5ZBSLKEhO9 for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 10:03:24 -0800 (PST)
Subject: Re: Question on how to submit changed code
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20151201174437.GA4037@redhat.com>
References: <105716A9A63E8A4C9CB26A0F29E203DCF40BE069@usbpx2pmxmbx12>
	<1448991660.16687.159.camel@montana.filmlight.ltd.uk>
	<20151201174437.GA4037@redhat.com>
Date: Tue, 01 Dec 2015 18:03:23 +0000
Message-Id: <1448993003.16687.171.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Epp, Mike" <MEpp@KrollOntrack.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Ck9uIFR1ZSwgMjAxNS0xMi0wMSBhdCAxODo0NCArMDEwMCwgQ2FybG9zIE1haW9saW5vIHdyb3Rl
Ogo+IE9uIFR1ZSwgRGVjIDAxLCAyMDE1IGF0IDA1OjQxOjAwUE0gKzAwMDAsIFJvZ2VyIFdpbGxj
b2NrcyB3cm90ZToKPiA+IAo+ID4gT24gVHVlLCAyMDE1LTEyLTAxIGF0IDE1OjE2ICswMDAwLCBF
cHAsIE1pa2Ugd3JvdGU6Cj4gPiA+IEkgaGF2ZSBjaGFuZ2VkIGNvZGUgaW4gbGlieGZzIGFuZCBy
ZXBhaXIgcHJvamVjdHMgZm9yIHhmc3Byb2dzLiAgSQo+ID4gPiBkb27igJl0IHZpZXcgdGhlIGNo
YW5nZXMgYXMgZGVzaXJlZCBmb3Igb25nb2luZyBkZXBsb3ltZW50LCBhcyB0aGV5Cj4gPiA+IGFs
bG93ZWQgc2Nhbm5pbmcgb2YgYWN0aXZlIHZvbHVtZXMgYW5kIGJyaW5nIHRoZSBjaGFuY2Ugb2Yg
ZmFsc2UKPiA+ID4gZXJyb3JzLiAgVG8gc3RheSBjb21wbGlhbnQgd2l0aCBHTlUgR1BMIHRob3Vn
aCB3ZSBtdXN0IHB1Ymxpc2ggdGhlCj4gPiA+IGNvZGUuICBXaGF0IGFyZSB0aGUgc3RlcHMgSSBu
ZWVkIHRvIGZvbGxvdyB0byBwdWJsaXNoIHRoZSBjaGFuZ2VzPyAgRG8KPiA+ID4gSSBuZWVkIHRv
IHB1Ymxpc2gganVzdCB0aGUgc291cmNlIGZpbGVzIEkgY2hhbmdlZCwgdGhlIGVudGlyZSBwcm9q
ZWN0cwo+ID4gPiBJIGNoYW5nZXMsIG9yIGFsbCBvZiB4ZnNwcm9ncz8KPiA+ID4gCj4gPiAKPiA+
IFlvdSBkb24ndCBuZWVkIHRvIHB1Ymxpc2ggdGhlIGNvZGUgYnV0IHlvdSBkbyBuZWVkIHRvIG1h
a2UgYSBmdWxsIGNvcHkKPiA+IG9mIHRoZSBjb2RlLCBpbmNsdWRpbmcgeW91ciBjbGVhcmx5IG1h
cmtlZCBjaGFuZ2VzLCBhdmFpbGFibGUgdG8geW91cgo+ID4gY3VzdG9tZXJzLgo+ID4gCj4gPiBT
ZWUgR1BMIHNlY3Rpb24gMy4KPiAKPiBKdXN0IEZZSSwgeGZzcHJvZ3MgaXMgbGljZW5zZWQgdW5k
ZXIgR1BMIFYyLCBub3QgVjMsIHRoZXkgYXJlIGRpZmZlcmVudCBpbiBtYW55Cj4gYXNwZWN0cy4K
PiAKCnhmc3Byb2dzIHNvdXJjZSBjb2RlIChlLmcuIHhmc19kaXIyX25vZGUuYykgc2F5czoKCiAq
IFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBh
bmQvb3IKICogbW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UgYXMKICogcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRp
b24uCgp3aGljaCBwcm9iYWJseSBtYWtlcyBpdCBWMS4KCmh0dHA6Ly9saW51eC14ZnMub3NzLnNn
aS5uYXJraXZlLmNvbS9kckpSVXNJbi94ZnNwcm9ncy14ZnNkdW1wLXdoYXQtZmxhdm9yLW9mLWdw
bAoKLS0KUm9nZXIKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
