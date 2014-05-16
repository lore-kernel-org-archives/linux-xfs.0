Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C5737F3F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 17:19:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85CA130405F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 15:19:40 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	isDo8ASIhTeSUdKf for <xfs@oss.sgi.com>;
	Fri, 16 May 2014 15:19:35 -0700 (PDT)
Date: Sat, 17 May 2014 08:19:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfstests: new mailing list
Message-ID: <20140516221930.GA8554@dastard>
References: <20140516044611.GA8206@dastard>
	<20140516054009.GA17647@infradead.org>
	<alpine.LFD.2.00.1405161047010.2099@localhost.localdomain>
	<20140516085320.GA29279@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140516085320.GA29279@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Luk?? Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, May 16, 2014 at 01:53:20AM -0700, Christoph Hellwig wrote:
> On Fri, May 16, 2014 at 10:48:42AM +0200, Luk?? Czerner wrote:
> > > > As requested I've created a new mailing list for xfstests
> > > > development and discussion. Reflecting the fact that the test
> > > > harness is not really XFS specific anymore, the list is:
> > > > 
> > > > 	fstests@vger.kernel.org
> > > 
> > > Isn't there an "x" missing somewhere?
> > 
> > It's intentional and it is "Reflecting the fact that the test
> > harness is not really XFS specific anymore", even though the test
> > suite itself keep the name xfstests.
> > 
> > This way it's more obvious to people that this is in fact not xfs
> > specific.
> 
> Having the name different from the project it is for is stupid.  Either
> rename the test suite, or use the same name for the mailing list.

Renaming the test suite take a lot more work - .e.g renaming/moving
source trees and a fixing all the documentation that points to it...

So, small steps.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
