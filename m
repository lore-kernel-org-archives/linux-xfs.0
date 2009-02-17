Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HC4tqu221664 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:04:56 -0600
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFA0719539C0
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 04:04:20 -0800 (PST)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id 30urnNi9e1LPkGno for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 04:04:20 -0800 (PST)
Received: from [83.238.65.58] (port=4672 helo=maven.pl ident=matrix157)
	by main.carme.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.69) (envelope-from <arekm@maven.pl>) id 1LZOgV-000ri1-Kb
	for xfs@oss.sgi.com; Tue, 17 Feb 2009 13:04:19 +0100
Received: from arekm by maven.pl with local (Exim 4.69)
	(envelope-from <arekm@maven.pl>) id 1LZOgU-0001wF-Qf
	for xfs@oss.sgi.com; Tue, 17 Feb 2009 13:04:19 +0100
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: libattr - severe memory leaks from attr_copy_file()
Date: Tue, 17 Feb 2009 13:04:18 +0100
References: <499AA47A.2050106@redhat.com>
In-Reply-To: <499AA47A.2050106@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902171304.18661.arekm@maven.pl>
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
To: xfs@oss.sgi.com

T24gVHVlc2RheSAxNyBvZiBGZWJydWFyeSAyMDA5LCBaZGVuZWsgUHJpa3J5bCB3cm90ZToKPiAt
wqDCoMKgwqDCoMKgwqBmcmVlKHRleHQpOwo+ICvCoMKgwqDCoMKgwqDCoGlmICh0ZXh0KQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmcmVlKHRleHQpOwoKZnJlZShOVUxMKSBpcyBm
aW5lIChvbiBMaW51eCBhdCBsZWFzdCkKCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3ogICAgICAg
IFBMRC9MaW51eCBUZWFtCmFyZWttIC8gbWF2ZW4ucGwgICAgICAgICAgICBodHRwOi8vZnRwLnBs
ZC1saW51eC5vcmcvCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwo=
