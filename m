Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A1A57FBA
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:44:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08A77304070
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:44:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id P4w3PXFTc5H0oOVB for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 08:44:10 -0700 (PDT)
Message-ID: <51643749.5080800@sandeen.net>
Date: Tue, 09 Apr 2013 10:44:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<51642E5E.3040403@sandeen.net>
	<CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
	<CADFMGuLu5Vz6=7rBU5ECPxupcxWS5rk8j0BKkX6kyJSdGgSrXg@mail.gmail.com>
In-Reply-To: <CADFMGuLu5Vz6=7rBU5ECPxupcxWS5rk8j0BKkX6kyJSdGgSrXg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
Cc: xfs@oss.sgi.com

T24gNC85LzEzIDEwOjIzIEFNLCC3+9PAzM4gd3JvdGU6Cj4gU28gbXkgcXVlc3Rpb24gaXMgd2h5
IHhmcyBzaHV0ZG93biBhbHdheXMgIGhhcHBlbnM/IFdpdGggc2FtZQo+IHJlYXNvbih4ZnNfaXVu
bGlua19yZW1vdmU6IHhmc19pbm90b2JwKCkgcmV0dXJuZWQgZXJyb3IgMjIKPiB4ZnNfaW5hY3Rp
dmU6IHhmc19pZnJlZSByZXR1cm5lZCBlcnJvciAyMiB4ZnNfZG9fZm9yY2Vfc2h1dGRvd24pLgo+
IFRoZSBzZXJ2ZXIgbG9hZCBpcyBoaWdoIGFuZCBpcyBpdCByZWxhdGVkPwoKV2UgZG9uJ3Qga25v
dyB5ZXQuICA6KQoKSSdkIGxpa2UgdG8ga25vdyB3aGF0IHdhcyBwYXNzZWQgdG8geGZzX2lub3Rv
YnAgd2hlbiBpdCBzaHV0IGRvd24sCmFuZCB3aGF0IGNhdXNlZCB0aGUgRUlOVkFMICgyMikgcmV0
dXJuLiAgUGVyaGFwcyBzb21lIHRyYWNpbmcKb3Igc3lzdGVtdGFwIHNjcmlwdHMgY291bGQgdG8g
aXQuCgpJZiB5b3Ugb25seSBoaXQgdGhpcyBldmVyeSBmZXcgd2Vla3MsIHRob3VnaCwgaXQncyBn
b2luZyB0byBiZQpkaWZmaWN1bHQgdG8gY2F0Y2guCgotRXJpYwoKPiBmcmVlIC1tCj4gICAgICAg
ICAgICAgIHRvdGFsICAgICAgIHVzZWQgICAgICAgZnJlZSAgICAgc2hhcmVkICAgIGJ1ZmZlcnMg
ICAgIGNhY2hlZAo+IE1lbTogICAgICAgIDEyOTAxNiAgICAgMTI4MDY3ICAgICAgICA5NDggICAg
ICAgICAgMCAgICAgICAgIDEwICAgICAxMTk5MDUKPiAtLysgYnVmZmVycy9jYWNoZTogICAgICAg
ODE1MCAgICAgMTIwODY1Cj4gU3dhcDogICAgICAgICA0MDkzICAgICAgICAgIDAgICAgICAgNDA5
Mwo+IAo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
eGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxt
YW4vbGlzdGluZm8veGZzCg==
