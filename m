Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 189F67F53
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 21:58:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A964FAC002
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 19:58:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nz67mS7poibVinuL for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 19:58:14 -0700 (PDT)
Date: Sat, 3 May 2014 12:58:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: 3.2.0-rc2 release tagged
Message-ID: <20140503025800.GI26353@dastard>
References: <20140502000508.GA26353@dastard>
 <536437AD.9020303@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536437AD.9020303@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, May 02, 2014 at 07:26:21PM -0500, Eric Sandeen wrote:
> On 5/1/14, 7:05 PM, Dave Chinner wrote:
> > Hi folks,
> > 
> > The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
> > just been updated.
> > 
> > The new head of the master branch is commit:
> > 
> > 67fcc94 xfsprogs: v3.2.0-rc2 release
> > 
> > This commit has been tagged with v3.2.0-rc2. I'd like everyone who
> > can test this to test it, as all the issues that needed to be solved
> > before a release coul dbe made have now been addressed. If there are
> > no new regressions or critical issues reported in the next week or
> > so, I will make an official 3.2.0 release. So, please test. :)
> 
> Any chance for a signed tarball?

Do we need one? I can generate one, but I'm not 100% sure where we
are putting them up online....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
