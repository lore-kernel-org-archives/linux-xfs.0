Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BD397F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 16:27:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 173DD8F8052
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 14:27:48 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id i8TRdNnhhcKwe6xY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 14:27:46 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id 8E66710C084
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 23:27:45 +0200 (CEST)
MIME-Version: 1.0
Date: Tue, 16 Sep 2014 23:27:45 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: Re: unclean shutdown of usb hdd destroyed xfs partially
In-Reply-To: <20140913220916.GC4267@dastard>
References: <3999c95c0dc7ebfdfbb2853a6d13f7dc@zbfmail.de>
	<082ebd288523ee6155b66debade2a775@zbfmail.de>
	<20140913220916.GC4267@dastard>
Message-ID: <330c89398cb4eef9b7289c1ffef8bcc3@zbfmail.de>
Reply-To: weber@zbfmail.de
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
To: Xfs <xfs@oss.sgi.com>

CgpBbSAyMDE0LTA5LTE0IDAwOjA5LCBzY2hyaWViIERhdmUgQ2hpbm5lcjoKPiBPbiBTYXQsIFNl
cCAxMywgMjAxNCBhdCAwNDozNjo1OVBNICswMjAwLCBNYXJrbyBXZWJlcnw4MDAwIHdyb3RlOgo+
PiAKPj4gYW4gb3V0cHV0IG9mICB4ZnNfcmVwYWlyIC12IC1MIC9kZXYvc2RlMQo+IC4uLgo+PiAK
Pj4gICMgeGZzX3JlcGFpciAtdiAtTCAvZGV2L3NkZTEKPiAKPiBXaGF0IHZlcnNpb24/CgpmaXJz
dCBpdCB3YXMgMy4xLjEwCmxhdGVyIGxpa2UgcG9zdGVkIDMuMi4xCgo+IAo+PiBQaGFzZSAxIC0g
U3VwZXJibG9jayBmaW5kZW4gdW5kIMO8YmVycHLDvGZlbi4uLgo+PiAgICAgICAgIC0gQmVyaWNo
dHMtUHJvemVzcyBpbiBBYnN0w6RuZGVuIHZvbiAxNSBNaW51dGVzCj4+ICAgICAgICAgLSBCbG9j
ay1ad2lzY2hlbnNwZWljaGVyZ3LDtsOfZSBpc3QgYXVmIDE0ODc3OTIgRWludHLDpGdlIGdlc2V0
enQKPj4gUGhhc2UgMiAtIGVpbiBpbnRlcm5lcyBQcm90b2tvbGwgYmVudXR6ZW4KPj4gICAgICAg
ICAtIE51bGwtUHJvdG9rb2xsLi4uCj4+IHplcm9fbG9nOiBoZWFkIGJsb2NrIDQwIHRhaWwgYmxv
Y2sgNDAKPj4gICAgICAgICAtIGZyZWllciBTcGVpY2hlciB1bmQgSW5vZGUtS2FydGVuIGRlcyBE
YXRlaXN5c3RlbXMgd2VyZGVuCj4+IGdlc2Nhbm50Li4uCj4+IGJhZCBtYWdpYyBudW1iZXJiYWQg
bWFnaWMgbnVtYmVyYmFkIG1hZ2ljIG51bWJlcgo+IC4uLi4KPj4gZmFsc2NoZXIgb24tZGlzay1T
dXBlcmJsb2NrIDEyIC0gZmFsc2NoZSBNYWdpc2NoZSBOdW1tZXIKPj4gTWV0YWRhdGEgY29ycnVw
dGlvbiBkZXRlY3RlZCBhdCBibG9jawo+PiAweDIwYmY4ZTUwLzB4MTAwMHByaW3DpHJlL3Nla3Vu
ZMOkcmVyIFN1cGVyYmxvY2stMTItS29uZmxpa3QgLQo+PiBBRy1TdXBlcmJsb2NrLUdlb21ldHJp
ZS1JbmZvIGhhdCBlaW5lbiBLb25mbGlrdCBtaXQgZGVyCj4+IERhdGVpc3lzdGVtLUdlb21ldHJp
ZQo+PiBmbGFzY2hlIG1hZ2lzY2hlICMgMHgwIGbDvHIgYWdmIDEyCj4+IGZhbHNjaGUgVmVyc2lv
biAjIDAgZsO8ciBhZ2YgMTIKPj4gCj4+IE1ldGFkYXRhIGNvcnJ1cHRpb24gZGV0ZWN0ZWQgYXQg
YmxvY2sgMHg0MTdmMWM5MC8weDEwMDAKPj4gZmFsc2NoZXIgb24tZGlzay1TdXBlcmJsb2NrIDYg
LSBmYWxzY2hlIE1hZ2lzY2hlIE51bW1lcgo+PiBwcmltw6RyZS9zZWt1bmTDpHJlciBTdXBlcmJs
b2NrLTYtS29uZmxpa3QgLQo+PiBBRy1TdXBlcmJsb2NrLUdlb21ldHJpZS1JbmZvIGhhdCBlaW5l
biBLb25mbGlrdCBtaXQgZGVyCj4+IERhdGVpc3lzdGVtLUdlb21ldHJpZQo+PiBmYWxzY2hlciBv
bi1kaXNrLVN1cGVyYmxvY2sgMyAtIGZhbHNjaGUgTWFnaXNjaGUgTnVtbWVyCj4+IHVuZ2VudXR6
dGVuIEFudGVpbCBkZXMgwrtzZWt1bmTDpHLCqy1TdXBlcmJsb2NrcyBudWxsZW4gKEFHICM2KQo+
PiBNZXRhZGF0YSBjb3JydXB0aW9uIGRldGVjdGVkIGF0IGJsb2NrIDB4NTc1NDI2MTAvMHgxMDAw
Cj4+IGZhbHNjaGUgU2VxdWVueiAjIDAgZsO8ciBhZ2YgMTIKPj4gTWV0YWRhdGEgY29ycnVwdGlv
biBkZXRlY3RlZCBhdCBibG9jawo+PiAweDc4MTNiNDUwLzB4MTAwMFNwZWljaGVyenVncmlmZnNm
ZWhsZXIKPiAKPiBJIGRvbid0IHJlYWQgZ2VybWFuKD8pIGJ1dCB0aGF0IGxvb2tzIGxpa2UgbWFu
eSBBRyBoZWFkZXIgYmxvY2sKPiBoYXZlIGJlZW4gb3ZlcndyaXR0ZW4gd2l0aCB6ZXJvcyAoMCBt
YWdpYyBudW1iZXIsIDAgc2VxdWVuY2UgIywgMAo+IGxlbmd0aCwgZXRjKSBhbmQgc28gZXZlbiBp
ZiB3ZSBjYW4gcmVwYWlyIHRoZSBmaWxlc3lzdGVtLCBJJ2QKPiBzdWdnZXN0IHRoYXQgeW91IG5l
ZWQgdG8gdmVyaWZ5IHRoYXQgdGhlIGRhdGEgaW4gZXZlcnkgZmlsZSBpbiB0aGUKPiBmaWxlc3lz
dGVtIGlzIGNvcnJlY3QuCj4gCj4gSXMgdGhhdCBhcyBmYXIgYXMgeGZzX3JlcGFpciBnb3Q/IElm
IHNvLCBpdCB3b3VsZCBoYXZlIGFwcGVhcmVkIHRvCj4gY3Jhc2guICBDYW4geW91IHJ1biB0aGUg
bGFzdGVzdCB2ZXJzaW9uIGluc2lkZSBnZGIgdG8gZ2V0IGEgc3RhY2sKPiB0cmFjZSB3aGVuIGl0
IGRpZXM/IE9yLCBhbHRlcm5hdGl2ZWx5LCBwcm92aWRlIGEgbWV0YWR1bXAgZm9yIG9uZSBvZgo+
IHVzIHRvIGxvb2sgYXQgbW9yZSBjbG9zZWx5PwoKeWVzLCB0aGlzIGlzIGFzIGZhciB4ZnNfcmVw
YWlyIGdvdCBpdC4Kd2hhdCBpcyBtZW50ICdydW4gbGF0ZXN0IHZlcnNpb24gaW4gZ2RiPycgZ251
ZGVidWdnZXI/IGhvdyBkbyBpIGRvIHRoYXQ/IApjb25zb2xlIGV4YW1wbGUgbmVlZGVkLgphbmQg
aG93IGRvIGkgZG8gdGhlIG1ldGFkdW1wPwoKdGhhbmsgeW91CgptYXJrbwo+IAo+IENoZWVycywK
PiAKPiBEYXZlLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
