Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S7PdWq255372 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 02:25:39 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42CA041B448
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 00:29:11 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id 3pDZeQEesvMYLJ2k
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 00:29:11 -0700 (PDT)
Received: by vws13 with SMTP id 13so1984776vws.26
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 00:29:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110427171107.GA29196@infradead.org>
References: <BANLkTimAXUtO=oxmLUaHLaRBnGafGP-9kg@mail.gmail.com>
	<20110427171107.GA29196@infradead.org>
Date: Thu, 28 Apr 2011 12:59:11 +0530
Message-ID: <BANLkTi=xpSa2x4vaD4zQjrz3_JSLkC-hgg@mail.gmail.com>
Subject: Re: xfstests 013 - 2.6.35.11 - hang
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

TUlQUzMywq4gMzRL4oSiIENvcmUKSXQgZG9lcyBub3QgcHJvdmlkZSAgaW52YWxpZGF0ZV9rZXJu
ZWxfdm1hcF9yYW5nZSgpIC8KZmx1c2hfa2VybmVsX3ZtYXBfcmFuZ2UoKSB0byBkZWFsIHdpdGgg
Y2FjaGUgY29oZXJlbmN5IHByb2JsZW0KVGhlcmVmb3JlIHdlIHByb3ZpZGVkIGRtYV9jYWNoZV9p
bnYoKSAvIGRtYV9jYWNoZV93YmFja19pbnYoKSAsIGFmdGVyCnRoYXQgd2UgZGlkIG5vdCBoYWQg
YW55IGNvaGVyZW5jeSBwcm9ibGVtCkJ1dCBhcyB5b3Ugc2F5aW5nIGl0IHN0aWxsIGhhcyBjYWNo
ZSBjb2hlcmVuY3kgcHJvYmxlbSwgd3J0IHhmc3Rlc3RzIDAwMSA/CgpkaWZmIC1OdXJwIC1YIGxp
bnV4LTIuNi4zNS4xMS9Eb2N1bWVudGF0aW9uL2RvbnRkaWZmCmxpbnV4LTIuNi4zNS4xMS9mcy94
ZnMvbGludXgtMi42L3hmc19idWYuYwpsaW51eC0yLjYuMzUuMTEtZGlydHkvZnMveGZzL2xpbnV4
LTIuNi94ZnNfYnVmLmMKLS0tIGxpbnV4LTIuNi4zNS4xMS9mcy94ZnMvbGludXgtMi42L3hmc19i
dWYuYyAgMjAxMS0wMi0wNwowNDowNDowNy4wMDAwMDAwMDAgKzA5MDAKKysrIGxpbnV4LTIuNi4z
NS4xMS1kaXJ0eS9mcy94ZnMvbGludXgtMi42L3hmc19idWYuYyAgICAyMDExLTAzLTIyCjE4OjI5
OjA5LjAwMDAwMDAwMCArMDkwMApAQCAtMTE5Miw3ICsxMTkyLDcgQEAgeGZzX2J1Zl9iaW9fZW5k
X2lvKAogICAgICAgIHhmc19idWZfaW9lcnJvcihicCwgLWVycm9yKTsKCiAgICAgICAgaWYgKCFl
cnJvciAmJiB4ZnNfYnVmX2lzX3ZtYXBwZWQoYnApICYmIChicC0+Yl9mbGFncyAmIFhCRl9SRUFE
KSkKLSAgICAgICAgICAgICAgIGludmFsaWRhdGVfa2VybmVsX3ZtYXBfcmFuZ2UoYnAtPmJfYWRk
ciwgeGZzX2J1Zl92bWFwX2xlbihicCkpOworICAgICAgICAgICAgICAgZG1hX2NhY2hlX2ludigo
dW5zaWduZWQgbG9uZylicC0+Yl9hZGRyLCB4ZnNfYnVmX3ZtYXBfbGVuKGJwKSk7CgogICAgICAg
IGRvIHsKICAgICAgICAgICAgICAgIHN0cnVjdCBwYWdlICAgICAqcGFnZSA9IGJ2ZWMtPmJ2X3Bh
Z2U7CkBAIC0xMzA0LDcgKzEzMDQsNyBAQCBuZXh0X2NodW5rOgogc3VibWl0X2lvOgogICAgICAg
IGlmIChsaWtlbHkoYmlvLT5iaV9zaXplKSkgewogICAgICAgICAgICAgICAgaWYgKHhmc19idWZf
aXNfdm1hcHBlZChicCkpIHsKLSAgICAgICAgICAgICAgICAgICAgICAgZmx1c2hfa2VybmVsX3Zt
YXBfcmFuZ2UoYnAtPmJfYWRkciwKKyAgICAgICAgICAgICAgICAgICAgICAgZG1hX2NhY2hlX3di
YWNrX2ludigodW5zaWduZWQgbG9uZylicC0+Yl9hZGRyLAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB4ZnNfYnVmX3ZtYXBfbGVuKGJwKSk7CiAgICAgICAg
ICAgICAgICB9CiAgICAgICAgICAgICAgICBzdWJtaXRfYmlvKHJ3LCBiaW8pOwoKT24gV2VkLCBB
cHIgMjcsIDIwMTEgYXQgMTA6NDEgUE0sIENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFkZWFk
Lm9yZz4gd3JvdGU6Cj4gRG9lcyAwMDEgYWxzbyBmYWlsIGZvciBzYXkgZXh0MiBhbmQgZXh0Mz8K
Pgo+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMg
bWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9s
aXN0aW5mby94ZnMK
