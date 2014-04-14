Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4EE887F4E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 04:46:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DDE830404E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 02:46:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Tc2CGm6oD5jx3uxK for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 02:46:38 -0700 (PDT)
Date: Mon, 14 Apr 2014 19:46:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 00/11] xfs: introduce the free inode btree
Message-ID: <20140414094632.GC31578@dastard>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 12:08:25PM -0400, Brian Foster wrote:
> Hi all,
> 
> This is a minor rebase of the finobt series on the latest for-next
> branch. The previous version (v4) is here:
> 
> http://oss.sgi.com/archives/xfs/2014-02/msg00763.html
> 
> The most recent series with review feedback is v3:
> 
> http://oss.sgi.com/archives/xfs/2014-02/msg00121.html
> 
> Brian

I've just had a look at this series, and I haven't found anything to
complain about apart from a couple of stray whitespaces that I
fixed. I'm going to run it through some finobt=0 test runs until i
get a chance to look at the userspace patches. If I don't notice
anything in the next couple of days, I'll merge the topic branch
into the main tree....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
