Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E02507CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 18:23:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7911F8F8054
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 16:23:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RCCccECrJDr6a1v8 for <xfs@oss.sgi.com>;
	Wed, 11 May 2016 16:23:37 -0700 (PDT)
Date: Thu, 12 May 2016 09:23:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7] Configurable error behavior [V4]
Message-ID: <20160511232336.GZ18496@dastard>
References: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
	<20160511141558.GE42410@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160511141558.GE42410@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Wed, May 11, 2016 at 10:15:59AM -0400, Brian Foster wrote:
> On Tue, May 10, 2016 at 02:16:14PM +0200, Carlos Maiolino wrote:
> > New revision ot the patchset according with comments for V3.
> > 
> > This patchset is aimed to implement a configurable error behavior in XFS, and,
> > most of the design has been done by Dave, so, I kept his signed-off.
> > 
> > Detailed changelog is written on each patch, but, major changes are:
> > 
> > 	- make fail_at_unmount a global configuration option inside
> > 	  ../xfs/<dev>/err/fail_at_unmount
> > 
> 
> Any reason you didn't carry the reviewed-by tags from v3?
> 
> For Dave's convenience (and based on the reviews of v3 and v4), for the
> series:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks, Brian.

Carlos, no need to resend, I'll fix the typos up on merge.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
