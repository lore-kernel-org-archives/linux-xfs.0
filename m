Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5HLUnkD235367
	for <linux-xfs@oss.sgi.com>; Wed, 17 Jun 2009 16:30:49 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4045893D202
	for <linux-xfs@oss.sgi.com>; Wed, 17 Jun 2009 14:39:03 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Hu8NTL3L1PWwOcAi for
	<linux-xfs@oss.sgi.com>; Wed, 17 Jun 2009 14:39:03 -0700 (PDT)
Message-ID: <4A3960A0.8090707@sandeen.net>
Date: Wed, 17 Jun 2009 16:31:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
References: <4A392213.4020200@news-service.com>
In-Reply-To: <4A392213.4020200@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: linux-xfs@oss.sgi.com

Patrick Schreurs wrote:
> Hi all,
> 
> We are experiencing kernel panics on servers running 2.6.29(.1) and 
> 2.6.30. I've included two attachments to demonstrate.
> 
> The error is:
> Kernel panic - not syncing: xfs_fs_destroy_inode: cannot reclaim ...
> 
> OS is 64bit Debian lenny.
> 
> Is this a known issue? Any comments on this?

It's not known to me, was this a recent upgrade?  (IOW, did it start
with .29(.1)?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
