Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E2487F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 19:03:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 110938F8096
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 17:03:50 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	EFqbp7wdXhjasLSb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 17:03:49 -0700 (PDT)
Received: by wizk4 with SMTP id k4so128740217wiz.1
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 17:03:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8BF495B8-F444-415A-B7BF-5E1961C75817@sandeen.net>
References: <CABppvi4FZKTsu22uk6nOSaShJOUyWg7cO6h-i4YekF4MLKH8RQ@mail.gmail.com>
	<8BF495B8-F444-415A-B7BF-5E1961C75817@sandeen.net>
Date: Wed, 27 May 2015 17:03:47 -0700
Message-ID: <CABppvi5ODWyjMw0pouAQ__SQ-aGb48PEyTCPU7Dt65Z1DhKmVA@mail.gmail.com>
Subject: Re: XFS crashes on VMs
From: Shrinand Javadekar <shrinand@maginatics.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

VGhhbmtzIEVyaWMsCgpXZSByYW4geGZzX3JlcGFpciBhbmQgd2VyZSBhYmxlIHRvIGdldCBpdCBi
YWNrIGludG8gYSBydW5uaW5nIHN0YXRlLgpUaGlzIGlzIGZpbmUgZm9yIGEgdGVzdCAmIGRldiBi
dXQgaW4gcHJvZHVjdGlvbiBpdCB3b24ndCBiZQphY2NlcHRhYmxlLiBXaGF0IG90aGVyIGRhdGEg
ZG8gd2UgbmVlZCB0byBnZXQgdG8gdGhlIGJvdHRvbSBvZiB0aGlzPwoKT24gV2VkLCBNYXkgMjcs
IDIwMTUgYXQgNDoyNyBQTSwgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PiB3cm90
ZToKPiBUaGF0J3Mgbm90IGEgY3Jhc2guIFRoYXQgaXMgeGZzIGRldGVjdGluZyBvbiBkaXNrIGNv
cnJ1cHRpb24gd2hpY2ggbGlrZWx5IGhhcHBlbmVkIGF0IHNvbWUgdGltZSBwcmlvci4gWW91IHNo
b3VsZCB1bm1vdW50IGFuZCBydW4geGZzX3JlcGFpciwgcG9zc2libHkgd2l0aCDigJNuIGZpcnN0
IGlmIHlvdSB3b3VsZCBsaWtlIHRvIGRvIGEgZHJ5IHJ1biB0byBzZWUgd2hhdCBpdCBtaWdodCBk
by4gIElmIHlvdSBnZXQgZnJlc2ggY29ycnVwdGlvbiBhZnRlciBhIGZ1bGwgcmVwYWlyLCB0aGVu
IHRoYXQgYmVjb21lcyBtb3JlIGludGVyZXN0aW5nLiBJdCdzIHBvc3NpYmxlIHRoYXQgeW91IGhh
dmUgYSBwcm9ibGVtIHdpdGggdGhlIHVuZGVybHlpbmcgYmxvY2sgbGF5ZXIgb3IgaXQncyBwb3Nz
aWJsZSB0aGF0IGl0IGlzIGFuIHhmcyBidWcgLSAgYnV0IEkgdGhpbmsgdGhpcyBpcyBub3Qgc29t
ZXRoaW5nIHRoYXQgd2UgaGF2ZSBzZWVuIGJlZm9yZS4KPgo+IEVyaWMKPgo+PiBPbiBNYXkgMjcs
IDIwMTUsIGF0IDY6MDYgUE0sIFNocmluYW5kIEphdmFkZWthciA8c2hyaW5hbmRAbWFnaW5hdGlj
cy5jb20+IHdyb3RlOgo+Pgo+PiBIaSwKPj4KPj4gSSBhbSBydW5uaW5nIE9wZW5zdGFjayBTd2lm
dCBpbiBhIFZNIHdpdGggWEZTIGFzIHRoZSB1bmRlcmx5aW5nCj4+IGZpbGVzeXN0ZW0uIFRoaXMg
aXMgZ2VuZXJhdGluZyBhIG1ldGFkYXRhIGhlYXZ5IHdvcmtsb2FkIG9uIFhGUy4KPj4gRXNzZW50
aWFsbHksIGl0IGlzIGNyZWF0aW5nIGEgbmV3IGRpcmVjdG9yeSBhbmQgYSBuZXcgZmlsZSAoMjU2
S0IpIGluCj4+IHRoYXQgZGlyZWN0b3J5LiBUaGlzIGZpbGUgaGFzIGV4dGVuZGVkIGF0dHJpYnV0
ZXMgb2Ygc2l6ZSAyNDMgYnl0ZXMuCj4+Cj4+IEkgYW0gc2VlaW5nIHRoZSBmb2xsb3dpbmcgdHdv
IGNyYXNoZXMgb2YgdGhlIG1hY2hpbmU6Cj4+Cj4+IGh0dHA6Ly9wYXN0aWUub3JnL3Bhc3Rlcy8x
MDIxMDk3NC90ZXh0P2tleT14ZG1mdmFvY3Zhd255Zm1rYjA2emcKPj4KPj4gQU5ECj4+Cj4+IGh0
dHA6Ly9wYXN0aWUub3JnL3Bhc3Rlcy8xMDIxMDk3NS90ZXh0P2tleT1ya2lsanNkYXVjcms3ZnJw
cnpncXEKPj4KPj4gSSBoYXZlIG9ubHkgc2VlbiB0aGVzZSB3aGVuIHJ1bm5pbmcgaW4gYSBWTS4g
V2UgaGF2ZSBydW4gc2V2ZXJhbCB0ZXN0cwo+PiBvbiBwaHlzaWNhbCBzZXJ2ZXIgYnV0IGhhdmUg
bmV2ZXIgc2VlbiB0aGVzZSBwcm9ibGVtcy4KPj4KPj4gQXJlIHRoZXJlIGFueSBrbm93biBpc3N1
ZXMgd2l0aCBYRlMgcnVubmluZyBvbiBWTXM/Cj4+Cj4+IFRoYW5rcyBpbiBhZHZhbmNlLgo+PiAt
U2hyaQo+Pgo+PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwo+PiB4ZnMgbWFpbGluZyBsaXN0Cj4+IHhmc0Bvc3Muc2dpLmNvbQo+PiBodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMKPj4KCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
