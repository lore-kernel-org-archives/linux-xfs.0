Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFB907CBE
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2015 17:35:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D58838F8054
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2015 15:35:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	l07DKl2WWCh1KexH for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2015 15:35:46 -0700 (PDT)
Date: Wed, 22 Apr 2015 08:35:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_WANT_CORRUPTED_GOTO at line 1545 of file fs/xfs/xfs_alloc.c
Message-ID: <20150421223532.GM21261@dastard>
References: <1429589421630-35029.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1429589421630-35029.post@n7.nabble.com>
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
To: beebol <ww103421245@163.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 20, 2015 at 09:10:21PM -0700, beebol wrote:
> This is what causes the problem, whether it can be reproduced?
> How to fix this problem?
> 
> Looking forward to your reply.
> information:
> #cat /etc/redhat-release 
> Red Hat Enterprise Linux Server release 5.3 (Tikanga)
> 
>  #uname -a
> Linux 1046_qd_119_cnc 2.6.18-194.el5 #1 SMP Tue Mar 16 21:52:39 EDT 2010
> x86_64 x86_64 x86_64 GNU/Linux

You need to report the problem to Red Hat. Nobody else is going to
be able to fix that kernel for you if, indeed, there is a problem
that can be isolated and it points to a bug that can be fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
