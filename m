Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B2C2B7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 11:18:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 845A18F8033
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 09:17:58 -0700 (PDT)
Received: from mcgraw.st-andrews.ac.uk (mcgraw.st-andrews.ac.uk
	[138.251.8.95]) by cuda.sgi.com with ESMTP id Cf3orDnIkAcMmvSS
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 08 Aug 2016 09:17:55 -0700 (PDT)
Subject: Re: Advice needed with file system corruption
References: <5787852A.7030900@st-andrews.ac.uk>
	<20160808161132.1d76eb5c@harpe.intellique.com>
From: Steve Brooks <sjb14@st-andrews.ac.uk>
Message-ID: <03277397-8360-3b9a-a163-b7d234310a8e@st-and.ac.uk>
Date: Mon, 8 Aug 2016 17:16:05 +0100
MIME-Version: 1.0
In-Reply-To: <20160808161132.1d76eb5c@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>, Steve Brooks <sjb14@st-andrews.ac.uk>
Cc: xfs@oss.sgi.com

SGksCgpJIGNob3NlIHRoZSB3b3JkcyAicmVidWlsZGluZyBhIHJlcGxhY2VkIGRpc2siIGRlbGli
ZXJhdGVseSBhcyBJIHJlbW92ZWQgCmEgZGlzayB0aGF0IChhY2NvcmRpbmcgdG8gYWRhcHRlYydz
IHNvZnR3YXJlKSBoYWQgc29tZSAibWVkaWEgZXJyb3JzIiAKZXZlbiB0aG91Z2ggdGhlIFNNQVJU
IGF0dHJpYnV0ZXMgc2hvd2VkIHRoZXJlIHdlcmUgbm8gInBlbmRpbmcgc2VjdG9ycyIgCm9yICJy
ZWFsbG9jYXRlZCBzZWN0b3JzIiwgaW4gZmFjdCBhbGwgdGhlIFNNQVJUIGF0dHJpYnV0ZXMgd2Vy
ZSBjbGVhbi4gIApBcyBJIHdhcyBhbHNvIHVzaW5nICJSQUlEIDYiIEkgZGlkIG5vdCBleHBlY3Qg
YW55IGlzc3VlcyBsZWF2aW5nIHRoZSAKZmlsZXN5c3RlbSBvbmxpbmUgd2hpbGUgcmVidWlsZGlu
Zy4gUHJldmlvdXMgdG8gdGhpcyB0aGUgUkFJRCBoYWQgYmVlbiAKcnVubmluZyBsaXZlIDI0Lzcg
Zm9yIDB2ZXIgdGhyZWUgeWVhcnMuCgpTdGV2ZQoKICBPbiAwOC8wOC8yMDE2IDE1OjExLCBFbW1h
bnVlbCBGbG9yYWMgd3JvdGU6Cj4gTGUgVGh1LCAxNCBKdWwgMjAxNiAxMzoyNzoyMiArMDEwMAo+
IFN0ZXZlIEJyb29rcyA8c2piMTRAc3QtYW5kcmV3cy5hYy51az4gw6ljcml2YWl0Ogo+Cj4+IFdl
IGhhdmUgYSBSQUlEIHN5c3RlbSB3aXRoIGZpbGUgc3lzdGVtIGlzc3VlcyBhcyBmb2xsb3dzLAo+
Pgo+PiA1MCBUQiBpbiBSQUlEIDYgaG9zdGVkIG9uIGFuIEFkYXB0ZWMgNzE2MDUgY29udHJvbGxl
ciB1c2luZwo+PiBXRDQwMDBGWVlaIGRyaXZlcy4KPj4KPj4gQ2VudG9zIDYuNyAgMi42LjMyLTY0
Mi5lbDYueDg2XzY0ICAgOiAgIHhmc3Byb2dzLTMuMS4xLTE2LmVsNgo+Pgo+PiBXaGlsZSByZWJ1
aWxkaW5nIGEgcmVwbGFjZWQgZGlzaywgd2l0aCB0aGUgZmlsZSBzeXN0ZW0gb25saW5lIGFuZCBp
bgo+PiB1c2UsIHRoZSBzeXN0ZW0gbG9ncyBzaG93ZWQgbXVsdGlwbGUgZW50cmllcyBvZjsKPj4K
Pj4gWEZTIChzZGUpOiBDb3JydXB0aW9uIGRldGVjdGVkLiBVbm1vdW50IGFuZCBydW4geGZzX3Jl
cGFpci4KPj4KPiBMYXRlIHRvIHRoZSBnYW1lLCBJIGp1c3Qgd2FudGVkIHRvIHJlbWFyayB0aGF0
IEkndmUgdW5mb3J0dW5hdGVseQo+IHZlcmlmaWVkIG1hbnkgdGltZXMgdGhhdCB3cml0ZSBhY3Rp
dml0eSBkdXJpbmcgcmVidWlsZHMgb24gQWRhcHRlYyBSQUlECj4gY29udHJvbGxlcnMgb2Z0ZW4g
Y3JlYXRlcyBjb3JydXB0aW9uLiBJJ3ZlIHJlcG9ydGVkIHRoYXQgdG8gQWRhcHRlYywKPiBidXQg
dGhleSBkb24ndCBzZWVtIHRvIGNhcmUgbXVjaC4uLgo+CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
