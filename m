Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F7E57CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 00:00:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAB5C304032
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 22:00:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	d2SbuyzhjwyDGHBb for <xfs@oss.sgi.com>;
	Tue, 10 May 2016 22:00:15 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1b0MFp-0001OE-4B
	for xfs@oss.sgi.com; Wed, 11 May 2016 15:00:13 +1000
Date: Wed, 11 May 2016 15:00:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: master branch updated to c5d584c
Message-ID: <20160511050013.GX18496@dastard>
References: <20160511002607.GK26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160511002607.GK26977@dastard>
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
To: xfs@oss.sgi.com

On Wed, May 11, 2016 at 10:26:07AM +1000, Dave Chinner wrote:
> Hi Folks,
> 
> The xfsprogs repository at:
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated. Note that this includes the change of mkfs
> command line parsing, so you will see some additional xfstests
> failures resulting from that. Those should be fixed soon as filters
> and changes are made to xfstests to handle these differences.

FYI: I just updated the for-next branch to point at the same commit
as I forgot to do that. The for-next branch rebased in doing this,
so don't be suprised if it won't fast forward...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
