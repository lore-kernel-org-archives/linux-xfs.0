Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA4BGtJR087756 for <xfs@oss.sgi.com>; Fri, 4 Nov 2011 06:16:56 -0500
Received: from mail.SerNet.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BABCA21FE0D
	for <xfs@oss.sgi.com>; Fri,  4 Nov 2011 04:16:54 -0700 (PDT)
Received: from mail.SerNet.de (mail.SerNet.de [193.175.80.2]) by cuda.sgi.com
	with ESMTP id 8lyyOornvLDj1U3X for <xfs@oss.sgi.com>;
	Fri, 04 Nov 2011 04:16:54 -0700 (PDT)
Date: Fri, 4 Nov 2011 12:16:36 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@sernet.de>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
Message-Id: <E1RMHlS-00HYp9-Hk@intern.SerNet.DE>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, Unix Support <unix-support@ucs.cam.ac.uk>

T24gMjAxMS0xMS0wMyBhdCAxNToyMCArMDAwMCBBbnRvbiBBbHRhcGFybWFrb3Ygc2VudCBvZmY6
Cj4gSGksCj4gCj4gT3VyIENJRlMgc2VydmVyIHByb2JsZW1zIHNlZW0gdG8gaGF2ZSBubyBlbmTi
gKYgIFRoZSBOb3ZlbGwgQ0lGUyBzZXJ2ZXIgZG9lcyBub3Qgc3VwcG9ydCBzZXJ2ZXIgaW5vZGUg
bnVtYmVycyAod2hlbiBJIHRyeSB0aGUgbW91bnQgb3B0aW9uIEkgZ2V0IHRoZSBtZXNzYWdlIGl0
IGlzIGJlaW5nIHR1cm5lZCBvZmYgYXMgc2VydmVyIGRvZXMgbm90IHN1cHBvcnQgaXQpIGFuZCB0
aHVzIGVhY2ggaW5vZGUgZ2V0cyBhIGRpZmZlcmVudCBudW1iZXIgZWFjaCB0aW1lIGl0IGlzIGFj
Y2Vzc2VkIGFuZCBpdCBnZXRzIGEgZGlmZmVyZW50IG51bWJlciBhZ2FpbiBmb3IgZWFjaCByZWFk
ZGlyIGNhbGwuCj4gCj4gVGhlIGZ1biBoYXBwZW5zIHdpdGggcmVuYW1lKCkgd2hlbiB0aGUgcmVu
YW1lIHNvdXJjZSBhbmQgdGFyZ2V0IG9ubHkgZGlmZmVyIGluIGNhc2UsIGUuZy4KPiAKPiAJdG91
Y2ggZm9vCj4gCW12IGZvbyBGb28KCnNvbWVob3cgcmVsYXRlZCBzZWVtcyBodHRwczovL2J1Z3pp
bGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTM5NTEyCihhcyBsb25nIGFzIGtlcm5lbCBi
dWd6aWxsYSBpcyBkZWFkLCBzZWUKaHR0cDovL3d3dy5saW51eC5zZ2kuY29tL2FyY2hpdmVzL3hm
cy1tYXN0ZXJzLzIwMTEtMDcvbXNnMDAwMjIuaHRtbCApCgpDYXNlIGluc2Vuc2l0aXZlIGZpbGVz
eXN0ZW1zIHNlZW0gdG8gYmUgYSBwcm9ibGVtIGluIGdlbmVyYWwgb24gTGludXguIE5vdCBzdXJl
CmhvdyBmYXIga2VybmVsIGFuZC9vciBnbGliYyBhcmUgaW52b2x2ZWQgaW4gdGhlIHByb2JsZW0u
IEFzIGEgd29ya2Fyb3VuZCBmb3IKdGhlIG1lc3MgeW91IG5lZWQgdG8gZG8gYSB0ZW1wb3Jhcnkg
cmVuYW1lIHRvIGEgZGlmZmVyZW50IG5hbWUgKG5vdCBqdXN0IGEgY2FzZQplcXVpdmFsZW50IG5h
bWUpLgoKQmrDtnJuCi0tIApTZXJOZXQgR21iSCwgQmFobmhvZnNhbGxlZSAxYiwgMzcwODEgR8O2
dHRpbmdlbgpwaG9uZTogKzQ5LTU1MS0zNzAwMDAtMCwgZmF4OiArNDktNTUxLTM3MDAwMC05CkFH
IEfDtnR0aW5nZW4sIEhSQiAyODE2LCBHRjogRHIuIEpvaGFubmVzIExveGVuCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
