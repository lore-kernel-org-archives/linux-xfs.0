Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B6EA29E0D
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 19:08:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C76C304039
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:08:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ylbOBVgkvxJx6jR4 for
	<xfs@oss.sgi.com>; Tue, 21 May 2013 17:08:08 -0700 (PDT)
Date: Tue, 21 May 2013 20:08:03 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522000803.GA19891@redhat.com>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130521235410.GY29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

T24gV2VkLCBNYXkgMjIsIDIwMTMgYXQgMDk6NTQ6MTBBTSArMTAwMCwgRGF2ZSBDaGlubmVyIHdy
b3RlOgogPiBPbiBUdWUsIE1heSAyMSwgMjAxMyBhdCAwNzo0MDoxNlBNIC0wNDAwLCBEYXZlIEpv
bmVzIHdyb3RlOgogPiA+IE9uIFdlZCwgTWF5IDIyLCAyMDEzIGF0IDA5OjM0OjI5QU0gKzEwMDAs
IERhdmUgQ2hpbm5lciB3cm90ZToKID4gPiAgPiBPbiBUdWUsIE1heSAyMSwgMjAxMyBhdCAwNjo1
Mjo1N1BNIC0wNDAwLCBEYXZlIEpvbmVzIHdyb3RlOgogPiA+ICA+ID4gWyAgNDY0LjIxMDU5OF0g
WEZTOiBBc3NlcnRpb24gZmFpbGVkOiAobWFzayAmIChBVFRSX01PREV8QVRUUl9VSUR8QVRUUl9H
SUR8QVRUUl9BVElNRXxBVFRSX0FUSU1FX1NFVHwgQVRUUl9NVElNRV9TRVR8QVRUUl9LSUxMX1NV
SUR8QVRUUl9LSUxMX1NHSUR8IEFUVFJfS0lMTF9QUklWfEFUVFJfVElNRVNfU0VUKSkgPT0gMCwg
ZmlsZTogZnMveGZzL3hmc19pb3BzLmMsIGxpbmU6IDcxOQogPiA+ICA+IAogPiA+ICA+IE5ldmVy
IHNlZW4gdGhhdCBmaXJlIGJlZm9yZSwgYnV0IHRoaXMgaXMgd2h5IHdlIGhhdmUgQVNTRVJUKClz
IGxpa2UKID4gPiAgPiB0aGlzIC0gd2UncmUgYmVpbmcgaGFuZGVkIHNvbWV0aGluZyBieSB0aGUg
VkZTIHdlIGRvbid0IGV4cGVjdC4uLgogPiA+ICA+IAogPiA+ICA+IENhbiB5b3UgZ2l2ZSBtZSBz
b21lIGNvbnRleHQgb2YgdGhlIGZpbGUgcGVybWlzc2lvbnMgYmVmb3JlIHRoZQogPiA+ICA+IHN5
c2NhbGwgYW5kIHdoYXQgdGhlIHN5c2NhbGwgcGFyYW1ldGVycyBhcmU/IGkuZS4gaXMgdGhpcyBs
aWtlbHkgdG8KID4gPiAgPiBiZSB0cnlpbmcgdG8gc3RyaXAgU1VJRC9TR0lEIGR1cmluZyB0aGUg
dHJ1bmNhdGUgb3BlcmF0aW9uPwogPiA+IAogPiA+IG5vIGlkZWEgdGJoLiBJcyB0aGVyZSBzb21l
dGhpbmcgSSBjYW4gYWRkIHRvIHRoYXQgYXNzZXJ0IHRvIGR1bXAKID4gPiB3aGljaCBmaWxlIGl0
IHdhcyB0cmlnZ2VyZWQgYnkgPwogPiAKID4gQ29udmVydCB0aGUgYXNzZXJ0IHRvIGEgaWYgKCks
IGFuZCB0aGVuIGluIHRoZSBib2R5IGRvIHNvbWV0aGluZwogPiBsaWtlOgogPiAKID4gCWlmICht
YXNrICYgKC4uLikgewogPiAJCWNoYXIgYnVmW01BWF9QQVRITEVOXTsKID4gCiA+IAkJZF9wYXRo
KFZGU19JKGlwKS0+aV9kZW50cnksIGJ1ZiwgTUFYUEFUSExFTik7CiA+IAkJeGZzX3dhcm4obXAs
ICIlczogbWFzayAweCV4IG1pc21hdGNoIG9uIGZpbGUgJXNcbiIsCiA+IAkJCSBfX2Z1bmNfXywg
bWFzaywgYnVmKTsKID4gCQlBU1NFUlQoMCk7CiA+IAl9Cgpmcy94ZnMveGZzX2lvcHMuYzogSW4g
ZnVuY3Rpb24g4oCYeGZzX3NldGF0dHJfc2l6ZeKAmToKZnMveGZzL3hmc19pb3BzLmM6NzIzOjE3
OiBlcnJvcjogaW5jb21wYXRpYmxlIHR5cGUgZm9yIGFyZ3VtZW50IDEgb2Yg4oCYZF9wYXRo4oCZ
CiAgICAgICAgICAgICAgICAgZF9wYXRoKFZGU19JKGlwKS0+aV9kZW50cnksIGJ1ZiwgTUFYUEFU
SExFTik7CiAgICAgICAgICAgICAgICAgXgpJbiBmaWxlIGluY2x1ZGVkIGZyb20gaW5jbHVkZS9s
aW51eC9mcy5oOjg6MCwKICAgICAgICAgICAgICAgICBmcm9tIGluY2x1ZGUvbGludXgvZ2VuaGQu
aDo2NSwKICAgICAgICAgICAgICAgICBmcm9tIGluY2x1ZGUvbGludXgvYmxrZGV2Lmg6OSwKICAg
ICAgICAgICAgICAgICBmcm9tIGZzL3hmcy94ZnNfbGludXguaDo0NSwKICAgICAgICAgICAgICAg
ICBmcm9tIGZzL3hmcy94ZnMuaDozMiwKICAgICAgICAgICAgICAgICBmcm9tIGZzL3hmcy94ZnNf
aW9wcy5jOjE4OgppbmNsdWRlL2xpbnV4L2RjYWNoZS5oOjMzODoxNDogbm90ZTogZXhwZWN0ZWQg
4oCYY29uc3Qgc3RydWN0IHBhdGggKuKAmSBidXQgYXJndW1lbnQgaXMgb2YgdHlwZSDigJhzdHJ1
Y3QgaGxpc3RfaGVhZOKAmQogZXh0ZXJuIGNoYXIgKmRfcGF0aChjb25zdCBzdHJ1Y3QgcGF0aCAq
LCBjaGFyICosIGludCk7CiAgICAgICAgICAgICAgXgoKCglEYXZlCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
