Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B6117F62
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 15:39:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F5D58F8066
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 13:39:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	O97lbGMXgHxEXfvt for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 13:39:36 -0700 (PDT)
Date: Wed, 10 Jul 2013 06:39:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/15] xfs: dquot log reservations are too small
Message-ID: <20130709203931.GJ3438@dastard>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-15-git-send-email-david@fromorbit.com>
	<1372439902.8341.155.camel@chandra-dt.ibm.com>
	<20130629024205.GF9047@dastard> <20130709193128.GT20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130709193128.GT20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Tue, Jul 09, 2013 at 02:31:28PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Sat, Jun 29, 2013 at 12:42:05PM +1000, Dave Chinner wrote:
> > I'll fix up the various typos and clarify the comments as you've
> > suggested.
> 
> Are you still planning on reposting this one for 3.11?

Yes. I was waiting for you to push out an updated tree so I could
rebase everything I have before reposting....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
