Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2KIL0Ol002161 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 13:21:01 -0500
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id BW6SzHPcnyV4mSI3
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 20 Mar 2012 11:20:58 -0700 (PDT)
Received: by bkwj4 with SMTP id j4so297108bkw.26
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 11:20:57 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: memory out with XFS quotacheck oom-killer
Date: Tue, 20 Mar 2012 19:21:04 +0100
References: <000501cd06ac$3fb68440$bf238cc0$@de>
In-Reply-To: <000501cd06ac$3fb68440$bf238cc0$@de>
MIME-Version: 1.0
Message-Id: <201203201921.04898.arekm@maven.pl>
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
Cc: Martin <martin@inetsolutions.de>

T24gVHVlc2RheSAyMCBvZiBNYXJjaCAyMDEyLCBNYXJ0aW4gd3JvdGU6Cj4gTGludXggdmVyc2lv
biAyLjYuMzItNS1hbWQ2NCAoRGViaWFuIDIuNi4zMi0zMSkgb24gVk0KClRoaXMgYnVnIGlzIGZp
eGVkIGluIG5ld2VyIGtlcm5lbHMuCgo3MDRiMjkwN2MyZDQ3Y2ViMTg3YzBlMjVhNmJiYzIxNzRi
MTk4ZjJmIGlmIEkgcmVtZW1iZXIgY29ycmVjdGx5LgoKLS0gCkFya2FkaXVzeiBNacWba2lld2lj
eiAgICAgICAgUExEL0xpbnV4IFRlYW0KYXJla20gLyBtYXZlbi5wbCAgICAgICAgICAgIGh0dHA6
Ly9mdHAucGxkLWxpbnV4Lm9yZy8KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
