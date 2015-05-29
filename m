Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C76A7F50
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 07:05:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E9DD8F8071
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 05:05:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LwtmnulqZpsSAzOa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 05:05:52 -0700 (PDT)
Date: Fri, 29 May 2015 08:05:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to cddc116
Message-ID: <20150529120549.GA36053@bfoster.bfoster>
References: <20150528215309.GA15721@dastard>
 <20150528222109.GC4316@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150528222109.GC4316@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, May 29, 2015 at 08:21:09AM +1000, Dave Chinner wrote:
> On Fri, May 29, 2015 at 07:53:09AM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > The for-next branch of the xfs kernel repository at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> > 
> > has just been updated.
> > 
> > The new head of the for-next branch is commit:
> > 
> > cddc116 xfs: xfs_iozero can return positive errno
> 
> Note: i just updated it again with a patch I missed in the
> xfs-for-linus-v4.1-rc6 branch:
> 
> Brian Foster (1):
>       [22419ac] xfs: fix broken i_nlink accounting for whiteout tmpfile inode
> 

Any word on the following two as well?

http://oss.sgi.com/pipermail/xfs/2015-April/041504.html
http://oss.sgi.com/pipermail/xfs/2015-May/041582.html

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
