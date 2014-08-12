Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 36F9F7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 16:54:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1DB38F8087
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 14:54:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KsvJUfBiz8zKhWnh for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 14:53:58 -0700 (PDT)
Date: Wed, 13 Aug 2014 07:53:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] xfs: updates for 3.17-rc1
Message-ID: <20140812215344.GY20518@dastard>
References: <20140812125313.GX20518@dastard>
	<20140812235612.684a9af7@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140812235612.684a9af7@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 12, 2014 at 11:56:12PM +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Tue, 12 Aug 2014 22:53:13 +1000 Dave Chinner <david@fromorbit.com> wrote:
> >
> > FYI, this will be the last pull request I will send you from a tree
> > on oss.sgi.com. I'm moving everything XFS related over to kernel.org
> > so future pull requests should come from there.
> 
> Please let me know when you have the new tree set up so I can change
> where I fetch from.

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git for-next

It should be identical to the xfs tree you are pulling from
oss.sgi.com.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
