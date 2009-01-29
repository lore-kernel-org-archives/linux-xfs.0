Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0TEiOgO210460 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 08:44:25 -0600
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC7EBC9161
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 06:43:42 -0800 (PST)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id DolWLRSpPqAK7nby for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 06:43:42 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: [PATCH] [LIBXCMD]: Move error messages to appropriate places.
Date: Thu, 29 Jan 2009 15:43:07 +0100
References: <1233167051-14711-1-git-send-email-arekm@maven.pl>
	<4981BD32.2090405@bigpond.net.au>
In-Reply-To: <4981BD32.2090405@bigpond.net.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901291543.07441.arekm@maven.pl>
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
To: Donald Douwsma <ddouwsma@bigpond.net.au>
Cc: xfs@oss.sgi.com

T24gVGh1cnNkYXkgMjkgb2YgSmFudWFyeSAyMDA5LCBEb25hbGQgRG91d3NtYSB3cm90ZToKPiBB
cmthZGl1c3ogTWnFm2tpZXdpY3ogd3JvdGU6Cj4gPiBSZXBsYWNlIHJhdyBwZXJyb3IoKSB3aXRo
IHByb3BlciBtZXNzYWdlIGluCj4gPiBmc190YWJsZV9pbml0aWFsaXNlX21vdW50cygpLgo+ID4K
PiA+IFJlcGxhY2UgcmF3IHBlcnJvcigpIHdpdGggcHJvcGVyIG1lc3NhZ2UgYW5kIG1vdmUgaXQg
ZnJvbQo+ID4gZnNfbW91bnRfcG9pbnRfZnJvbV9wYXRoKCkgdG8gZnNfdGFibGVfaW5pdGlhbGlz
ZV9wcm9qZWN0cygpIHdoZXJlIHRoaXMKPiA+IG1lc3NhZ2UgaGFzIG1lYW5pbmcuCj4KPiBJIGxp
a2UgeW91ciBjaGFuZ2UsIGl0IG1ha2VzIHRoaW5ncyBjbGVhcmVyLgo+Cj4gQnV0IGRvZXMgdGhp
cyBwYXJ0aWN1bGFyIGVycm9yIGFjdHVhbGx5IGhlbHAgcGVvcGxlPyBJJ3ZlIHNlZW4gaXQgYSBm
ZXcKPiB0aW1lcyB3aGVuIHRlc3RpbmcgcXVvdGEgY29kZSBpbiB0aGUgcGFzdC4gSXQncyBvbmx5
IHVzZWQgd2hlbiByZWFkaW5nIGluCj4gcHJvamVjdHMsIGFuZCBjYXVzZXMgZXJyb3JzIHRvIGJl
IGRpc3BsYXllZCBldmVuIHdoZW4gaXNzdWluZyBub24gcHJvamVjdAo+IGNvbW1hbmRzLgo+Cj4g
JCBzdWRvIGJhc2ggLWMgImVjaG8gMTA6L3Zhci9ub25leGlzdGFudGRpciA+PiAvZXRjL3Byb2pl
Y3RzCj4gJCB4ZnNfcXVvdGEgLWMgcHJpbnQKPiAvdmFyL25vbmV4aXN0YW50ZGlyOiBObyBzdWNo
IGZpbGUgb3IgZGlyZWN0b3J5Cj4gRmlsZXN5c3RlbSAgICAgICAgICBQYXRobmFtZQo+IC9ob21l
ICAgICAgICAgICAgICAgL2Rldi9zZGE4CgpOb3cgaXQgd2lsbCBiZToKeGZzX3F1b3RhOiBjYW5u
b3QgZmluZCBtb3VudCBwb2ludCBmb3IgcGF0aCBgL3Zhci9ub25leGlzdGFudGRpcic6IE5vIHN1
Y2ggCmZpbGUgb3IgZGlyZWN0b3J5Cgo+IEknZCBiZSB0ZW1wdGVkIHRvIHJlbW92ZSB0aGlzIGVy
cm9yLCBhbmQgYWRkIGVycm9yIGNoZWNraW5nIGNvZGUgdG8gdGhlCj4gcHJvamVjdCBzcGVjaWZp
YyBjb21tYW5kcyB0aGF0IHdhbGsgdHJlZSdzLgoKVGhlIHBhdGggd29uJ3QgYmUgYWRkZWQgdG8g
d2FsayBpdGVyYXRvciBhbmQgdGhlcmUgd2lsbCBiZSBubyBlcnJvciBhdCB3YWxrIAp0aW1lLiAK
ClRoZSBmaXggd291bGQgYmUgcHJvYmFibHkgdG8gbm90IGFkZCBwcm9qZWN0IHRvIHRoZSBpdGVy
YXRpbmcgZW5naW5lIHdoZW4gCmFza2luZyBmb3Igbm9uLXByb2plY3QgdGhpbmdzIGV0Yy4gCgo+
IERvbgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiAgICAgICAgUExEL0xpbnV4IFRlYW0KYXJl
a20gLyBtYXZlbi5wbCAgICAgICAgICAgIGh0dHA6Ly9mdHAucGxkLWxpbnV4Lm9yZy8KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxp
c3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hm
cwo=
