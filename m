Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D70B7F52
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 20:41:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29A648F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 18:41:07 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	n8EIeS7jB2kr2BXl for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 18:41:05 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1Uklfq-00048D-Tz
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 11:41:02 +1000
Date: Fri, 7 Jun 2013 11:41:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 48/48] xfsprogs: Document XFs specific mount options in
	xfs(5)
Message-ID: <20130607014102.GI29338@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-49-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-49-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:26:11AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rather than reference mount(8) to see xfs specific mount options,
> document them directly in the xfs(5) man page in this package. That
> way it is easy to update XFS mount options when the change.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I didn't mean to include this patch in the series - it's not
completely up to date yet....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
