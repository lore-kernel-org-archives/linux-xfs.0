Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7A747CA3
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 23:11:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4297DAC001
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 21:11:43 -0700 (PDT)
Received: from mail-pa0-f65.google.com (mail-pa0-f65.google.com
	[209.85.220.65]) by cuda.sgi.com with ESMTP id Bl0Okn1be2tlxf1D
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 21:11:41 -0700 (PDT)
Received: by mail-pa0-f65.google.com with SMTP id hf6so2821422pac.2
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 21:11:41 -0700 (PDT)
Message-ID: <1466568697.14061.1.camel@gmail.com>
Subject: [PATCH v2] xfs: indentation fix in xfs_btree_get_iroot()
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Wed, 22 Jun 2016 12:11:37 +0800
Mime-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

VGhlIGluZGVudGF0aW9uIGluIHRoaXMgZnVuY3Rpb24gaXMgZGlmZmVyZW50IGZyb20gdGhlIG90
aGVyIGZ1bmN0aW9ucy4KVGhvc2Ugc3BhY2ViYXJzIGFyZSBjb252ZXJ0ZWQgdG8gdGFicyB0byBp
bXByb3ZlIHJlYWRhYmlsaXR5LgoKU2lnbmVkLW9mZi1ieTogS2FobyBOZyA8bmdrYWhvMTIzNEBn
bWFpbC5jb20+Ci0tLQrCoGZzL3hmcy9saWJ4ZnMveGZzX2J0cmVlLmMgfCA4ICsrKystLS0tCsKg
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9mcy94ZnMvbGlieGZzL3hmc19idHJlZS5jIGIvZnMveGZzL2xpYnhmcy94ZnNfYnRyZWUu
YwppbmRleCAxZjg4ZTFjLi40Zjg0ZGRlIDEwMDY0NAotLS0gYS9mcy94ZnMvbGlieGZzL3hmc19i
dHJlZS5jCisrKyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2J0cmVlLmMKQEAgLTU0MywxMiArNTQzLDEy
IEBAIHhmc19idHJlZV9wdHJfYWRkcigKwqAgKi8KwqBTVEFUSUMgc3RydWN0IHhmc19idHJlZV9i
bG9jayAqCsKgeGZzX2J0cmVlX2dldF9pcm9vdCgKLcKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19i
dHJlZV9jdXLCoMKgwqDCoCpjdXIpCisJc3RydWN0IHhmc19idHJlZV9jdXIJKmN1cikKwqB7Ci3C
oMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaWZvcmvCoMKgwqDCoMKgwqDCoMKgKmlmcDsKKwlzdHJ1
Y3QgeGZzX2lmb3JrCSppZnA7CsKgCi3CoMKgwqDCoMKgwqDCoGlmcCA9IFhGU19JRk9SS19QVFIo
Y3VyLT5iY19wcml2YXRlLmIuaXAsIGN1ci0KPmJjX3ByaXZhdGUuYi53aGljaGZvcmspOwotwqDC
oMKgwqDCoMKgwqByZXR1cm4gKHN0cnVjdCB4ZnNfYnRyZWVfYmxvY2sgKilpZnAtPmlmX2Jyb290
OworCWlmcCA9IFhGU19JRk9SS19QVFIoY3VyLT5iY19wcml2YXRlLmIuaXAsIGN1ci0KPmJjX3By
aXZhdGUuYi53aGljaGZvcmspOworCXJldHVybiAoc3RydWN0IHhmc19idHJlZV9ibG9jayAqKWlm
cC0+aWZfYnJvb3Q7CsKgfQrCoArCoC8qCi0twqAKMi45LjAKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
