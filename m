Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61CCA29DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 16:21:46 -0500 (CDT)
Date: Thu, 1 Aug 2013 16:21:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/49] current patch queue for 3.12
Message-ID: <20130801212142.GB3111@sgi.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

We missed you on the call today.  We discussed 3.12 content:

This series remains the primary focus for 3.12.  Mark has completed the review
of the 3.12 kernel work, and sent a couple patches related to patches 44 and 46
of this series to you via private email.  It sounds like there are still a
couple of issues that need to be addressed and this doesn't apply starting
around patch 14.  Sounds like if you resolve that and repost we can start
pulling this series in...

Mark has moved on to reviewing the most recent xfsprogs series for the libxfs
sync.

I am still working on review of the crc-dev series, and will be pulling them
into the master branch as my concerns are addressed.  No objection to adding
patches on the end, I just need to match them up with the issues they address.
I'll probably try to resolve some of them myself once I'm through my first pass
of review.

We'll be holding off on Eric's recent posts as well as Dwight and Zhi's work
until after all three series have been committed.  If someone objects we'll
have that conversation.

Chandra has posted some quota related work that would be nice to have in
xfsprogs for the release.  He may need to rebase after we pull your work in.

That's about it.  I'll post my notes from the meeting on the xfs.org wiki.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
