Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CA3D7F4E
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 17:25:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD053AC002
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 15:25:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LEhJm3vD1YyAhLnf for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 15:25:30 -0700 (PDT)
Date: Wed, 23 Oct 2013 09:25:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/32] xfs: unify directory/attribute format definitions
Message-ID: <20131022222526.GE2797@dastard>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-10-git-send-email-david@fromorbit.com>
	<52619AFA.60006@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52619AFA.60006@sgi.com>
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

On Fri, Oct 18, 2013 at 03:32:58PM -0500, Rich Johnston wrote:
> Sorry Dave i did not realize I needed to do a make clean first.
> 
> This has been commited.
> 
> Thanks
> --Rich
> 
> commit ddd5a16201db90a255952f61c34aeaab67d0a845
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Mon Sep 30 03:15:21 2013 +0000
> 
>     xfs: unify directory/attribute format definitions

FWIW, this is another patch that has not yet been committed to the
kernel code yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
