Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALF2YOq005401
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 09:02:34 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4636B1F38E68
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:02:32 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	g6MxI0uPwG8k2OsK for <linux-xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 07:02:32 -0800 (PST)
Received: by iaen33 with SMTP id n33so8685302iae.26
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 07:02:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111121150158.5f8b2512@harpe.intellique.com>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121150158.5f8b2512@harpe.intellique.com>
Date: Mon, 21 Nov 2011 23:02:32 +0800
Message-ID: <CAJNJY8SoNvqQB0WNJq5SVUhkLSJROoMkVEkOHrESVR0iMB4JDA@mail.gmail.com>
Subject: Re: stale NFS file handle problem on XFS inode64
From: hank peng <pengxihan@gmail.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@oss.sgi.com

bm8sIGNsaWVudCBhbmQgc2VydmVyIGFyZSBib3RoIDMyIGJpdHMga2VybmVsLgoKMjAxMS8xMS8y
MSBFbW1hbnVlbCBGbG9yYWMgPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+Ogo+IExlIE1vbiwgMjEg
Tm92IDIwMTEgMjE6MDA6NTcgKzA4MDAKPiBoYW5rIHBlbmcgPHBlbmd4aWhhbkBnbWFpbC5jb20+
IMOpY3JpdmFpdDoKPgo+PiBORlMgc2VydmVyOiBrZXJuZWwgdmVyc2lvbiBpcyAyLjYuMzUuNgo+
PiBORlMgY2xpZW50OiBrZXJuZWwgdmVyc2lvbiBpcyAyLjYuMTgKPj4KPj4gQW55IGlkZWFzIG9u
IGhvdyB0byBkZWFsIHdpdGggdGhpcyBwcm9ibGVtPwo+Cj4gQXJlIHRoZSBjbGllbnQgYW5kIHRo
ZSBzZXJ2ZXIgcnVubmluZyBhIDY0IGJpdHMga2VybmVsPwo+Cj4gLS0KPiAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KPiBFbW1hbnVlbCBGbG9yYWMgwqAgwqAgfCDCoCBEaXJlY3Rpb24gdGVjaG5pcXVlCj4gwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB8IMKgIEludGVsbGlxdWUKPiDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoHwgwqAgPGVmbG9yYWNAaW50ZWxsaXF1ZS5jb20+Cj4gwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqB8IMKgICszMyAxIDc4IDk0IDg0IDAyCj4gLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCj4KCgoKLS0gClRoZSBzaW1wbGVzdCBpcyBub3QgYWxsIGJlc3QgYnV0IHRoZSBiZXN0IGlz
IHN1cmVseSB0aGUgc2ltcGxlc3QhCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3Nz
LnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
