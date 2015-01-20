Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E20237F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 16:16:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1271304048
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 14:16:20 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	X3FMfijZna6SRMxY for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 14:16:18 -0800 (PST)
Date: Wed, 21 Jan 2015 09:14:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: Remove useless test
Message-ID: <20150120221453.GE16552@dastard>
References: <1421317085-14350-1-git-send-email-jack@suse.cz>
	<1421317085-14350-2-git-send-email-jack@suse.cz>
	<20150115132754.GA23696@bfoster.bfoster>
	<20150120164400.GB3648@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150120164400.GB3648@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Jan 20, 2015 at 05:44:00PM +0100, Jan Kara wrote:
> On Thu 15-01-15 08:27:54, Brian Foster wrote:
> > On Thu, Jan 15, 2015 at 11:18:03AM +0100, Jan Kara wrote:
> > > Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
>   Thanks for reviews! I've pulled the XFS cleanups from this series into my
> tree.

Hi Jan,

I've been at LCA last week and sick all this week as a result, so I
haven't yet got to pulling these into the XFS tree. Do you still
want me to give you a stable branch with these changes in it to base
your series off?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
