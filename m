Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF8B17F3F
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 11:43:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE90B304048
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 09:43:29 -0700 (PDT)
Received: from st11p01mm-asmtp001.mac.com (st11p01mm-asmtp001.mac.com
	[17.172.204.239]) by cuda.sgi.com with ESMTP id
	GuQg4BhdH576btFZ (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Oct 2014 09:43:29 -0700 (PDT)
Received: from [192.168.142.67] ([82.71.189.231]) by st11p01mm-asmtp001.mac.com
	(Oracle Communications Messaging Server 7u4-27.10(7.0.4.27.9) 64bit
	(built Jun
	6 2014)) with ESMTPSA id <0NDG00GMZ14DK610@st11p01mm-asmtp001.mac.com>
	for xfs@oss.sgi.com; Tue, 14 Oct 2014 16:43:28 +0000 (GMT)
References: <4ddef393-ad9e-49a1-80d7-9c29bcd74c8f@me.com>
	<20141013220940.GE17506@dastard>
	<EC9978C1-65B4-48B8-9C3D-980341A752E8@me.com>
	<20141014125506.4bbeaefd@harpe.intellique.com>
	<7630F174-D8AF-412D-8BBA-C3B1F7E05B9F@me.com>
	<20141014183804.2baa8dd5@harpe.intellique.com>
MIME-version: 1.0 (1.0)
In-reply-to: <20141014183804.2baa8dd5@harpe.intellique.com>
Message-id: <0199BE3F-9AA3-43F5-8622-777245C6824E@me.com>
From: Tom Mason <tom_mason@me.com>
Subject: Re: Mount: Structure needs cleaning
Date: Tue, 14 Oct 2014 17:43:25 +0100
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

CgoKCj4gT24gMTQgT2N0IDIwMTQsIGF0IDE3OjM4LCBFbW1hbnVlbCBGbG9yYWMgPGVmbG9yYWNA
aW50ZWxsaXF1ZS5jb20+IHdyb3RlOgo+IAo+IExlIFR1ZSwgMTQgT2N0IDIwMTQgMTY6NDY6Mzkg
KzAxMDAKPiBUb20gTWFzb24gPHRvbV9tYXNvbkBtZS5jb20+IMOpY3JpdmFpdDoKPiAKPj4+IFRv
IGNvcHkgdGhlIGRpc2sgb24gYW5vdGhlciBvbmUsIHlvdSBjYW4gdXNlIGRkcmVzY3VlIG9yIGRk
IHdpdGgKPj4+ICJub2Vycm9yIiBvcHRpb24uCj4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLSAgCj4+IFRoYW5rcyBhZ2FpbiEKPj4gQ2FuIEkgY3JlYXRlIGFuIGlt
YWdlIG9uIGEgbmV3IE5BUyBkcml2ZSBzdWNoIGFzIGEgc2VhZ2F0ZSAzdGIKPj4gJ0NlbnRyYWwg
bmV0d29yayBhdHRhY2hlZCBzdG9yYWdlIE5BUycgU1RDRzMwMDAyMDAgd2l0aG91dAo+PiBpbnRl
cmZlcmluZyB3aXRoIGl0cyBjYXBhYmlsaXRpZXMgYXMgYSBOQVMgZHJpdmU/Cj4gCj4gWWVzIG9m
IGNvdXJzZSwgc2ltcGx5IG1ha2UgYSBmaWxlIGltYWdlIG9uIHRoZSBzaGFyZWQgdm9sdW1lIDoK
PiAKPiAKPiBkZCBpZj0vZGV2L3NkYjIgbm9lcnJvciBvZj0vbW91bnRwb2ludC9teW5hcy9kaXNr
MVRCLmltZwo+IAo+IFRoZW4geW91IGNhbiBydW4geGZzX3JlcGFpciBvbiB0aGUgaW1hZ2UgZmls
ZToKPiAKPiB4ZnNfcmVwYWlyIC1mIC9tb3VudHBvaW50L215bmFzL2Rpc2sxVEIuaW1nCj4gCj4g
T3IgcnVuIHBob3RvcmVjIG9uIGl0IAo+IAo+IHBob3RvcmVjIC9tb3VudHBvaW50L215bmFzL2Rp
c2sxVEIuaW1nCj4gCj4gClRoYW5rcyBFbW1hbnVlbCEgTXVjaCBhcHByZWNpYXRlZCA6ICkgSSds
bCBvcmRlciBhIG5ldyBOQVMgYW5kIG1pZ2h0IGhhdmUgc29tZSBtb3JlIHF1ZXN0aW9ucyB3aGVu
IEkgZ2V0IHRvIHdvcmsgb24gaXQgaWYgdGhhdHMgb2s/ClRoYW5rcyBhZ2FpbiBmb3IgYWxsIHRo
ZSBoZWxwIERhdmUvQnJpYW4vRW1tYW51ZWwhClRvbQpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
