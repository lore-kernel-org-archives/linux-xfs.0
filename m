Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7OMtHOk205200 for <xfs@oss.sgi.com>; Tue, 24 Aug 2010 17:55:18 -0500
Subject: Re: [GIT Review] xfs: 2.6.36 fixes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100824024445.GJ31488@dastard>
References: <20100824024445.GJ31488@dastard>
Date: Tue, 24 Aug 2010 17:54:58 -0500
Message-ID: <1282690498.1885.74.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-08-24 at 12:44 +1000, Dave Chinner wrote:
> Folks,
> 
> Can you please cast an eye over the the tree below to check that all
> the bug fixes that need to go into 2.6.36 are there? If so, I'll
> send a pull request to Linus tomorrow.
> 
> Note that these are just the outstanding bug fixes that have been
> reviewed (as Linus has again decreed for pull requests after -rc1),
> so it not the complete set of reviewd patches that exist.
> 
> Cheers,
> 
> Dave.

All of these commits look good to me.  I will have these
and all the rest published on the oss.sgi.com tree later
this week.  I've been on vacation and have gotten behind.

Reviewed-by: Alex Elder <aelder@sgi.com>

> 
> The following changes since commit 9ee47476d6734c9deb9ae9ab05d963302f6b6150:
> 
>   Merge branch 'radix-tree' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev (2010-08-22 19:55:14 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git 2.6.36-fixes
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
