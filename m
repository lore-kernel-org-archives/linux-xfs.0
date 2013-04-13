Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 97E987F37
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 05:37:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64A938F809B
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 03:37:59 -0700 (PDT)
Received: from mail-pb0-f54.google.com (mail-pb0-f54.google.com
	[209.85.160.54]) by cuda.sgi.com with ESMTP id dHovgK9NOX7sW40f
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Apr 2013 03:37:55 -0700 (PDT)
Received: by mail-pb0-f54.google.com with SMTP id xa7so1805851pbc.13
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 03:37:55 -0700 (PDT)
Message-ID: <51693569.4030301@gmail.com>
Date: Sat, 13 Apr 2013 18:37:29 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: make install support common/ and tests/ dirs
References: <51678D0D.1070002@gmail.com> <20130412074034.GC30622@dastard>
	<5168396C.6020801@gmail.com> <20130413003222.GG30622@dastard>
	<51693104.2020707@gmail.com>
In-Reply-To: <51693104.2020707@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>, Rich Johnston <rjohnston@sgi.com>, Dave Chinner <dchinner@redhat.com>

T24gMjAxM+W5tDA05pyIMTPml6UgMTg6MTgsIFdhbmcgU2hlbmctSHVpIHdyb3RlOgo+IE9uIDIw
MTPlubQwNOaciDEz5pelIDA4OjMyLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4+IE9uIFNhdCwgQXBy
IDEzLCAyMDEzIGF0IDEyOjQyOjIwQU0gKzA4MDAsIFdhbmcgU2hlbmctSHVpIHdyb3RlOgo+Pj4g
T24gMjAxM+W5tDA05pyIMTLml6UgMTU6NDAsIERhdmUgQ2hpbm5lciB3cm90ZToKPj4+PiBPbiBG
cmksIEFwciAxMiwgMjAxMyBhdCAxMjoyNjo1M1BNICswODAwLCBXYW5nIFNoZW5nLUh1aSB3cm90
ZToKPj4+Pj4gKyMKPj4+Pj4gKwo+Pj4+PiArVE9QRElSID0gLi4KPj4+Pj4gK2luY2x1ZGUgJChU
T1BESVIpL2luY2x1ZGUvYnVpbGRkZWZzCj4+Pj4+ICsKPj4+Pj4gK1RFU1RTX1NVQkRJUlMgPSAk
KHNoZWxsIGZpbmQgLiAtbWF4ZGVwdGggMSAtdHlwZSBkIHwgc2VkIC1uIC1lICdzL1wuXC8vL2dw
JykKPj4+Pgo+Pj4+IFRoaXMgaXMgbXVjaCBuZWF0ZXI6Cj4+Pj4KPj4+PiBURVNUU19TVUJESVJT
ID0gJChzb3J0ICQoZGlyICQod2lsZGNhcmQgICQoUFdEKS8qLykpKQo+Pj4KPj4+IEhpIERhdmUs
Cj4+Pgo+Pj4gSSBpbnRyb2R1Y2VzIE1ha2VmaWxlIHVuZGVyIHRlc3RzLywgd2hpY2ggd291bGQg
cmV0dXJuIHRvIFRFU1RTX1NVQkRJUlMgd2l0aCB0aGUKPj4+ICQoZGlyIGZ1bmN0aW9uLiBCeSBy
dW5uaW5nIGZpbmQgaW4gJChzaGVsbCwgVEVTVF9TVUJESVJTIHdpbGwgb25seSBnZXQgdGhlIGRp
ciBuYW1lcywKPj4+IGFuZCBubyBNYWtlZmlsZS4KPj4KPj4gSSB0aGluayB5b3UgbWlzdW5kZXJz
dGFuZC4gVGhlIHdpbGRjYXJkIGFib3ZlIG9ubHkgcmV0dXJucwo+PiBkaXJlY3RvcmllczoKPj4K
Pj4gJCBwd2QKPj4gICAwICB+L3NyYy94ZnN0ZXN0cy1kZXYvdGVzdHMKPj4gJCBjYXQgfi90bXAv
TWFrZWZpbGUKPj4gZm9vPSQoc29ydCAkKGRpciAkKHdpbGRjYXJkICAkKFBXRCkvKi8pKSkKPj4K
Pj4gZGVmYXVsdDoKPj4gICAgICAgICAgQGVjaG8gJChmb28pCj4+ICQgbWFrZSAtZiB+L3RtcC9N
YWtlZmlsZQo+PiAvaG9tZS9kYXZlL3NyYy94ZnN0ZXN0cy1kZXYvdGVzdHMvYnRyZnMvIC9ob21l
L2RhdmUvc3JjL3hmc3Rlc3RzLWRldi90ZXN0cy9leHQ0LyAvaG9tZS9kYXZlL3NyYy94ZnN0ZXN0
cy1kZXYvdGVzdHMvZ2VuZXJpYy8gL2hvbWUvZGF2ZS9zcmMveGZzdGVzdHMtZGV2L3Rlc3RzL3No
YXJlZC8gL2hvbWUvZGF2ZS9zcmMveGZzdGVzdHMtZGV2L3Rlc3RzL3VkZi8gL2hvbWUvZGF2ZS9z
cmMveGZzdGVzdHMtZGV2L3Rlc3RzL3hmcy8KPj4gJAo+Pgo+Cj4gRGF2ZSwKPgo+IFRoZSBvdXRw
dXQgb24gbXkgYm94IGlzIGRpZmZlcmVudCB3aXRoIHlvdXJzLgo+Cj4gIyBwd2QKPiAvcm9vdC93
b3Jrc3BhY2UveGZzdGVzdHMvdGVzdHMKPiAjIGNhdCAvdG1wL01ha2VmaWxlCj4gZm9vPSQoc29y
dCAkKGRpciAkKHdpbGRjYXJkICAkKFBXRCkvKi8pKSkKPiBmb286Cj4gICAgICBAZWNobyAkKGZv
bykKPiAjIG1ha2UgLWYgL3RtcC9NYWtlZmlsZSBmb28KPiAvcm9vdC93b3Jrc3BhY2UveGZzdGVz
dHMvdGVzdHMvIC9yb290L3dvcmtzcGFjZS94ZnN0ZXN0cy90ZXN0cy9idHJmcy8gL3Jvb3Qvd29y
a3NwYWNlL3hmc3Rlc3RzL3Rlc3RzL2V4dDQvIC9yb290L3dvcmtzcGFjZS94ZnN0ZXN0cy90ZXN0
cy9nZW5lcmljLyAvcm9vdC93b3Jrc3BhY2UveGZzdGVzdHMvdGVzdHMvc2hhcmVkLyAvcm9vdC93
b3Jrc3BhY2UveGZzdGVzdHMvdGVzdHMvdWRmLyAvcm9vdC93b3Jrc3BhY2UveGZzdGVzdHMvdGVz
dHMveGZzLwo+Cj4gSXQgYWx3YXlzIG91dHB1dCB0aGUgdGVzdHMvIGRpciBpdHNlbGYuIElmIEkg
dXNlZCB0aGlzIGZvciB4ZnN0ZXN0cwo+ICdtYWtlIGluc3RhbGwnLCBpdCB3aWxsIGZhbGwgaW50
byBlbmRsZXNzIGxvb3AsIGZvciBpdCB3aWxsIHJlcnVuCj4gTWFrZWZpbGUgdW5kZXIgL3Rlc3Rz
Lgo+Cj4+IENoZWVycywKPj4KPj4gRGF2ZS4KPj4KPgoKU2VlbXMgaXQncyB0aGUgJChQV0QpIGlu
dHJvZHVjZXMgdGhlIGxvb3AuCldoZW4gbWFrZSBpbnN0YWxsIHVuZGVyIHhmc3Rlc3RzLCAkKFBX
RCkgd2lsbCByZWZlciB0byB0aGUgcGF0aCB0byB4ZnN0ZXN0cyBpbnN0ZWFkCm9mIHhmc3Rlc3Rz
L3Rlc3RzLCBldmVuIGlmIGlzIGRlZmluZWQgaW4geGZzdGVzdHMvdGVzdHMvTWFrZWZpbGUuCgpX
aWxsIHNlbmQgb3V0IHRoZSB2MyBwYXRjaCBsYXRlci4KClJlZ2FyZHMsClNoZW5nLUh1aQoKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5n
IGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZv
L3hmcwo=
