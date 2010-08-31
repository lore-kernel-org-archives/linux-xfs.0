Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VDU4Z5063616 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 08:30:05 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 130073D5F9
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 06:30:41 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id eCNzC6jpOz6qkja7
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 06:30:41 -0700 (PDT)
Message-ID: <4C7D03FA.4010106@profihost.ag>
Date: Tue, 31 Aug 2010 15:30:34 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS Quota Check OOM
References: <4C7BA0A0.5090202@profihost.ag>	<4C7CB0FE.1020302@profihost.ag>	<20100831104418.058ab6b5@galadriel.home>	<4C7CF4C4.9030105@profihost.ag>	<20100831144319.7e97acea@galadriel.home>	<4C7CFC08.1000708@profihost.ag>
	<20100831152016.5d800e93@galadriel.home>
In-Reply-To: <20100831152016.5d800e93@galadriel.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

SGkhCgpBZnRlciBib290aW5nIHRoZSBTeXN0ZW0gdG8gYSBSQU0gSW1hZ2Ugd2l0aCBwcmpxdW90
YSAodGhlIHF1b3RhIGNoZWNrIAp3ZW50cyBmaW5lKSBhbmQgdXBncmFkaW5nIHRvIHhmc3Byb2dz
IDMuMS4zLgoKSSdtIGdldHRpbmcgdGhpcyB3aGVuIHRyeWluZyB0byBzZXR1cCBhIHByb2plY3Qg
UXVvdGE6Cnhmc19xdW90YSAteCAtYyAicHJvamVjdCAtcyAyIiAvClNldHRpbmcgdXAgcHJvamVj
dCAyIChwYXRoIC9zZXJ2ZXJiYWNrdXAvYWJjKS4uLgpQcm9jZXNzZWQgMSAoL2V0Yy9wcm9qZWN0
cyBhbmQgY21kbGluZSkgcGF0aHMgZm9yIHByb2plY3QgMiB3aXRoIApyZWN1cnNpb24gZGVwdGgg
aW5maW5pdGUgKC0xKS4KCiAgY2F0IC9ldGMvcHJvamVjdHMKMjovc2VydmVyYmFja3VwL2FiYwoK
Y2F0IC9ldGMvcHJvamlkCmFiYzoyCgpscyAtbGEgL3NlcnZlcmJhY2t1cC9hYmMvCnRvdGFsIDEw
MjQxMgpkcnd4ci14ci14ICAyIHJvb3Qgcm9vdCAgICAgICAgMTYgQXVnIDI0IDAwOjQxIC4KZHJ3
eHIteHIteCA2MiByb290IHJvb3QgICAgICA4MTkyIEF1ZyAzMSAxMzowNSAuLgotcnctci0tci0t
ICAxIHJvb3Qgcm9vdCAxMDQ4NTc2MDAgQXVnIDI0IDAwOjQxIGFiYwoKICBtb3VudAovZGV2L3Nk
YTMgb24gLyB0eXBlIHhmcyAocncsbm9hdGltZSxub2RpcmF0aW1lLG5vYmFycmllcixwcmpxdW90
YSkKClN0ZWZhbgoKQW0gMzEuMDguMjAxMCAxNToyMCwgc2NocmllYiBFbW1hbnVlbCBGbG9yYWM6
Cj4gTGUgVHVlLCAzMSBBdWcgMjAxMCAxNDo1Njo0MCArMDIwMCB2b3VzIMOpY3JpdmllejoKPgo+
PiBPaCB3ZSBkb24ndCBkbyB0aGlzIHRvZGF5LiBCdXQgaXQgaXMgYSByZWFsbHkgb2xkIHN5c3Rl
bSB3aGVyZQo+PiBzb21lb25lIHNvbWVkYXkgZGVjaWRlZCB0byBkbyB0aGF0LiBTYWRseSBpIGNh
bid0IGNoYW5nZSB0aGlzLi4uCj4+Cj4KPiBEaWQgeW91IHVwZ3JhZGUgdGhlIGtlcm5lbCByZWNl
bnRseT8gT3Igc2ltcGx5IGVuYWJsZWQgcXVvdGFzPwo+CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNv
bQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
