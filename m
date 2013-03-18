Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBA2F7F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 15:50:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A79E2304066
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:50:37 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id RLsxrCDxYHyoxgmX for
	<xfs@oss.sgi.com>; Mon, 18 Mar 2013 13:50:36 -0700 (PDT)
Received: from merkaba.localnet (ppp-93-104-149-127.dynamic.mnet-online.de
	[93.104.149.127])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id AC556C5
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 21:50:05 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Xfs_repair and journalling
Date: Mon, 18 Mar 2013 21:50:34 +0100
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
	(sfid-20130317_135417_509279_45FA64F6)
In-Reply-To: <CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201303182150.34665.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

QW0gU29ubnRhZywgMTcuIE3DpHJ6IDIwMTMgc2NocmllYiBTdWJyYW5zaHUgUGF0ZWw6Cj4gSW4g
Y2FzZSBvZiBFWFQ0LCBqb3VybmFsIHdpbGwgbm90IGJlIHJlcGxheWVkIG9uIHBlcmZvcm1pbmcg
bW91bnQuIE9uZQo+IG5lZWQgdG8gaW52b2tlIGZzY2sgd2hpY2ggcGVyZm9ybXMgam91cm5hbCBw
bGF5YmFjayBhbmQgdGhlbiBvdGhlcgo+IGNvcnJ1cHRpb24gY2hlY2tzL3JlY292ZXJ5Lgo+IENv
cnJlY3QgbWUgaWYgSSBhbSB3cm9uZy4KClVTQiBzdGljayB3aXRoIEV4dDQgd2l0aG91dCBhbnkg
bWtmcyBvcHRpb25zOgoKbWVya2FiYTp+PiBtb3VudCAvZGV2L3NkYiAvbW50L3plaXQgICAKbWVy
a2FiYTp+PiByc3luYyAtYSAvZXRjIC9tbnQvemVpdCAgICAKCih3YXMgdG8gc2hvcnQpCgptZXJr
YWJhOn4+IHJzeW5jIC1hIC91c3IvYmluIC9tbnQvemVpdAoKVW5wbHVnIGR1cmluZyB3cml0ZSBh
Y3Rpdml0eToKCgoKbWVya2FiYTp+PiBncmVwICJqb3VybmFsIiAvdmFyL2xvZy9zeXNsb2cgfCB0
YWlsIC01IApNYXIgMTggMjE6NDM6MjIgbWVya2FiYSBrZXJuZWw6IFsyOTkzOC4wMzgyOThdIGpv
dXJuYWwgY29tbWl0IEkvTyBlcnJvcgpNYXIgMTggMjE6NDM6MjIgbWVya2FiYSBrZXJuZWw6IFsy
OTkzOC4wMzgzMDBdIGpvdXJuYWwgY29tbWl0IEkvTyBlcnJvcgpNYXIgMTggMjE6NDM6MjIgbWVy
a2FiYSBrZXJuZWw6IFsyOTkzOC4wMzgzMDJdIGpvdXJuYWwgY29tbWl0IEkvTyBlcnJvcgpNYXIg
MTggMjE6NDM6MjIgbWVya2FiYSBrZXJuZWw6IFsyOTkzOC4wMzgzMDVdIGpvdXJuYWwgY29tbWl0
IEkvTyBlcnJvcgpNYXIgMTggMjE6NDM6MjIgbWVya2FiYSBrZXJuZWw6IFsyOTkzOC4wMzgzMDhd
IGpvdXJuYWwgY29tbWl0IEkvTyBlcnJvcgptZXJrYWJhOn4+IGdyZXAgLWMgImpvdXJuYWwgY29t
bWl0IiAvdmFyL2xvZy9zeXNsb2cKMTkxNQoKCldhaXQgdGlsbCBLREUgU0Mgc3RvcHMgcmVwbGF5
aW5nIHRoZXNlIG5vdGlmaWNhdGlvbnMgYW5kIHRoZW4gcmVzdGFydCAKcGxhc21hLWRlc2t0b3Ag
dG8gZ2V0IHJpZCBvZiBpdCBjYXVzZSB0aGF0IHRha2VzIHRvIGxvbmcuCgoKUGx1ZyBVU0Igc3Rp
Y2sgYmFjayBpbi4gQW5kIG1vdW50IGl0OgoKbWVya2FiYTp+PiBtb3VudCAvZGV2L3NkYyAvbW50
L3plaXQgCm1lcmthYmE6fj4gbHMgLWwgL21udC96ZWl0Cmluc2dlc2FtdCA0MApkcnd4ci14ci14
ICAgMiByb290IHJvb3QgMTIyODggTcOkciAxOCAyMTo0MyBiaW4KZHJ3eHIteHIteCAxODggcm9v
dCByb290IDEyMjg4IE3DpHIgMTggMTM6MzEgZXRjCmRyd3gtLS0tLS0gICAyIHJvb3Qgcm9vdCAx
NjM4NCBNw6RyIDE4IDIxOjQyIGxvc3QrZm91bmQKCgpNb3VudCB0b29rIGFib3V0IDUgc2Vjb25k
cy4KCgptZXJrYWJhOn4+IGRtZXNnIHwgdGFpbCAtMgpbMzAyMTcuNjAxODk2XSBFWFQ0LWZzIChz
ZGMpOiByZWNvdmVyeSBjb21wbGV0ZQpbMzAyMTcuNjAzMjg3XSBFWFQ0LWZzIChzZGMpOiBtb3Vu
dGVkIGZpbGVzeXN0ZW0gd2l0aCBvcmRlcmVkIGRhdGEgbW9kZS4gCk9wdHM6IChudWxsKQoKClNv
IGNhbiB3ZSBnZXQgb3ZlciBhbnkgZ3Vlc3Mgd29yayB0aGF0IEV4dDQgbWlnaHQgbm90IGJlIGFi
bGUgdG8gcmVwbGF5Cml0cyBqb3VybmFsIGFmdGVyIGFuIHVuY2xlYW4gc2h1dGRvd24/CgpJdCBj
YW4gYW5kIGl0IGRvZXMuIEFuZCBub3QganVzdCBzaW5jZSB0aGlzIDMuOS1yYzMga2VybmVsLgoK
VGhhbmtzLAotLSAKTWFydGluICdIZWxpb3MnIFN0ZWlnZXJ3YWxkIC0gaHR0cDovL3d3dy5MaWNo
dHZvbGwuZGUKR1BHOiAwM0IwIDBENkMgMDA0MCAwNzEwIDRBRkEgIEI4MkYgOTkxQiBFQUFDIEE1
OTkgODRDNwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
eGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxt
YW4vbGlzdGluZm8veGZzCg==
