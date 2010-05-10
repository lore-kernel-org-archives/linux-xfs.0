Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AEbbpZ007254 for <xfs@oss.sgi.com>; Mon, 10 May 2010 09:37:38 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C8931DEA616
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 07:39:49 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id qf47CFJeEZSQ1wG4 for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 07:39:49 -0700 (PDT)
Message-ID: <4BE81AB4.7000600@sandeen.net>
Date: Mon, 10 May 2010 09:39:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: posix_fallocate
References: <201005071022.37863.kb@sysmikro.com.pl>
	<4BE43F34.40309@sandeen.net> <4BE44587.6090603@sandeen.net>
	<201005100911.52491.kb@sysmikro.com.pl>
In-Reply-To: <201005100911.52491.kb@sysmikro.com.pl>
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
To: =?UTF-8?B?S3J6eXN6dG9mIELFgmFzemtvd3NraQ==?= <kb@sysmikro.com.pl>
Cc: xfs@oss.sgi.com

S3J6eXN6dG9mIELFgmFzemtvd3NraSB3cm90ZToKPiBPbiBGcmlkYXkgMDcgTWF5IDIwMTAgMTg6
NTMsIEVyaWMgU2FuZGVlbiB3cm90ZToKPj4gRXJpYyBTYW5kZWVuIHdyb3RlOgo+Pj4gS3J6eXN6
dG9mIELFgmFzemtvd3NraSB3cm90ZToKPj4+PiBIZWxsbywKPj4+Pgo+Pj4+IEkgdXNlIHRoaXMg
dG8gcHJlYWxsb2NhdGUgbGFyZ2Ugc3BhY2UgYnV0IGZvdW5kIGFuIGlzc3VlLgo+Pj4+IFBvc2l4
X2ZhbGxvY2F0ZSB3b3JrcyByaWdodCB3aXRoIHNpemVzIGxpa2UgMTAwRywgMVQgYW5kIGV2ZW4g
MTBUIG9uCj4+Pj4gc29tZSBib3hlcyAob24gc29tZSBvdGhlciBjYW4gZmFpbCBhZnRlciBlLmcu
IDdUIHRocmVzaG9sZCkgYnV0IGlmIGkKPj4+PiB0cmllZCBlLmcuIDE2VCB0aGUgdXNlciBzcGFj
ZSBwcm9jZXNzIHdvdWxkIGJlICJSInVubmluZyBmb3JldmVyIGFuZCBpdAo+Pj4+IGlzIG5vdCBp
bnRlcnJ1cHRpYmxlLiBGdXJ0aGVybW9yZSBzb21lIG90aGVyIG5vdCByZWxhdGVkIHByb2Nlc3Nl
cyBsaWtlCj4+Pj4gc3NoZCwgYmFzaCBlbnRlciBEIHN0YXRlLiBUaGVyZSBpcyBub3RoaW5nIGlu
IGtlcm5lbCBsb2cuCj4+IE9oLCBvbmUgdGhpbmcgeW91IHNob3VsZCBrbm93IGlzIHRoYXQgZGVw
ZW5kaW5nIG9uIHlvdXIgdmVyc2lvbiBvZiBnbGliYywKPj4gcG9zaXhfZmFsbG9jYXRlIG1heSBi
ZSB3cml0aW5nIDBzIGFuZCBub3QgdXNpbmcgcHJlYWxsb2NhdGlvbiBjYWxscy4KPiAKPiBJIGFt
IGFic29sdXRlbHkgc3VyZSB0aGF0IHJlY2VudCBsaWJjIGRvZXNuJ3QgZW11bGF0ZSB0aGlzIHN5
c2NhbGwgCgpyaWdodCwgcmVjZW50IGdsaWJjIGRvZXMgbm90ICh1bmxlc3MgdGhlIHVuZGVybHlp
bmcgZnMgZG9lc24ndCBzdXBwb3J0IGl0KQoKLi4uCgo+IFdlIHN0aWNrIHdpdGggMi42LjMxLjUg
d2hpY2ggc2VlbXMgdG8gYmUgZ29vZCBmb3IgdXMuIFdlIGRvIG5vdCBjaGFuZ2Uga2VybmVscyAK
PiBlYXNpbHksIGFzIHNvb24gYXMgaGlnaGVyIHJldmlzaW9uIGFycml2ZXMgYmVjYXVzZSBpdCBk
b2Vzbid0IG1ha2Ugc2Vuc2UgZnJvbSAKPiBzdGFiaWxpdHkgcG9pbnQgb2Ygdmlldy4gV2UgaGF2
ZSBzZWVuIHRvbyBtYW55IHRpbWVzIHJlZ3Jlc3Npb24gYnVncyBzbyBpZiB3ZSAKPiBhcmUgY29u
ZmlkZW50IHdpdGggc29tZSByZXZpc2lvbiB0aGVuIHRoZXJlIGlzIG5vIHBvaW50IHRvIGNoYW5n
ZSB0aGlzLgoKSXQgd2FzIGp1c3QgYSB0ZXN0aW5nIHN1Z2dlc3Rpb24sIGJ1dCBJIGFscmVhZHkg
dGVzdGVkIHVwc3RyZWFtIGFuZCB0aGUgcHJvYmxlbQpwZXJzaXN0cywgbm93IGp1c3QgbmVlZCB0
byBmaW5kIHRoZSB0aW1lIHRvIGRpZyBpbnRvIGl0LgoKLUVyaWMKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5z
Z2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
