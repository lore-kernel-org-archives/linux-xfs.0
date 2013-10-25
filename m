Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B977A7F4E
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 10:02:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45F2EAC014
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 08:02:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ClwfDy972lzNHLqd for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 08:02:14 -0700 (PDT)
Message-ID: <526A87F4.2020207@sandeen.net>
Date: Fri, 25 Oct 2013 10:02:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: linux-3.12 userspace
References: <526A6FF9.8000506@sgi.com>
In-Reply-To: <526A6FF9.8000506@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 10/25/13 8:19 AM, Rich Johnston wrote:
> Hey Folks,
> 
> Dave Chinner has a 32 part userspace patchset that needs to be reviewed
> and will be committed to coincide with the linux-3.12 kernel release.
> 
> Are there other userspace patches that support 3.12 kernel features that
> need to be worked?
> 
> All other patches on the list will be held back until the linux-3.13
> merge window has opened.

Are you talking about holding back kernelspace or userspace patches?

We'd want to get kernelspace merged in the xfs git tree well before
the merge window, and I don't think the kernel merge window needs to
affect userspace merges.

Can you talk in more specifics (which series/patches, for what codebase)
you're proposing?

In general I think we simply have a review bottleneck, but once patchsets
are reviewed, in general, they should just get merged, especially in userspace,
IMHO.

But maybe I just need more details.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
