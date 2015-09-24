Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 864537F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 17:41:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 13A02AC002
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 15:41:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xmbfoDGvlvuN6u1E for <xfs@oss.sgi.com>;
	Thu, 24 Sep 2015 15:41:39 -0700 (PDT)
Date: Fri, 25 Sep 2015 08:41:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/14] xfsprogs: prefix XATTR_LIST_MAX with XFS_
Message-ID: <20150924224136.GU19114@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-5-git-send-email-jtulak@redhat.com>
	<20150923031532.GN3902@dastard>
	<CACj3i715Tiy0prfeYgLfEfupe8aGxJuv5yvDOi+AE08ofueO_A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i715Tiy0prfeYgLfEfupe8aGxJuv5yvDOi+AE08ofueO_A@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

T24gVGh1LCBTZXAgMjQsIDIwMTUgYXQgMTA6Mjg6MDVBTSArMDIwMCwgSmFuIFR1bGFrIHdyb3Rl
Ogo+IE9uIFdlZCwgU2VwIDIzLCAyMDE1IGF0IDU6MTUgQU0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gPiBXaWxsIHdvcmsgb24gYm90aCB0aGUga2VybmVsIGFu
ZCB1c2Vyc3BhY2Ugc2lkZS4gVGhpcyB3aWxsIGFsc28gbmVlZAo+ID4gYSBrZXJuZWwgc2lkZSBw
YXRjaC4uLgo+IAo+IAo+IOKAi05vdywgdGhpcyBpcyBzb21ldGhpbmcgd2hlcmUgSSBtYXkgbmVl
ZCBhIGJpdCBoZWxwL2NvbmZpcm1hdGlvbiwgSSBndWVzcy7igIsKPiBXaGF0IEkgc3VwcG9zZSBJ
IHNob3VsZCBkbyBpczoKPiAKPiAxKSBDbG9uZSBsaW51eC14ZnMgKGdpdDovLwo+IGdpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kZ2MvbGludXgteGZzLmdpdCkKPiAyKSBF
ZGl0IGxpbnV4LXhmcy9mcy94ZnMvbGlieGZzL3hmc19mcy5oIGFuZCBhZGQgdGhlIHNhbWUgY2hh
bmdlIHRoZXJlCgphbmQgdG8gdGhlIGZpbGVzIGluIGZzL3hmcyB0aGF0IGRpcmVjdGx5IHVzZSBY
QVRUUl9MSVNUX01BWC4KCjIuNSkgY29tcGlsZSwgaW5zdGFsbCBrZXJuZWwsIHJ1biB4ZnN0ZXN0
cy4KCj4gMykgU2VuZCBpdCB0byB0aGlzIG1haWxpbmcgbGlzdCBhcyB1c3VhbCwgd2l0aCAiW1BB
VENIXSB4ZnM6IC4uLiIKPgo+IChUaGUgc2FtZSBnb2VzIGZvciB0aGUgb3RoZXIgcGF0Y2ggd2l0
aCB0aGUga2VybmVsIG5lZWQgdG9vLikKPiAKPiBJcyBpdCBhbGwgcmlnaHQ/IENvcnJlY3QgcmVw
b3NpdG9yeSBVUkw/IDotKQoKWXVwLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpk
YXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
