Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q399NO6u079308 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 04:23:24 -0500
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	h3oYkSyZRtDRdIRC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Apr 2012 02:23:22 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so2536948ghb.26
	for <xfs@oss.sgi.com>; Mon, 09 Apr 2012 02:23:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F82063F.4070609@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
	<4F8074EC.2030108@gmail.com> <4F82063F.4070609@hardwarefreak.com>
Date: Mon, 9 Apr 2012 11:23:22 +0200
Message-ID: <CAAxjCEyzmbuynT4C=wkL9Dryz1LN95soKgR4cDrZ81c3=8d24g@mail.gmail.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

PiBPciBtZXJlbHkgYSB3ZWFrL29sZCBwcm9kdWN0LiDCoFRoZSBQNDAwIHdhcyBhbiBlbnRyeSBs
ZXZlbCBSQUlEIEhCQSwKPiBIUCdzIGZpcnN0IFBDSWUvU0FTIFJBSUQgY2FyZC4gwqBJdCB3YXMg
ZGlzY29udGludWVkIHF1aXRlIHNvbWUgdGltZSBhZ28uCj4gwqBUaGUgdXNlIG9mIEREUjIvNTMz
IG1lbW9yeSBpbmRpY2F0ZXMgaXQncyBkZXNpZ24gc3RhZ2Ugc3RhcnRlZCBwcm9iYWJseQo+IHNv
bWV3aGVyZSBhcm91bmQgMjAwNCwgOCB5ZWFycyBhZ28uCgpJdCB3YXMgd2hhdCB5b3UgZ290IHdo
ZW4geW91IGJvdWdodCBhIGRpcmVjdC1hdHRhY2ggc3RvcmFnZSBibGFkZSBmcm9tCkhQIHVudGls
IGEgZmV3IG1vbnRocyBhZ28uIEFwcGFyZW50bHksIHRoZXkgY2hhbmdlZCBpdCB0byBQNDEwaSB2
ZXJ5CnJlY2VudGx5OiA8aHR0cDovL2gxMDAxMC53d3cxLmhwLmNvbS93d3BjL3VzL2VuL3NtL1dG
MDZhLzM3MDk5NDUtMzcwOTk0NS0zNzEwMTE0LTM3MjI4MjAtMzcyMjc3Ni00MzA0OTQyLmh0bWw/
ZG5yPTE+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
