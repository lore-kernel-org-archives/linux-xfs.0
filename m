Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0KASKVZ000458 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 04:28:20 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 111651781F5
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 02:29:18 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	li32kq59nGQEWete for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 02:29:18 -0800 (PST)
Received: by ewy27 with SMTP id 27so6103879ewy.36
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 02:29:17 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?VXRrYW4gR8O8bmfDtnJkw7w=?= <salviati@freeconsole.org>
Date: Wed, 20 Jan 2010 12:28:57 +0200
Message-ID: <6e2cff861001200228y6ba1186dmb105f046c5eac328@mail.gmail.com>
Subject: xfsr: a tool to save stuff from crippled XFS partition
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Here's a dirty, incomplete tool I wrote awhile ago for those who
crippled their XFS partition, either by running mkfs or writing random
stuff on the device file:
http://freeconsole.org/crew/salviati/#sec-stuff-comp-xfsr
The source uses only some headers from xfsprogs, considering the FS
could fail the sanity of the official tools. The whole thing is ugly,
but it's better than saying goodbye to whole data, I guess :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
