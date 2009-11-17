Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAHMAqAI078998 for <xfs@oss.sgi.com>; Tue, 17 Nov 2009 16:10:52 -0600
Date: Wed, 18 Nov 2009 09:11:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: Don't use PF_MEMALLOC
Message-ID: <20091117221108.GK9467@discord.disaster>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
	<20091117162235.3DEB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091117162235.3DEB.A69D9226@jp.fujitsu.com>
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
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

T24gVHVlLCBOb3YgMTcsIDIwMDkgYXQgMDQ6MjM6NDNQTSArMDkwMCwgS09TQUtJIE1vdG9oaXJv
IHdyb3RlOgo+IAo+IE5vbiBNTSBzdWJzeXN0ZW0gbXVzdCBub3QgdXNlIFBGX01FTUFMTE9DLiBN
ZW1vcnkgcmVjbGFpbSBuZWVkIGZldwo+IG1lbW9yeSwgYW55b25lIG11c3Qgbm90IHByZXZlbnQg
aXQuIE90aGVyd2lzZSB0aGUgc3lzdGVtIGNhdXNlCj4gbXlzdGVyaW91cyBoYW5nLXVwIGFuZC9v
ciBPT00gS2lsbGVyIGludm9rYXRpb24uCgpUaGUgeGZzYnVmZCBpcyBhIHdva2VuIHJ1biBieSBh
IHJlZ2lzdGVyZWQgbWVtb3J5IHNoYWtlci4gaS5lLiBpdApydW5zIHdoZW4gdGhlIHN5c3RlbSBu
ZWVkcyB0byByZWNsYWltIG1lbW9yeS4gSXQgZm9yY2XRlSB0aGUKZGVsYXllZCB3cml0ZSBtZXRh
ZGF0YSBidWZmZXJzIChvZiB3aGljaCB0aGVyZSBjYW4gYmUgYSBsb3QpIHRvIGRpc2sKc28gdGhh
dCB0aGV5IGNhbiBiZSByZWNsYWltZWQgb24gSU8gY29tcGxldGlvbi4gVGhpcyBJTyBzdWJtaXNz
aW9uCm1heSByZXF1aXJlINGVb21lIG1lbW9yeSB0byBiZSBhbGxvY2F0ZWQgdG8gYmUgYWJsZSB0
byBmcmVlIHRoYXQKbWVtb3J5LgoKSGVuY2UsIEFGQUlDVCB0aGUgdXNlIG9mIFBGX01FTUFMTE9D
IGlzIHZhbGlkIGhlcmUuCgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZy
b21vcmJpdC5jb20KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
