Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCC0229DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 20:50:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C56BC3040BA
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 18:50:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PJ8H1xY1fNPSPz1Q for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 18:50:34 -0700 (PDT)
Date: Fri, 2 Aug 2013 11:50:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfsprogs: Allow pquota and gquota to be used together
Message-ID: <20130802015032.GY7118@dastard>
References: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1375385101-3673-1-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 01, 2013 at 02:24:59PM -0500, Chandra Seetharaman wrote:
> Hello All,
> 
> These two patches make the relevant user space changes to support
> the gquota/pquota in kernel.
> 
> It applies cleanly on crc-dev branch of xfsprogs.

I think I've already brought all of the libxfs pquota changes across
in the series of patches I have that unified the kernel and
userspace code on top of the crc-dev branch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
