Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5ACA17F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 18:27:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A61E304039
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 16:27:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CSF7K4JHgw3vc0aU for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 16:27:19 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: XFS crashes on VMs
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CABppvi4FZKTsu22uk6nOSaShJOUyWg7cO6h-i4YekF4MLKH8RQ@mail.gmail.com>
Date: Wed, 27 May 2015 18:27:17 -0500
Message-Id: <8BF495B8-F444-415A-B7BF-5E1961C75817@sandeen.net>
References: <CABppvi4FZKTsu22uk6nOSaShJOUyWg7cO6h-i4YekF4MLKH8RQ@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

VGhhdCdzIG5vdCBhIGNyYXNoLiBUaGF0IGlzIHhmcyBkZXRlY3Rpbmcgb24gZGlzayBjb3JydXB0
aW9uIHdoaWNoIGxpa2VseSBoYXBwZW5lZCBhdCBzb21lIHRpbWUgcHJpb3IuIFlvdSBzaG91bGQg
dW5tb3VudCBhbmQgcnVuIHhmc19yZXBhaXIsIHBvc3NpYmx5IHdpdGgg4oCTbiBmaXJzdCBpZiB5
b3Ugd291bGQgbGlrZSB0byBkbyBhIGRyeSBydW4gdG8gc2VlIHdoYXQgaXQgbWlnaHQgZG8uICBJ
ZiB5b3UgZ2V0IGZyZXNoIGNvcnJ1cHRpb24gYWZ0ZXIgYSBmdWxsIHJlcGFpciwgdGhlbiB0aGF0
IGJlY29tZXMgbW9yZSBpbnRlcmVzdGluZy4gSXQncyBwb3NzaWJsZSB0aGF0IHlvdSBoYXZlIGEg
cHJvYmxlbSB3aXRoIHRoZSB1bmRlcmx5aW5nIGJsb2NrIGxheWVyIG9yIGl0J3MgcG9zc2libGUg
dGhhdCBpdCBpcyBhbiB4ZnMgYnVnIC0gIGJ1dCBJIHRoaW5rIHRoaXMgaXMgbm90IHNvbWV0aGlu
ZyB0aGF0IHdlIGhhdmUgc2VlbiBiZWZvcmUuCgpFcmljIAoKPiBPbiBNYXkgMjcsIDIwMTUsIGF0
IDY6MDYgUE0sIFNocmluYW5kIEphdmFkZWthciA8c2hyaW5hbmRAbWFnaW5hdGljcy5jb20+IHdy
b3RlOgo+IAo+IEhpLAo+IAo+IEkgYW0gcnVubmluZyBPcGVuc3RhY2sgU3dpZnQgaW4gYSBWTSB3
aXRoIFhGUyBhcyB0aGUgdW5kZXJseWluZwo+IGZpbGVzeXN0ZW0uIFRoaXMgaXMgZ2VuZXJhdGlu
ZyBhIG1ldGFkYXRhIGhlYXZ5IHdvcmtsb2FkIG9uIFhGUy4KPiBFc3NlbnRpYWxseSwgaXQgaXMg
Y3JlYXRpbmcgYSBuZXcgZGlyZWN0b3J5IGFuZCBhIG5ldyBmaWxlICgyNTZLQikgaW4KPiB0aGF0
IGRpcmVjdG9yeS4gVGhpcyBmaWxlIGhhcyBleHRlbmRlZCBhdHRyaWJ1dGVzIG9mIHNpemUgMjQz
IGJ5dGVzLgo+IAo+IEkgYW0gc2VlaW5nIHRoZSBmb2xsb3dpbmcgdHdvIGNyYXNoZXMgb2YgdGhl
IG1hY2hpbmU6Cj4gCj4gaHR0cDovL3Bhc3RpZS5vcmcvcGFzdGVzLzEwMjEwOTc0L3RleHQ/a2V5
PXhkbWZ2YW9jdmF3bnlmbWtiMDZ6Zwo+IAo+IEFORAo+IAo+IGh0dHA6Ly9wYXN0aWUub3JnL3Bh
c3Rlcy8xMDIxMDk3NS90ZXh0P2tleT1ya2lsanNkYXVjcms3ZnJwcnpncXEKPiAKPiBJIGhhdmUg
b25seSBzZWVuIHRoZXNlIHdoZW4gcnVubmluZyBpbiBhIFZNLiBXZSBoYXZlIHJ1biBzZXZlcmFs
IHRlc3RzCj4gb24gcGh5c2ljYWwgc2VydmVyIGJ1dCBoYXZlIG5ldmVyIHNlZW4gdGhlc2UgcHJv
YmxlbXMuCj4gCj4gQXJlIHRoZXJlIGFueSBrbm93biBpc3N1ZXMgd2l0aCBYRlMgcnVubmluZyBv
biBWTXM/Cj4gCj4gVGhhbmtzIGluIGFkdmFuY2UuCj4gLVNocmkKPiAKPiBfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+IHhmcyBtYWlsaW5nIGxpc3QKPiB4
ZnNAb3NzLnNnaS5jb20KPiBodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
PiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
