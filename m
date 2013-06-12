Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E9867F5F
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 08:52:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEA23AC005
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 06:52:16 -0700 (PDT)
Received: from stockholm.opq.se ([213.88.151.150]) by cuda.sgi.com with ESMTP
	id pWqLkUondSgbR38R (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 06:52:14 -0700 (PDT)
Received: from [10.2.10.41] (acme.pacific [10.2.10.41])
	by stockholm.opq.se (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id
	r5CDqBMh029531 for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 15:52:13 +0200
Subject: Re: Questions about XFS
From: Roger Oberholtzer <roger@opq.se>
In-Reply-To: <51B84EB3.1070906@redhat.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<1371025611.7096.10.camel@acme>  <51B84EB3.1070906@redhat.com>
Date: Wed, 12 Jun 2013 15:52:11 +0200
Message-ID: <1371045131.16366.18.camel@acme.pacific>
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
To: xfs@oss.sgi.com

T24gV2VkLCAyMDEzLTA2LTEyIGF0IDA2OjM0IC0wNDAwLCBSaWMgV2hlZWxlciB3cm90ZToKPiBP
biAwNi8xMi8yMDEzIDA0OjI2IEFNLCBSb2dlciBPYmVyaG9sdHplciB3cm90ZToKPiA+IE9uIFR1
ZSwgMjAxMy0wNi0xMSBhdCAxMToxMiAtMDUwMCwgU3RldmUgQmVyZ21hbiB3cm90ZToKPiA+PiBB
cmUgeW91IHNheWluZyB0aGF0IHdpdGggWEZTIHRoZXJlIGlzIG5vIHBlcmlvZGljCj4gPj4gZmx1
c2hpbmcgbWVjaGFuaXNtIGF0IGFsbD8gQW5kIHRoYXQgdW5sZXNzIHRoZXJlJ3MgYW4KPiA+PiBm
c3luYy9mZGF0YXN5bmMvc3luYyBvciB0aGUgbWVtb3J5IG5lZWRzIHRvIGJlIHJlY2xhaW1lZCwg
dGhhdCBpdCBjYW4KPiA+PiBzaXQgaW4gdGhlIHBhZ2UgY2FjaGUgZm9yZXZlcj8KPiA+IEkgcmVh
ZCB0aGUgbGF0ZXIgcmVzcG9uc2VzIHRvIHRoaXMgYW5kIHRoZXkgc2VlbWVkIHRvIHNheSB0aGF0
IHRoZSBkYXRhCj4gPiBpbiB0aGUgcGFnZSBjYWNoZSBzaG91bGQgYmUgd3JpdHRlbiB0byB0aGUg
ZGlzayBwZXJpb2RpY2FsbHkuIEkgYW0gbm90Cj4gPiBtZWFuaW5nIHRvIGhpamFjayB0aGUgdGhy
ZWFkLiBJIGp1c3QgaGF2ZSBhIHF1ZXN0aW9uIGRpcmVjdGx5IHJlbGF0ZWQgdG8KPiA+IHRoaXMg
cG9pbnQuCj4gCj4gWW91IG1vc3QgbGlrZWx5IG5lZWQgdG8gYWRqdXN0IHNvbWUgb2YgdGhlIHZt
IHR1bmluZ3MgdG8gY2F1c2UgdGhlIHZtIHRvIGtpY2sgCj4gb3V0IHBhZ2VzIG1vcmUgZXZlbmx5
LiBOb3Qgc3VyZSB3aGF0IHRoZSBvcGVuc3VzZSBjcm93ZCB3b3VsZCBzdWdnZXN0IHR3ZWFraW5n
LgoKSW4gcHJvZ3Jlc3MuIAoKPiA+IEkgaGF2ZSBhbiBhcHBsaWNhdGlvbiB0aGF0IGlzIHN0cmVh
bWluZyBkYXRhIHRvIGFuIFhGUyBkaXNrIGF0IGEKPiA+IHN1c3RhaW5lZCAyNSBNQi9zZWMuIFRo
aXMgaXMgd2VsbCBiZWxvdyB3aGF0IHRoZSBoYXJkd2FyZSBzdXBwb3J0cy4gVGhlCj4gPiBhcHBs
aWNhdGlvbiBkb2VzIGZvcGVuL2Z3cml0ZS9mY2xvc2UgKG5vIGFjdGl2ZSBmbHVzaGluZyBvciBz
eW5jaW5nKS4KPiAKPiBTb3VuZHMgbGlrZSB0aGlzIGlzIG1vcmUgbGlrZWx5IHRvIGJlIGFuIGFw
cGxpY2F0aW9uIGlzc3VlIHRoYW4gYSBmaWxlIHN5c3RlbSAKPiBvbmUuIENhbiB5b3UgcHVzaCB0
aGUgSU8gd3JpdGUgc3BlZWQgdXAgd2l0aCBhIHNpbXBsZSAiZGQiIHRlc3QgdG8gYSBmaWxlPwoK
SSBoYXZlIGEgc21hbGwgdGVzdCBhcHAgdGhhdCBjYW4gZWl0aGVyIHdyaXRlIGF0IGZ1bGwgc3Bl
ZWQgKDEwMCBNQi9TZWMKYXMgaXQgdHVybnMgb3V0IG9uIHRoZSBzeXN0ZW0gaW4gcXVlc3Rpb24p
IG9yIGF0IHRoZSBhcHAgcmF0ZSBvZiAyNQpNQi9TZWMuIFdoZW4gYXQgZnVsbCBzcGVlZCwgdGhl
IGNhY2hlIGJlY29tZXMgYmlnZ2VyIGZhc3Rlci4gQnV0IHRoZQpyZXN1bHQgaXMgdGhlIHNhbWUu
IE1lbW9yeSBldmVudHVhbGx5IHNlZW1zIHRvIGJlIGFsbCB0YWtlbiBieSB0aGUKY2FjaGUuIEl0
IGlzIGZyZWVkIHdoZW4gSSB1bW91bnQgdGhlIGZpbGUgc3lzdGVtIG9yICJlY2hvIDEKPiAvcHJv
Yy9zeXMvdm0vZHJvcF9jYWNoZXMiCgoKWW91cnMgc2luY2VyZWx5LAoKUm9nZXIgT2JlcmhvbHR6
ZXIKClJhbWLDtmxsIFJTVCAvIFN5c3RlbXMKCk9mZmljZTogSW50ICs0NiAxMC02MTUgNjAgMjAK
TW9iaWxlOiBJbnQgKzQ2IDcwLTgxNSAxNjk2CnJvZ2VyLm9iZXJob2x0emVyQHJhbWJvbGwuc2UK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwoKUmFtYsO2bGwgU3Zlcmln
ZSBBQgpLcnVrbWFrYXJnYXRhbiAyMQpQLk8uIEJveCAxNzAwOQpTRS0xMDQgNjIgU3RvY2tob2xt
LCBTd2VkZW4Kd3d3LnJhbWJvbGxyc3Quc2UKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
