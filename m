Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1B807F67
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 10:12:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E627304053
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 08:12:16 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id aG2al8aZRvehd0Td (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 08:12:14 -0700 (PDT)
Date: Mon, 8 Jun 2015 17:12:17 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: High %sy cpu usage , server is very slow
Message-ID: <20150608171217.4de40371@harpe.intellique.com>
In-Reply-To: <7ba971dae36a523e9cb2c2b115345d0a@mail.linuz.in>
References: <7ba971dae36a523e9cb2c2b115345d0a@mail.linuz.in>
MIME-Version: 1.0
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
To: Aravind M D <aravind@linuz.in>
Cc: xfs@oss.sgi.com

TGUgTW9uLCAwOCBKdW4gMjAxNSAxMTozMzoyMSArMDUzMApBcmF2aW5kIE0gRCA8YXJhdmluZEBs
aW51ei5pbj4gw6ljcml2YWl0OgoKPiBvbmUgb2YgdGhlIGluc3RhbmNlIHdoZW4gdGhlcmUgaXMg
aGlnaCAlc3kgdXNhZ2UgCj4gCj4gYXZnLWNwdTogJXVzZXIgJW5pY2UgJXN5c3RlbSAlaW93YWl0
ICVzdGVhbCAlaWRsZSAKPiAKPiAgMC4wMSAwLjAwIDQ4LjI2IDAuMDEgMC4wMCA1MS43Mwo+IAo+
IERldmljZToKPiBycnFtL3Mgd3JxbS9zIHIvcyB3L3MgcmtCL3Mgd2tCL3MgYXZncnEtc3ogYXZn
cXUtc3ogYXdhaXQgc3ZjdG0KPiAldXRpbAo+IGNjaXNzL2MwZDAgMC4wMCAxNi45OSAwLjAwIDgu
MzYgMC4wMCA0MTQuOTAgOTkuMzAgMC43NyA5Mi41NyA0Ni4zMAo+IDM4LjY5Cj4gY2Npc3MvYzBk
MHAxIDAuMDAgMC4wMCAwLjAwIDAuMDAgMC4wMCAwLjAwIDAuMDAgMC4wMCAwLjAwIDAuMDAKPiAw
LjAwCj4gY2Npc3MvYzBkMHAyIDAuMDAgMC4wMCAwLjAwIDYuMTMgMC4wMCAzMzguMDIgMTEwLjMy
IDAuNzcgMTI2LjE4Cj4gNjMuMDkgMzguNjYKCklmIHhmcyB3YXMgdGhlIGN1bHByaXQsIHlvdSdk
IHByb2JhYmx5IGZpbmQgaGlnaCAiaW93YWl0IiBlbnRyaWVzLgpIZXJlIHRoZSBkaXNrcyBkb24n
dCBhcHBlYXIgdG8gYmUgb3ZlcmxvYWRlZCwgc28gSSdkIGJldCB4ZnMgaGFzCm5vdGhpbmcgdG8g
ZG8gd2l0aCB5b3VyIHByb2JsZW0uCgotLSAKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkVtbWFudWVsIEZsb3Jh
YyAgICAgfCAgIERpcmVjdGlvbiB0ZWNobmlxdWUKICAgICAgICAgICAgICAgICAgICB8ICAgSW50
ZWxsaXF1ZQogICAgICAgICAgICAgICAgICAgIHwJPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+CiAg
ICAgICAgICAgICAgICAgICAgfCAgICszMyAxIDc4IDk0IDg0IDAyCi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxp
bmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGlu
Zm8veGZzCg==
