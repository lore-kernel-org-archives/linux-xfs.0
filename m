Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF9D729DF5
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 13:40:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7CD4304067
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 11:40:05 -0700 (PDT)
Received: from mail-yk0-f173.google.com (mail-yk0-f173.google.com
	[209.85.160.173]) by cuda.sgi.com with ESMTP id
	VeYeCjvX2zbZEb2b (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Oct 2015 11:40:04 -0700 (PDT)
Received: by ykaz22 with SMTP id z22so59091605yka.2
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 11:40:03 -0700 (PDT)
Subject: Re: very long log recovery at mount
References: <201510211127.52794.arekm@maven.pl>
From: "Michael L. Semon" <mlsemon35@gmail.com>
Message-ID: <5627DBDD.3060702@gmail.com>
Date: Wed, 21 Oct 2015 14:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <201510211127.52794.arekm@maven.pl>
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
To: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <arekm@maven.pl>, xfs <xfs@oss.sgi.com>

T24gMTAvMjEvMTUgMDU6MjcsIEFya2FkaXVzeiBNacWba2lld2ljeiB3cm90ZToKPgo+IEhpLgo+
Cj4gSSBnb3Qgc3VjaCBzaXR1YXRpb24sIGZyZXNoIGJvb3QsIDQuMS4xMCBrZXJuZWwsIGluaXQg
c2NyaXB0cyBzdGFydCBtb3VudGluZwo+IGZpbGVzeXN0ZW1zLiBPbmUgZnMgd2Fzbid0IHZlcnkg
bHVja3k6Cj4KPiBbICAgMTUuOTc5NTM4XSBYRlMgKG1kMyk6IE1vdW50aW5nIFY0IEZpbGVzeXN0
ZW0KPiBbICAgMTYuMjU2MzE2XSBYRlMgKG1kMyk6IEVuZGluZyBjbGVhbiBtb3VudAo+IFsgICAy
OC4zNDMzNDZdIFhGUyAobWQ0KTogTW91bnRpbmcgVjQgRmlsZXN5c3RlbQo+IFsgICAyOC42Mjk5
MThdIFhGUyAobWQ0KTogRW5kaW5nIGNsZWFuIG1vdW50Cj4gWyAgIDI4LjY2MjEyNV0gWEZTICht
ZDUpOiBNb3VudGluZyBWNCBGaWxlc3lzdGVtCj4gWyAgIDI4Ljk4MDE0Ml0gWEZTIChtZDUpOiBF
bmRpbmcgY2xlYW4gbW91bnQKPiBbICAgMjkuMDQ5NDIxXSBYRlMgKG1kNik6IE1vdW50aW5nIFY0
IEZpbGVzeXN0ZW0KPiBbICAgMjkuNDQ3NzI1XSBYRlMgKG1kNik6IFN0YXJ0aW5nIHJlY292ZXJ5
IChsb2dkZXY6IGludGVybmFsKQo+IFsgNDUxNy4zMjczMzJdIFhGUyAobWQ2KTogRW5kaW5nIHJl
Y292ZXJ5IChsb2dkZXY6IGludGVybmFsKQo+Cj4gSXQgdG9vayBvdmVyIDFoIHRvIG1vdW50IG1k
NiBmaWxlc3lzdGVtLgo+Cj4gUXVlc3Rpb25zOgo+IC0gaXMgaXQgcG9zc2libGUgdG8gbG9nIGhv
dyBtdWNoIGRhdGEgaXMgbmVlZGVkIHRvIGJlIHJlY292ZXJlZCBmcm9tIGxvZz8gU29tZQo+IGRh
dGEgdGhhdCB3b3VsZCBnaXZlIGEgaGludCBvbiBob3cgYmlnIHRoaXMgaXMgKGFuZCB0aHVzIHJv
dWdoIGVzdGltYXRlIG9uIGhvdwo+IGxvbmcgaXQgd2lsbCB0YWtlKS4gTm90IHN1cmUgaWYgdGhh
dCdzIGtub3duIGF0IHRpbWUgd2hlbiB0aGlzIG1lc3NhZ2UgaXMKPiBiZWluZyBwcmludGVkLgo+
Cj4gWEZTIChtZDYpOiBTdGFydGluZyByZWNvdmVyeSAobG9nZGV2OiBpbnRlcm5hbCwgdG8gcmVj
b3ZlcjogeHl6TUIgKD8pKQo+Cj4gLSBub3cgc3VjaCBsb25nIG1vdW50IHRpbWUgaXMgYWxtb3N0
IGluc2FuZSwgc28gSSB3b25kZXIgd2h5IGNvdWxkIGJlIHRoZQo+IHJlYXNvbi4gSXMgdGhlIHBy
b2Nlc3MgbXVsdGl0aHJlYWRlZCwgc2luZ2xlIHRocmVhZGVkPyBjcHVzIHdlcmUgaWRsZQo+CgpN
eSBvbGQgUEMgdXNlZCB0byBzdWZmZXIgZnJvbSBpbnRlcm1pdHRlbnRseSBsb25nIG1vdW50IHRp
bWVzLCBhbmQgSSB3cm90ZSBhCm9uZS1jaGFyYWN0ZXIgcGF0Y2ggdG8gZml4IHRoYXQgaXNzdWU6
CgpodHRwOi8vb3NzLnNnaS5jb20vYXJjaGl2ZXMveGZzLzIwMTUtMDEvbXNnMDAxODMuaHRtbAoK
SSdtIHB1dHRpbmcgaXQgb3V0IHRoZXJlIG9ubHkgdG8gYXNrIHRoZSBsaXN0IGlmIHdyYXBwZWQt
bG9nIGhhbmRsaW5nIGNvdWxkIGJlCnRoZSBpc3N1ZSBoZXJlLiAgRG9uJ3QgdHJ5IHRoZSBwYXRj
aCB3aXRob3V0IGdvb2QgcmVhc29uOiAgSSd2ZSB0ZXN0ZWQgaXQgb25seQphcyBsYXRlIGFzIGtl
cm5lbCAzLjE4LjIyLCBvbiAzMi1iaXQgTGludXggd2l0aCBNQlIgYW5kIEdQVCBwYXJ0aXRpb25z
LCBub3QKbXVjaCBvZiBhIHRlc3QgbWF0cml4LgoKVGhhbmtzIQoKTWljaGFlbAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
