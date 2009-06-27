Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5R78H8U252809 for <xfs@oss.sgi.com>; Sat, 27 Jun 2009 02:08:18 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ABA9328831
	for <xfs@oss.sgi.com>; Sat, 27 Jun 2009 00:08:46 -0700 (PDT)
Received: from linta.de (isilmar.linta.de [213.133.102.198]) by cuda.sgi.com
	with ESMTP id zs95MxEeb1Zj8hR2 for <xfs@oss.sgi.com>;
	Sat, 27 Jun 2009 00:08:46 -0700 (PDT)
Date: Sat, 27 Jun 2009 09:08:54 +0200
From: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Subject: Re: corrupt file system -- "Structure needs cleaning"
Message-ID: <20090627070854.GL29416@mail.physik.uni-wuppertal.de>
References: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
	<B1B6286B-1472-4584-8318-F9BB4E74BF8E@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B1B6286B-1472-4584-8318-F9BB4E74BF8E@sgi.com>
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

Thus spake Felix Blyakher (felixb@sgi.com):

> Seems like no corruption on disk.
> The system detected in memory corruption and shut the filesystem
> down to avoid writing bad (meta)data to disk. I don't have answer
> for that problem, however you can continue to use the filesystem,
> and may never see this problem again. If it happens again, it
> could be useful to run debug XFS, which may point to the problem.

I ran memtest over night, without any errors. So if this happens again
and I need to run xfs_db, what do I need to do to get useful information
out? Haven't done that before ...

    Hendrik

-- 
"You have to take the most direct road to go instead of your 
 meeting, you have to, this one ended, leave at once the CERN
 domain."         (imprint on the CERN visitor ID cards)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
