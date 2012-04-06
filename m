Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q368OTw1154376 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 03:24:29 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id fYsaXIJWsYDLqhYJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Apr 2012 01:24:28 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so1593924yhj.26
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 01:24:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAxjCEz6=n3XWML7WtAOAE2KfCTR=LZi78B=dbSP4h0MngK1hA@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<8544B101-3848-428A-BB7E-C91CE897163B@filmlight.ltd.uk>
	<CAAxjCEz6=n3XWML7WtAOAE2KfCTR=LZi78B=dbSP4h0MngK1hA@mail.gmail.com>
Date: Fri, 6 Apr 2012 10:24:27 +0200
Message-ID: <CAAxjCEw0HWzw+q+TE+UbkCgC5iQX_=WEkFteO6iQQv9X5ipNfw@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

T24gRnJpLCBBcHIgNiwgMjAxMiBhdCA5OjExIEFNLCBTdGVmYW4gUmluZyA8c3RlZmFucmluQGdt
YWlsLmNvbT4gd3JvdGU6Cj4gT24gRnJpLCBBcHIgNiwgMjAxMiBhdCAxMjozMiBBTSwgUm9nZXIg
V2lsbGNvY2tzIDxyb2dlckBmaWxtbGlnaHQubHRkLnVrPiB3cm90ZToKPj4gaHR0cDovL3hmcy5v
cmcvZG9jcy94ZnNkb2NzLXhtbC1kZXYvWEZTX1VzZXJfR3VpZGUvdG1wL2VuLVVTL2h0bWwvY2gw
NnMxMC5odG1sCj4KPiBUaGlzIHNvdW5kcyBsaWtlIGl0IGNvdWxkIGhlbHAgdmVyeSBtdWNoLiBJ
J2xsIHRyeSB0aGF0LiBUaGFua3MhCgpVbmZvcnR1bmF0ZWx5LCB0aGUgZG9jdW1lbnRhdGlvbiBz
YXlzIGl04oCZcyBvbmx5IGVmZmVjdGl2ZSBmb3IKZmlsZXN5c3RlbXMgPiAxVEIsIHdoaWNoIG1p
bmUgaXNu4oCZdC4gSSB0cmllZCBpdCwgYW5kIGl0IGRvZXNu4oCZdCBtYWtlIGEKZGlmZmVyZW5j
ZSwgd2hpY2ggaXMgdG8gYmUgZXhwZWN0ZWQuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
