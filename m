Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A0C27F3F
	for <xfs@oss.sgi.com>; Tue, 31 Dec 2013 04:00:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2222DAC00D
	for <xfs@oss.sgi.com>; Tue, 31 Dec 2013 02:00:15 -0800 (PST)
Message-ID: <52C295A8.2040104@oracle.com>
Date: Tue, 31 Dec 2013 18:00:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 9/10] xfs: implement bulkstat per allocation group
References: <52BEB47B.3090001@oracle.com> <52C1B900.8080002@sgi.com>
In-Reply-To: <52C1B900.8080002@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gMjAxM+W5tDEy5pyIMzHml6UgMDI6MTgsIE1hcmsgVGluZ3VlbHkgd3JvdGU6Cj4gT24gMTIv
MjgvMTMgMDU6MjIsIEplZmYgTGl1IHdyb3RlOgo+PiBGcm9tOiBKaWUgTGl1PGplZmYubGl1QG9y
YWNsZS5jb20+Cj4+Cj4+IFdpdGggeGZzX3BlcmFnX2J1bGtzdGF0KCksIHdlIGNhbiByZXR1cm4g
c3RhdCBpbmZvcm1hdGlvbiBpbiBidWxrIGJ5Cj4+IGlub2RlIGFzIHBlciB0aGUgZ2l2ZW4gYWxs
b2NhdGlvbiBncm91cCBudW1iZXIgYW5kIHN0YXJ0IGlub2RlIG51bWJlcgo+PiBpbiBpdCB2aWEg
YSBuZXcgaW9jdGwoMikgaW4gdGhlIGZ1dHVyZS4KPj4KPj4gUmVmYWN0b3IgeGZzX2J1bGtzdGF0
KCkgd2l0aCBpdC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogSmllIExpdTxqZWZmLmxpdUBvcmFjbGUu
Y29tPgo+PiAtLS0KPiAKPiAKPiBjYXVzZXMgeGZzLzE4MyB0byBhc3NlcnQgZm9yIG1lOgo+IAo+
IFhGUzogQXNzZXJ0aW9uIGZhaWxlZDogZnNfaXNfb2ssIGZpbGU6IC9yb290L3hmcy9mcy94ZnMv
eGZzX2l0YWJsZS5jLAo+IGxpbmU6IDQwOQpPb3BzISEgSSBndWVzcyB0aGUgYXNzZXJ0aW9uIGlz
IGZhaWxlZCBhdDoKCisgICAgICAgICAgICAgICAgICAgICAgIGVycm9yID0geGZzX2lub2J0X2xv
b2t1cChjdXIsIDAsIFhGU19MT09LVVBfR0UsICZpKTsKKyAgICAgICAgICAgICAgICAgICAgICAg
aWYgKGVycm9yKQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOworICAgICAg
ICAgICAgICAgICAgICAgICBYRlNfV0FOVF9DT1JSVVBURURfR09UTyhpID09IDEsIGVycm9yMCk7
CgpXaGljaCBtZWFucyBJIGhhdmUgdG8gdGFrZSBjYXJlIG9mIHRob3NlIG5vbi1wcmltYXJ5IEFH
cyBvbiBhbiBuZXcgaW5pdGlhbGl6ZWQKZW1wdHktZmlsZXN5c3RlbSBhcyB0aGVyZSBoYXMgbm8g
aW5vZGUgY2h1bmsgaGFzIGJlZW4gYWxsb2NhdGVkLi4uCgpUaGFua3MsCi1KZWZmCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
