Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLH7V9n026781 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 11:07:32 -0600
Received: from fk-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E7B43B44A
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 09:07:29 -0800 (PST)
Received: from fk-out-0910.google.com (fk-out-0910.google.com
	[209.85.128.191]) by cuda.sgi.com with ESMTP id
	1Vo7PqG3Zqy21zZm for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2008 09:07:29 -0800 (PST)
Received: by fk-out-0910.google.com with SMTP id 26so1163516fkx.4
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 09:07:29 -0800 (PST)
Message-ID: <7bcfcfff0812210907t6515b070ie553556d451c308@mail.gmail.com>
Date: Sun, 21 Dec 2008 12:07:28 -0500
From: "David Bernick" <dbernick@gmail.com>
Subject: Re: xfs_repair problem.
In-Reply-To: <494E766B.5080102@sandeen.net>
MIME-Version: 1.0
References: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>
	<494E66D9.5030704@sandeen.net>
	<7bcfcfff0812210852v6c1cd522i334de914e1e9a112@mail.gmail.com>
	<494E766B.5080102@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

The xfs_repair is running. seems to have stabilized at about 91% RAM usage.
It's at a part where its "clearing inode number in entry at offset...", so
hopefully its just progressing.

I'll grab the newest version of xfs_repair and try that if this all fails.
WHere can I grab the latest?

>
> > Kernel is - 2.6.18-92.1.1.el5
>
> heh; RHEL5 does not support xfs ;)
>
shhh. i know that :)

"well, you don't want to take out part of the device if the fs thinks it
owns it now, but from the db output I think you still have the smaller
size."

That's what I thought from looking at everything, too.

"I'd read through:

http://oss.sgi.com/archives/xfs/2008-01/msg00085.html"
I've been pouring through that thread since 3am EST :)


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
