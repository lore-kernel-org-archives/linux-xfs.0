Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D7sFI2205155 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 02:54:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AEC0126ED63
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 00:56:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	2FSlddfQsgmFP8r0 for <xfs@oss.sgi.com>;
	Tue, 13 Apr 2010 00:56:07 -0700 (PDT)
Date: Tue, 13 Apr 2010 17:56:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT] branch tracking reviewed patches
Message-ID: <20100413075604.GU2493@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

Alex,

I've just pulled all the oustanding reviewed patches into a branch
in my git tree. I'm going to try to push all such reviewed patches
that aren't in the main xfs-dev tree into this branch so I don't
lose track of them and they still get QA time rather than slowly
bitrotting on the list. The branch that contains these is at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git for-dev

I'm also going to try to maintain a branch that contains patches
that haven't completed the review process, once again for tracking
purposes. This will probably only contain patches that don't require
massaging to apply. That branch can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git for-review

Note that I will be rebasing these branches, so only pull them
into temporary/disposable branches if you want to look at them or
use them.

Every so often I'll send a pull request for the for-dev branch;
if the branch has not been pulled into the xfs-dev tree and I update
the branch I'll send another pull req to let you know that I've
updated it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
