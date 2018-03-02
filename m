Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:62753 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932121AbeCBWnN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 17:43:13 -0500
Date: Sat, 3 Mar 2018 09:43:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Change URL for the project in xfs.txt
Message-ID: <20180302224310.GV30854@dastard>
References: <20180302133013.9744-1-standby24x7@gmail.com>
 <20180302172401.GT19312@magnolia>
 <20180302215731.GT30854@dastard>
 <27d9f522-fa75-6766-3ca6-79f99522e861@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27d9f522-fa75-6766-3ca6-79f99522e861@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Masanari Iida <standby24x7@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org

On Fri, Mar 02, 2018 at 04:08:24PM -0600, Eric Sandeen wrote:
> 
> 
> On 3/2/18 3:57 PM, Dave Chinner wrote:
> > On Fri, Mar 02, 2018 at 09:24:01AM -0800, Darrick J. Wong wrote:
> >> On Fri, Mar 02, 2018 at 10:30:13PM +0900, Masanari Iida wrote:
> >>> The oss.sgi.com doesn't exist any more.
> >>> Change it to current project URL, https://xfs.wiki.kernel.org/
> >>>
> >>> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> >>> ---
> >>>  Documentation/filesystems/xfs.txt | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> >>> index 3b9b5c149f32..4d9ff0a7f8e1 100644
> >>> --- a/Documentation/filesystems/xfs.txt
> >>> +++ b/Documentation/filesystems/xfs.txt
> >>> @@ -9,7 +9,7 @@ variable block sizes, is extent based, and makes extensive use of
> >>>  Btrees (directories, extents, free space) to aid both performance
> >>>  and scalability.
> >>>  
> >>> -Refer to the documentation at http://oss.sgi.com/projects/xfs/
> >>> +Refer to the documentation at https://xfs.wiki.kernel.org/
> > 
> > Did I miss a memo?
> 
> About which part, the loss of oss.sgi or the addition of the kernel.org wiki?
> 
> The kernel.org wiki is pretty bare though.  OTOH xfs.org is a bit less
> official.  We really need to resolve this issue.

Moving everything to kernel.org wiki. As I mentioned on IRC, I'd
much prefer we move away from wiki's to something we can edit
locally, review via email, has proper revision control and a
"publish" mechanism that pushes built documentation out to the
public website.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
