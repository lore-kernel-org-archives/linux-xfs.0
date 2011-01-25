Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P7bFIs213199 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:37:15 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D57E1A1DA09
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 23:39:36 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id gKtN8Lvm2mAWF4bm for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 23:39:36 -0800 (PST)
Date: Tue, 25 Jan 2011 08:39:00 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Optimize RAID0 for max IOPS?
Message-ID: <20110125083900.4dd65bf2@galadriel2.home>
In-Reply-To: <20110124230314.GA11040@dastard>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
	<20110124215713.82D75B187@gemini.denx.de>
	<20110124230314.GA11040@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Wolfgang Denk <wd@denx.de>, Justin Piszcz <jpiszcz@lucidpixels.com>

TGUgVHVlLCAyNSBKYW4gMjAxMSAxMDowMzoxNCArMTEwMCB2b3VzIMOpY3JpdmllejoKCj4gT25s
eSAxNiBmaWxlcz8KCklJUkMgdGhpcyBpcyAxNiB0aG91c2FuZHMgb2YgZmlsZXMuIFRob3VnaCB0
aGlzIGlzIG5vdCBlbm91Z2gsIEkKZ2VuZXJhbGx5IHVzZSA4MCB0byAxNjAgZm9yIHRlc3RzLgoK
LS0gCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQpFbW1hbnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVj
aG5pcXVlCiAgICAgICAgICAgICAgICAgICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAg
ICAgICB8CTxlZmxvcmFjQGludGVsbGlxdWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICAr
MzMgMSA3OCA5NCA4NCAwMgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
