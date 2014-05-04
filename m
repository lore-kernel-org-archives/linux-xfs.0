Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FCCC7F57
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 16:55:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AC91304048
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 14:55:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xmHWYmFDsoAPajTP for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 14:55:47 -0700 (PDT)
Date: Mon, 5 May 2014 07:55:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: 3.2.0-rc2 release tagged
Message-ID: <20140504215533.GR26353@dastard>
References: <20140502000508.GA26353@dastard>
	<1461962146.20984.1399097936577.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461962146.20984.1399097936577.JavaMail.zimbra@redhat.com>
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
To: Nathan Scott <nathans@debian.org>
Cc: xfs@oss.sgi.com

On Sat, May 03, 2014 at 02:18:56AM -0400, Nathan Scott wrote:
> Hi Dave,
> 
> ----- Original Message -----
> > [...]
> > This commit has been tagged with v3.2.0-rc2. I'd like everyone who
> > can test this to test it, as all the issues that needed to be solved
> > before a release could be made have now been addressed. If there are
> > no new regressions or critical issues reported in the next week or
> > so, I will make an official 3.2.0 release. So, please test. :)
> > 
> 
> I came across a couple of trivial build warnings when doing a test
> build, and added a doc note for the debian/changelog - updates are
> in a git tree over here if you'd like to pull 'em in...
> 
> Changes committed to git://oss.sgi.com/nathans/xfsprogs.git master

Look good. I'll pull them in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
