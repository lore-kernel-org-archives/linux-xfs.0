Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4H0Lq8M148547 for <xfs@oss.sgi.com>; Sat, 16 May 2009 19:21:53 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44D2319D41B6
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 17:22:00 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id RSnoGMDOB5g4Ldsb for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 17:22:00 -0700 (PDT)
Date: Sun, 17 May 2009 10:21:53 +1000 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1390308465.5011561242519713247.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <4A0F3ACD.7020905@sandeen.net>
Subject: Re: [PATCH] xfsprogs: fix readline/editline for xfs_io and xfs_quota
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>


----- "Eric Sandeen" <sandeen@sandeen.net> wrote:

> Eric Sandeen wrote:
> > Christoph Hellwig wrote:
> 
> ...
> 
> >> (btw, any reason we don't enable readline support by default if
> >> we find the headers installed?)
> >>
> > 
> > I dunno... Nathan, any idea?  Maybe some git-digging is in order.
> > 

No idea, sorry, too long ago... perhaps not wanting to introduce
dependencies unexpectedly (rescue disks/installers, etc might not
have readline lib).

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
