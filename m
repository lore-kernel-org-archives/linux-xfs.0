Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CF1C27F51
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 15:43:53 -0600 (CST)
Message-ID: <510C371B.6070300@sgi.com>
Date: Fri, 01 Feb 2013 15:43:55 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsprogs: fix warning in libxcmd/input.c
References: <20130201213649.GM30652@sgi.com>
In-Reply-To: <20130201213649.GM30652@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

T24gMDIvMDEvMTMgMTU6MzYsIEJlbiBNeWVycyB3cm90ZToKPiBGaXggYW4gZXJyb3Igd2hlbiBi
dWlsZGluZyB3aXRoIC1XZXJyb3I9Zm9ybWF0LXNlY3VyaXR5Lgo+Cj4gaW5wdXQuYzogSW4gZnVu
Y3Rpb24gJ2ZldGNobGluZSc6Cj4gaW5wdXQuYzo5MToyOiBlcnJvcjogZm9ybWF0IG5vdCBhIHN0
cmluZyBsaXRlcmFsIGFuZCBubyBmb3JtYXQgYXJndW1lbnRzIFstV2Vycm9yPWZvcm1hdC1zZWN1
cml0eV0KPgo+IFNpZ25lZC1vZmYtYnk6IEJlbiBNeWVyczxicG1Ac2dpLmNvbT4KPiBSZXBvcnRl
ZCBieTogQXJrYWRpdXN6IE1pxZtraWV3aWN6PGFyZWttQG1hdmVuLnBsPgo+IEluZGV4OiB4ZnNw
cm9ncy9saWJ4Y21kL2lucHV0LmMKPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Cj4gLS0tIHhmc3Byb2dzLm9yaWcvbGli
eGNtZC9pbnB1dC5jCTIwMTMtMDItMDEgMTU6Mjk6NDcuMDY5ODk0NTIyIC0wNjAwCj4gKysrIHhm
c3Byb2dzL2xpYnhjbWQvaW5wdXQuYwkyMDEzLTAyLTAxIDE1OjMwOjAwLjg0NTg5NTE4OCAtMDYw
MAo+IEBAIC04OCw3ICs4OCw3IEBACj4KPiAgIAlpZiAoIWxpbmUpCj4gICAJCXJldHVybiBOVUxM
Owo+IC0JcHJpbnRmKGdldF9wcm9tcHQoKSk7Cj4gKwlwcmludGYoIiVzIiwgZ2V0X3Byb21wdCgp
KTsKPiAgIAlmZmx1c2goc3Rkb3V0KTsKPiAgIAlpZiAoIWZnZXRzKGxpbmUsIE1BWFJFQURMSU5F
U1osIHN0ZGluKSkgewo+ICAgCQlmcmVlKGxpbmUpOwo+Cj4gX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KPiB4ZnMgbWFpbGluZyBsaXN0Cj4geGZzQG9zcy5z
Z2kuY29tCj4gaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCgpMb29rcyBn
b29kLgoKUmV2aWV3ZWQtYnk6IE1hcmsgVGluZ3VlbHkgPHRpbmd1ZWx5QHNnaS5jb20+CgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
