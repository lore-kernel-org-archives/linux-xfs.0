Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB8CoM3N031222
	for <linux-xfs@oss.sgi.com>; Mon, 8 Dec 2008 06:50:23 -0600
Received: from yw-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EE2616D60F6
	for <linux-xfs@oss.sgi.com>; Mon,  8 Dec 2008 04:50:21 -0800 (PST)
Received: from yw-out-1718.google.com (yw-out-1718.google.com [74.125.46.152])
	by cuda.sgi.com with ESMTP id aIJuHtIq4LQUFHz4 for
	<linux-xfs@oss.sgi.com>; Mon, 08 Dec 2008 04:50:21 -0800 (PST)
Received: by yw-out-1718.google.com with SMTP id 5so405987ywm.32
	for <linux-xfs@oss.sgi.com>; Mon, 08 Dec 2008 04:50:20 -0800 (PST)
Message-ID: <5d96567b0812080442r131d9fc8t4019c99ffbffa290@mail.gmail.com>
Date: Mon, 8 Dec 2008 14:42:34 +0200
From: Raz <raziebe@gmail.com>
Subject: XFS over SSD
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-xfs@oss.sgi.com

I am thinking of using XFS over a SSD disk.
1. Can I separate xfs meta data ( not just the logging) from the SSD ?
can I put the meta on a different disk ?
2. When does a file's meta ( its block maps ) is being flushed to disk
? can I control it ?

thank you
raz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
