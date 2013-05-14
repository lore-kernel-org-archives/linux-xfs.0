Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 445427CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 19:36:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2FEB3304059
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 17:36:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	p0DUhnnTDuXiPwkc for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 17:36:52 -0700 (PDT)
Date: Tue, 14 May 2013 10:36:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Error during bulk removal of files
Message-ID: <20130514003648.GO32675@dastard>
References: <CAEUQcejFPKDqqwbT_BNFJEVkUeAY=mgYGv-kUvLX6Ys7YQkqfg@mail.gmail.com>
	<518D22F0.8040405@sgi.com> <20130511011505.GB32675@dastard>
	<CAEUQceg6iy=TBrBkhan5bN5vO4y=JGcNy6LGhgfvO-7ereiB=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEUQceg6iy=TBrBkhan5bN5vO4y=JGcNy6LGhgfvO-7ereiB=Q@mail.gmail.com>
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
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, May 13, 2013 at 09:45:30PM +0530, Subranshu Patel wrote:
> > What 2.6.32 kernel? Output of uname -a?
> 
>  uname -a
> Linux machine1 2.6.32-279.el6.x86_64 #1 SMP Wed Jun 13 18:24:36 EDT
> 2012 x86_64 x86_64 x86_64 GNU/Linux
> 
>  # cat /etc/issue
> Red Hat Enterprise Linux Server release 6.3 (Santiago)

Please report this to your Redhat support representative. Indeed, I
suspect that running the latest update kernel will fix your problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
