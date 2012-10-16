Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9GFt7WM161346 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 10:55:07 -0500
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D889AC006
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 08:56:41 -0700 (PDT)
Date: Tue, 16 Oct 2012 10:56:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: master branch fast-forwarded to v3.7-rc1
Message-ID: <20121016155640.GA1377@sgi.com>
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
To: xfs@oss.sgi.com

Hi XFS Folks,

Linux v3.7-rc1 is out.  The XFS master branch
(git://oss.sgi.com/xfs/xfs.git) has been fast-forwarded to v3.7-rc1.

We'd like to take a moment and let you all know that we at SGI are going
to make an effort to communicate more from our end.  Your contribution
is appreciated whether it be features, testing, reviews, docs,
refactoring, cheerleading, or otherwise.  We want you here, and we want
your help!  We'll continue to try to be as responsive as possible.

Please bear in mind that the master branch is a shared resource.  We XFS
developers need a stable and bug free environment to work in and test
our changes.  We simply cannot pull in work with known regressions
because that can stop _all_ development until the problems are resolved.

Much more importantly, our end users have every reason to expect release
quality software when they choose to run tagged releases from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.
People entrust XFS with their data, so the stakes are high.  Developers
and testers who run upstream kernels between releases also have every
reason to expect quality.  XFS must not bottleneck their development
efforts through regression.  We must all be committed to a consistently
high level of quality, and this comes before our own convenience as
developers.

When submitting work to the xfs@oss.sgi.com mailing list, please
remember to follow the rules described in your kernel sources under
Documentation/SubmittingPatches, and those in the intro of the
MAINTAINERS file.  In the MAINTAINERS file there is specific emphasis in
#1 on testing patches.  Please take this to heart.  SGI is committed to
testing patches before pulling them in.  And as developers, we each need
to thoroughly test our patches before posting.  Also, please don't get
discouraged if colleagues find bugs in your code by inspection or
through testing.  It happens sometimes.  We shouldn't rake each other
over the coals for it.

Again, thanks to each of you for your participation.  Please continue to
treat each other with respect in your reviews and try to remember that
everyone is doing their best with a complicated project.  Lets try to
keep a friendly and collegial atmosphere on the mailing list.  We should
all be able to have some fun while working on XFS!

Happy hacking!

-The XFS Team @ SGI

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
