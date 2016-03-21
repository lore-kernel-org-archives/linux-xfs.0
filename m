Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBB467CA3
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 17:41:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A382B30405F
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 15:41:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tblLVk8QCFIdael1 for <xfs@oss.sgi.com>;
	Mon, 21 Mar 2016 15:41:15 -0700 (PDT)
Date: Tue, 22 Mar 2016 09:40:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] xfs: updates for 4.6-rc1
Message-ID: <20160321224057.GO11812@dastard>
References: <20160321020505.GJ11812@dastard>
	<CA+55aFy4NNR+VUD=KpLE=vMz22xrQ7E5J8A_B-Pf4Hj8GjBVFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFy4NNR+VUD=KpLE=vMz22xrQ7E5J8A_B-Pf4Hj8GjBVFQ@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 21, 2016 at 11:59:54AM -0700, Linus Torvalds wrote:
> On Sun, Mar 20, 2016 at 7:05 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > There are conflicts with the ext4 code that has already been merged
> > this cycle.
> 
> The merge looked pretty straightforward, but both of you (ie both the
> xfs and ext4 people, please) should check the end result please.
> 
> My sanity-check is still building, but it should be all pushed out in
> another 15 minutes or so.

Merged XFS bits look fine, ext4 parts look ok according to Jan's
last comments.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
