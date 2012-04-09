Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39CrGH8124008 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 07:53:16 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 5DzVi83XR2oeJKzD
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Apr 2012 05:53:15 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so2597300yhj.26
	for <xfs@oss.sgi.com>; Mon, 09 Apr 2012 05:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120409144847.117b42b5@galadriel.home>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
	<4F8055E4.1000808@hardwarefreak.com>
	<CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
	<20120409144847.117b42b5@galadriel.home>
Date: Mon, 9 Apr 2012 14:53:14 +0200
Message-ID: <CAAxjCEzKtQ+7yrQf1x-wyTMjp1tS1Vy6Rei2xLwTbBzOhEZ6YA@mail.gmail.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: stan@hardwarefreak.com, Linux fs XFS <xfs@oss.sgi.com>

Pj4gU28gMTUwIE1CL3NlYyBzZWVtcyB0byBiZSB0aGUKPj4gYmVzdCB0aGVzZSBkaXNrcyBjYW4g
ZG8sCj4KPiBEZWZpbml0ZWx5IE5PVCByaWdodC4gSSBtZWFuIEkndmUgZ290IHJvdXRpbmVseSA2
MDAgTUIvcyBmcm9tIDggNy4ySwo+IGRyaXZlcyBSQUlELTYgYXJyYXlzLiBVbmxlc3MgY2FjaGUg
aXMgb2ZmLCB3aGljaCBSQUlELTYgaXNuJ3Qgb2J2aW91c2x5Cj4gdGhvdWdodCBmb3IuCgpJbiB0
aGlzIGNhc2UgaXQgd2FzIGEgMi1kaXNrIFJBSUQgMSwgc28gaXTigJlzIDE1MCBNQi9zIHBlciBk
aXNrLiBTZWVtcwpxdWl0ZSByaWdodCB0byBtZS4KCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
