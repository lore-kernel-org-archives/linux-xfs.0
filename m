Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BISfBG184135 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 12:28:41 -0600
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	2sSSy8pKDqLHLK2i for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 10:28:39 -0800 (PST)
Received: by wibhr12 with SMTP id hr12so671019wib.26
	for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 10:28:39 -0800 (PST)
From: Rafa =?utf-8?q?Grim=C3=A1n?= <rafagriman@gmail.com>
Subject: Re: Empty dir can't be removed ... because it's not empty?
Date: Wed, 11 Jan 2012 19:28:35 +0100
References: <201201102126.35268.rafagriman@gmail.com>
	<20120110221024.GC24410@dastard>
In-Reply-To: <20120110221024.GC24410@dastard>
MIME-Version: 1.0
Message-Id: <201201111928.35564.rafagriman@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

SGkgOikKCk9uIFR1ZXNkYXksIEphbnVhcnkgMTAsIDIwMTIgMTE6MTAgUE0gRGF2ZSBDaGlubmVy
IHdyb3RlCj4gT24gVHVlLCBKYW4gMTAsIDIwMTIgYXQgMDk6MjY6MzVQTSArMDEwMCwgUmFmYSBH
cmlt77+9biB3cm90ZToKPiA+IEhpIGFsbCA6KQo+ID4gCj4gPiBNeSAvaG9tZSBpcyBvbiBhbiBY
RlMgcGFydGl0aW9uIGFsbCB0byBpdCdzIG93bi4gVGhlIG90aGVyIGRheSB0aGUgbGlnaHRzCj4g
PiB3ZW50IG91dCBhbmQgd2hlbiBJIHJlYm9vdGVkLCB0aGVyZSdzIGFuIGVtcHR5IGRpcmVjdG9y
eSB0aGF0IGNhbid0IGJlCj4gPiBlcmFzZWQuIFRoaXMgZGlyZWN0b3J5IGlzIGEgc3ViZGlyZWN0
b3J5IGluIH4vLmtkZTQvCj4gCj4gSXMgeW91ciBzeXN0ZW0gdXNpbmcgYmFycmllcnMgKGkuZS4g
bW91bnRpbmcgd2l0aCBub2JhcnJpZXIgb3B0aW9uLAo+IG9yIGhhcmR3YXJlIHRoYXQgZG9lc24n
dCBzdXBwb3J0IEZVQSk/IERpcmVjdG9yeSBjb3JydXB0aW9uIGxpa2UKPiB0aGlzIG9uIHBvd2Vy
IGZhaWx1cmUgaXMgYSBjbGFzc2ljIHNpZ24gb2YgYSB2b2x0aWxlIGRyaXZlIGNhY2hlCj4gYmVp
bmcgbG9zdCBvbiBwb3dlciBmYWlsdXJlLgoKCk5vcGUsIG5vIGJhcnJpZXJzLiBJdCdzIGEgc2lu
Z2xlIGludGVybmFsIFNBVEEgZHJpdmUuIEl0J3MgbXkgcGVyc29uYWwgUEMgYXQgCmhvbWUgc28g
bm8gZmFuY3kgaGFyZHdhcmUgOigKCgo+IFRoZSBvdXRwdXQgb2YgZG1lc2cgZnJvbSBhIHN5c3Rl
bSBib290IHdpbGwgdGVsbCB1cyB3aGF0IGhhcmR3YXJlCj4geW91IGhhdmUuLi4KPiAKPiA+IFRo
ZSBmdW5ueSB0aGluZyBhYm91dCB0aGlzIGlzIHRoYXQgSSBjYW4gcmVuYW1lIHRoZSBkaXJlY3Rv
cnksIGJ1dCBJCj4gPiBjYW4ndCBkZWxldGUgaXQ6Cj4gPiAKPiA+IFtyb290QG1pbmUgYWxidW1j
b3ZlcnNdIyBscwo+ID4gLiAgLi4gIGNhY2hlCj4gPiAKPiA+IFtyb290QG1pbmUgYWxidW1jb3Zl
cnNdIyBscyAtbGFoIGNhY2hlLwo+ID4gdG90YWwgMAo+ID4gZHJ3eC0tLS0tLSAxIHJhZmEgdXNl
cnMgIDYgSmFuIDEwIDAyOjIzIC4KPiA+IGRyd3gtLS0tLS0gMyByYWZhIHVzZXJzIDE4IEphbiAx
MCAwMjoyMyAuLgo+IAo+ICAgICAgICAgICAgIF5eXgo+IAo+IEl0J3MgbGluayBjb3VudCBpcyAz
LCBtZWFuaW5nIHRoYXQgaXQgdGhpbmtzIHRoYXQgdGhlcmUgaXMgYW4gZW50cnkKPiBpbiB0aGUg
ZGlyZWN0b3J5LiBZb3UgbmVlZCB0byBydW4geGZzX3JlcGFpciB0byBmaXggaXQgKGFuZCB3aGF0
ZXZlcgo+IGVsc2UgaXMgYnJva2VuKS4KCgpUaGFua3MgRGF2ZSBhbmQgTWFya3VzLiBUaGUgdGhp
bmcgaXMgdGhhdCB3aGVuIHRoZSBsaWdodHMgY2FtZSBiYWNrIG9uIEkgcmFuIAphbiB4ZnNfY2hl
Y2sgZmlyc3QgYW5kIGdvdCBub3RoaW5nIChubyBlcnJvcnMpLiBXaGVuIEkgZ290IHRoZSBlcnJv
ciBtZW50aW9uZWQgCmFib3ZlLCBJIHJlcmFuIGFuIHhmc19jaGVjayAobm8gZXJyb3JzKSBhbmQg
YW4geGZzX3JlcGFpciBidXQgbm90aGluZyBzZWVtZWQgCnRvIGJlIHdyb25nLiBZdXAsIHBhcnRp
dGlvbiB3YXMgdW5tb3VudGVkIDspCgpNYXliZSBJIG1lc3NlZCB1cCB0eXBpbmcgdGhlIGNvbW1h
bmQgb3IgZ28gZmlndXJlLCBpdCB3YXMgdG9vIGxhdGUuIFRoYXQnbGwgCnRlYWNoIG1lIHRvIGdv
IHRvIHNsZWVwIGF0IGEgZGVjZW50IHRpbWUgb2YgdGhlIG5pZ2h0IDspCgpJbiBhbnkgY2FzZSwg
SSBqdXN0IHdhbnRlZCB0byBrbm93IGlmIG1heWJlIHhmc19kYiBvciBzb21lIG90aGVyIHRvb2wg
Y291bGQgCmNvbWUgaW4gaGFuZHkuIENhbid0IGRvIGFueSBtb3JlIGNoZWNrcyBzaW5jZSBJIHJl
cGFydGl0aW9uZWQgbXkgZHJpdmUgYW5kIApyZW9yZ2FuaXplZCBteSBzdG9yYWdlLiBIYWQgYmFj
a3Vwcywgbm8gZGF0YSBsb3NzIHNvIGl0IHdhcyBtb3JlIG9mIGEgCmN1cmlvc2l0eS4gQmFja3Vw
czogY2FuJ3QgbGl2ZSB3aXRob3V0IHRoZW0gOykKClRoYW5rcyBmb3IgeW91ciB0aW1lICEhCgog
ICBSYWZhCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
