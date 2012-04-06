Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q367RL8j141888 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 02:27:21 -0500
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	lRWA4yq4sIsux1Bk (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Apr 2012 00:27:20 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so1572436ghb.26
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 00:27:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20350.13616.901974.523140@tree.ty.sabi.co.UK>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 09:27:19 +0200
Message-ID: <CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

PiBBcyB0byB0aGlzLCBpbiB0aGVvcnkgZXZlbiBoYXZpbmcgc3BsaXQgdGhlIGZpbGVzIGFtb25n
IDQgQUdzLAo+IHRoZSB1cGxvYWQgZnJvbSBzeXN0ZW0gUkFNIHRvIGhvc3QgYWRhcHRlciBSQU0g
YW5kIHRoZW4gdG8gZGlzawo+IGNvdWxkIGhhcHBlbiBieSB3cml0aW5nIGZpcnN0IGFsbCB0aGUg
ZGlydHkgYmxvY2tzIGZvciBvbmUgQUcsCj4gdGhlbiBhIGxvbmcgc2VlayB0byB0aGUgbmV4dCBB
RywgYW5kIHNvIG9uLCBhbmQgdGhlIGFkZGl0aW9uYWwKPiBjb3N0IG9mIDMgbG9uZyBzZWVrcyB3
b3VsZCBiZSBuZWdsaWdpYmxlLgoKWWVzLCB0aGF04oCZcyBleGFjdGx5IHdoYXQgSSBoYWQgaW4g
bWluZCwgYW5kIHdoYXQgcHJvbXB0ZWQgbWUgdG8gd3JpdGUKdGhpcyBwb3N0LiBJdCB3b3VsZCBi
ZSBhYm91dCAxMCB0aW1lcyBhcyBmYXN0LiBUaGF04oCZcyB3aGF0IGJvdGhlcnMgbWUKc28gbXVj
aC4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
