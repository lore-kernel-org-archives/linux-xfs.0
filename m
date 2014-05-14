Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADABA7F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 16:35:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33767AC00D
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 14:35:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	giBXS83hfPjnVEzx for <xfs@oss.sgi.com>;
	Wed, 14 May 2014 14:35:45 -0700 (PDT)
Date: Thu, 15 May 2014 07:35:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Separate mailing list for xfstests
Message-ID: <20140514213529.GT26353@dastard>
References: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
	<53738316.20601@redhat.com> <53738597.70305@fb.com>
	<20140514160447.GA3974@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140514160447.GA3974@thunk.org>
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
To: tytso@mit.edu
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com, Chris Mason <clm@fb.com>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Wed, May 14, 2014 at 04:04:47PM +0000, tytso@mit.edu wrote:
> On Wed, May 14, 2014 at 11:02:47AM -0400, Chris Mason wrote:
> > >> linux-fsdevel might seem as a good candidate for it, but still I
> > >> think that it deserves a separate ML to point people to.
> 
> I'm personally in favor of using linux-fsdevel since it might
> encourage more fs developers who aren't using xfstests yet to start
> using it.

I'd prefer a separate mailing list - I don't really like the idea of
burying general lists in large amounts of specific topic-related
traffic. That way lies lkml - a dumping ground for everything that
has no stopic-related lists and that results in a very low signal to
noise ratio. Comparitively speaking, -fsdevel has a high SNR, so we
should try to keep it that way. ;)

That said, I can see the value in sending update/release
announcements to -fsdevel, but I'd prefer to keep all the xfstests
traffic separate.  A separate list makes things like archive
searching and patch tracking much simpler....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
