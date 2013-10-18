Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C3E529E04
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:30:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15F07304081
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:30:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mfXXCcE28CV1YXcg for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 15:30:53 -0700 (PDT)
Date: Sat, 19 Oct 2013 09:30:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: dirent dtype presence is dependent on directory
	magic numbers
Message-ID: <20131018223049.GV4446@dastard>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
	<1380497826-13474-3-git-send-email-david@fromorbit.com>
	<52616820.8000603@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52616820.8000603@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 18, 2013 at 11:56:00AM -0500, Rich Johnston wrote:
> This has been committed.
> 
> Thanks
> --Rich
> 
> commit 41315687d9db9b50876401e7b0ee20dd77cfc712
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Mon Sep 30 03:15:19 2013 +0000
> 
>     xfs: dirent dtype presence is dependent on directory magic numbers

Committed where, exactly?

This is a kernel patch that has already been committed and been
pushed upstream to linus as commit 6d31349....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
