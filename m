Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n42IxXqJ066629 for <xfs@oss.sgi.com>; Sat, 2 May 2009 13:59:34 -0500
Received: from mail-bw0-f226.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FEA3146ACF7
	for <xfs@oss.sgi.com>; Sat,  2 May 2009 12:03:16 -0700 (PDT)
Received: from mail-bw0-f226.google.com (mail-bw0-f226.google.com
	[209.85.218.226]) by cuda.sgi.com with ESMTP id
	YBA2BQhshuvCasiX for <xfs@oss.sgi.com>;
	Sat, 02 May 2009 12:03:16 -0700 (PDT)
Received: by bwz26 with SMTP id 26so2830858bwz.20
	for <xfs@oss.sgi.com>; Sat, 02 May 2009 11:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49FC9762.6010109@sandeen.net>
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<20090502101405.GA6145@fancy-poultry.org>
	<a4423d670905021135s4fdbea82t20cf75b61c59dc75@mail.gmail.com>
	<49FC9762.6010109@sandeen.net>
Date: Sat, 2 May 2009 22:59:33 +0400
Message-ID: <a4423d670905021159k51e91b12h96189005980b5e73@mail.gmail.com>
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
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
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, linux-kernel@vger.kernel.org, Heinz Diehl <htd@fancy-poultry.org>, xfs@oss.sgi.com

MjAwOS81LzIgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PjoKPiBBbGV4YW5kZXIg
QmVyZWdhbG92IHdyb3RlOgo+PiAyMDA5LzUvMiBIZWlueiBEaWVobCA8aHRkQGZhbmN5LXBvdWx0
cnkub3JnPjoKPj4+IE9uIDAxLjA1LjIwMDksIEFsZXhhbmRlciBCZXJlZ2Fsb3Ygd3JvdGU6Cj4+
Pgo+Pj4+ICMgeGZzX2RiIC1yIC9kZXYvc2RjMQo+Pj4+IHhmc19kYj4gZnJhZwo+Pj4+IGFjdHVh
bCAyMzgwNSwgaWRlYWwgMjI4OTAsIGZyYWdtZW50YXRpb24gZmFjdG9yIDMuODQlCj4+Pj4gIyB4
ZnNfZnNyIC12IC9kZXYvc2RjMQo+Pj4+IC9tbnQvYyBzdGFydCBpbm9kZT0wCj4+Pj4gaW5vPTE1
OAo+Pj4+IGV4dGVudHMgYmVmb3JlOjMgYWZ0ZXI6MSBET05FIGlubz0xNTgKPj4+Pgo+Pj4+IMKg
dGhlbiBpdCBoYW5ncwo+Pj4gSSBjYW4ndCBjb25maXJtIHRoaXMgaGVyZSBvbiBteSBzeXN0ZW1z
Ogo+Pj4KPj4+IGxpZXNlbDp+ICMgdW5hbWUgLWEKPj4+IExpbnV4IGxpZXNlbCAyLjYuMzAtcmM0
ICMxIFNNUCBQUkVFTVBUIFNhdCBNYXkgMiAxMTo0OToxMyBDRVNUIDIwMDkgeDg2XzY0IHg4Nl82
NCB4ODZfNjQgR05VL0xpbnV4Cj4+Cj4+IEkgaGF2ZSB0aGlzIHByb2JsZW0gb24gdHdvIHg4Nl8z
MiBob3N0cy4KPj4gSXQgcnVucyBmb3IgYWJvdXQgYSBtaW51dGUgYW5kIHRoZW4gaGFuZ3MuCj4K
PiBlY2hvIHcgPiAvcHJvYy9zeXNycS10cmlnZ2VyCj4gZG1lc2cKPgo+IHdvdWxkIHNob3cgYWxs
IHRoZSBzbGVlcGluZyBwcm9jZXNzZXMuLi4KSXQgaXMgdGhlIHNhbWUgYXMgSSBwb3N0ZWQgYWxy
ZWFkeToKClN5c1JxIDogU2hvdyBCbG9ja2VkIFN0YXRlCiAgdGFzayAgICAgICAgICAgICAgICBQ
QyBzdGFjayAgIHBpZCBmYXRoZXIKeGZzX2ZzciAgICAgICBEIDAwMDAwMDAwICA1MzA0ICAzMzkz
ICAgICAgMQogZWY0NzlkZWMgMDAwMDAwNDYgMDAwMDAwMDEgMDAwMDAwMDAgZWY0NzlkZTggZjJh
NTgwMDAgZjJhNTgyODAgZjMxMjM4MzAKIGYyYTU4MDAwIDAwMDAwMDAxIGYzMTIzODMwIGYzMTIz
ODJjIGZmZmZmZmZmIGYzMTIzODJjIGYyYTU4MDAwIGVmNDc5ZGY0CiBjMDQ0Nzg5MiBlZjQ3OWUy
MCBjMDQ0OThhZCBlZjQ3OWUyOCBmMzEyMzgzMCBmMzEyMzg1NCBlZjQ3OWU0NCAwMDAwMDI0NgpD
YWxsIFRyYWNlOgogWzxjMDQ0Nzg5Mj5dIHNjaGVkdWxlKzB4MTIvMHgzMAogWzxjMDQ0OThhZD5d
IHJ3c2VtX2Rvd25fZmFpbGVkX2NvbW1vbisweDZkLzB4MTgwCiBbPGMwNDQ5OWRkPl0gcndzZW1f
ZG93bl93cml0ZV9mYWlsZWQrMHgxZC8weDMwCiBbPGMwNDQ5YTJhPl0gY2FsbF9yd3NlbV9kb3du
X3dyaXRlX2ZhaWxlZCsweDYvMHg4CiBbPGMwMjZiZmNlPl0gPyB4ZnNfaWxvY2srMHhlZS8weDEw
MAogWzxjMDEzZmNkNj5dID8gZG93bl93cml0ZV9uZXN0ZWQrMHg3Ni8weDkwCiBbPGMwMjZiZmNl
Pl0gPyB4ZnNfaWxvY2srMHhlZS8weDEwMAogWzxjMDI2YmZjZT5dIHhmc19pbG9jaysweGVlLzB4
MTAwCiBbPGMwMjkwZmI0Pl0geGZzX2luYWN0aXZlKzB4MzM0LzB4NTQwCiBbPGMwMWIzODJiPl0g
PyBpbm90aWZ5X2lub2RlX2lzX2RlYWQrMHgxYi8weDgwCiBbPGMwMjlkNGVmPl0geGZzX2ZzX2Ns
ZWFyX2lub2RlKzB4MWYvMHgzMAogWzxjMDE5YjdiYj5dIGNsZWFyX2lub2RlKzB4OGIvMHgxMTAK
IFs8YzAxOWJmMDY+XSBnZW5lcmljX2RlbGV0ZV9pbm9kZSsweGU2LzB4MTIwCiBbPGMwNDQ5ZDg2
Pl0gPyBfc3Bpbl9sb2NrKzB4NjYvMHg3MAogWzxjMDE5YzA5Zj5dIGdlbmVyaWNfZHJvcF9pbm9k
ZSsweDE1Zi8weDIzMAogWzxjMDJjMDk1OD5dID8gX2F0b21pY19kZWNfYW5kX2xvY2srMHgxOC8w
eDQwCiBbPGMwMTliNDc3Pl0gaXB1dCsweDQ3LzB4NTAKIFs8YzAxOThhNGY+XSBkZW50cnlfaXB1
dCsweDZmLzB4YzAKIFs8YzAxOThiNzQ+XSBkX2tpbGwrMHgyNC8weDUwCiBbPGMwMTlhMDNiPl0g
ZHB1dCsweDViLzB4MTIwCiBbPGMwMThhODkyPl0gX19mcHV0KzB4MTYyLzB4MjQwCiBbPGMwMThh
OThmPl0gZnB1dCsweDFmLzB4MzAKIFs8YzAxODczZjc+XSBmaWxwX2Nsb3NlKzB4NDcvMHg3MAog
WzxjMDE4NzQ4Yz5dIHN5c19jbG9zZSsweDZjLzB4ZDAKIFs8YzAxMDJlNDg+XSBzeXNlbnRlcl9k
b19jYWxsKzB4MTIvMHgzNgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
