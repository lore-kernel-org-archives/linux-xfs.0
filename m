Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n42IZIlM065973 for <xfs@oss.sgi.com>; Sat, 2 May 2009 13:35:19 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E3AB146AB0E
	for <xfs@oss.sgi.com>; Sat,  2 May 2009 11:39:01 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	ceXBPIeYPltJfLWS for <xfs@oss.sgi.com>;
	Sat, 02 May 2009 11:39:01 -0700 (PDT)
Received: by fxm25 with SMTP id 25so2848105fxm.20
	for <xfs@oss.sgi.com>; Sat, 02 May 2009 11:35:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090502101405.GA6145@fancy-poultry.org>
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<20090502101405.GA6145@fancy-poultry.org>
Date: Sat, 2 May 2009 22:35:17 +0400
Message-ID: <a4423d670905021135s4fdbea82t20cf75b61c59dc75@mail.gmail.com>
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
To: linux-kernel@vger.kernel.org, Heinz Diehl <htd@fancy-poultry.org>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

MjAwOS81LzIgSGVpbnogRGllaGwgPGh0ZEBmYW5jeS1wb3VsdHJ5Lm9yZz46Cj4gT24gMDEuMDUu
MjAwOSwgQWxleGFuZGVyIEJlcmVnYWxvdiB3cm90ZToKPgo+PiAjIHhmc19kYiAtciAvZGV2L3Nk
YzEKPj4geGZzX2RiPiBmcmFnCj4+IGFjdHVhbCAyMzgwNSwgaWRlYWwgMjI4OTAsIGZyYWdtZW50
YXRpb24gZmFjdG9yIDMuODQlCj4+ICMgeGZzX2ZzciAtdiAvZGV2L3NkYzEKPj4gL21udC9jIHN0
YXJ0IGlub2RlPTAKPj4gaW5vPTE1OAo+PiBleHRlbnRzIGJlZm9yZTozIGFmdGVyOjEgRE9ORSBp
bm89MTU4Cj4+Cj4+IMKgdGhlbiBpdCBoYW5ncwo+Cj4gSSBjYW4ndCBjb25maXJtIHRoaXMgaGVy
ZSBvbiBteSBzeXN0ZW1zOgo+Cj4gbGllc2VsOn4gIyB1bmFtZSAtYQo+IExpbnV4IGxpZXNlbCAy
LjYuMzAtcmM0ICMxIFNNUCBQUkVFTVBUIFNhdCBNYXkgMiAxMTo0OToxMyBDRVNUIDIwMDkgeDg2
XzY0IHg4Nl82NCB4ODZfNjQgR05VL0xpbnV4CgpJIGhhdmUgdGhpcyBwcm9ibGVtIG9uIHR3byB4
ODZfMzIgaG9zdHMuCkl0IHJ1bnMgZm9yIGFib3V0IGEgbWludXRlIGFuZCB0aGVuIGhhbmdzLgp2
bXN0YXQgMToKIDAgIDEgICAgIDgwICAzMDg1NiAgMTIyODQgMTI4OTQ1MiAgICAwICAgIDAgMTYz
ODQgMTYzODAgIDIyNCAgMzAxICAwICA1ICAwIDk1CiAwICAxICAgICA4MCAgMzIwMjAgIDEyMTk2
IDEyODc4ODQgICAgMCAgICAwIDI1OTg0IDE2MzgwICAyOTAgIDQ3MCAgMCAxMSAgMCA4OQogMCAg
MSAgICAgODAgIDMwNzMyICAxMjEzMiAxMjg5NjQ4ICAgIDAgICAgMCAyMzE2OCAzMjc2MCAgMjg2
ICA0MTMgIDAgIDYgIDAgOTQKIDAgIDEgICAgIDgwICAzMjIyMCAgMTIxMjggMTI4NzYyMCAgICAw
ICAgIDAgMTYzODQgMTYzODAgIDIyMCAgMzAzICAwICA4ICAwIDkyCiAxICAwICAgICA4MCAxOTgz
MTIgIDEyMTA4IDExMzc5NTYgICAgMCAgICAwIDE0NDcyIDE0NjI4ICAyMjMgIDI4NCAgMCAxMCAg
MyA4NwogMCAgMCAgICAgODAgMTExODE0NCAgMTIxMDggMjE4MjE2ICAgIDAgICAgMCAgICAgMCAg
ICAgMCAgIDYzICAgMzMgIDAgMzggNjIgIDAKIDAgIDAgICAgIDgwIDExMTgxNDQgIDEyMTA4IDIx
ODIxNiAgICAwICAgIDAgICAgIDAgICAgIDAgICAyNCAgIDI2ICAwICAwIDEwMCAgMAogMCAgMCAg
ICAgODAgMTExODE0NCAgMTIxMDggMjE4MjE2ICAgIDAgICAgMCAgICAgMCAgICAgMCAgIDM2ICAg
MjggIDAgIDEgOTkgIDAKIDAgIDAgICAgIDgwIDExMTgxNDQgIDEyMTA4IDIxODIxNiAgICAwICAg
IDAgICAgIDAgICAgIDAgICAzNiAgIDMyICAxICAxIDk4ICAwCiAwICAwICAgICA4MCAxMTE4MTQ0
ICAxMjEwOCAyMTgyMTYgICAgMCAgICAwICAgICAwICAgICAwICAgNzggICA2NiAgMCAgMSA5OSAg
MAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
