Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 890B87F52
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 18:23:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 750F18F8049
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 16:23:23 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gp3KEae1g48bBWCi for <xfs@oss.sgi.com>;
	Fri, 11 Apr 2014 16:23:21 -0700 (PDT)
Date: Sat, 12 Apr 2014 09:23:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] renameat2 syscall: add infrastructure
Message-ID: <20140411232317.GA27694@dastard>
References: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@suse.cz>, xfs@oss.sgi.com

On Fri, Apr 11, 2014 at 05:51:54PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The renameat2() syscall was merged into 3.15-rc (merge commit: 7df934526c0b).
> 
> This adds the shared infrastructure for the actual test scripts.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Hi Miklos, all 4 patches look good now, so I'll pull them in with
the next round of xfstests updates. I'll let ou know if there are
any other problems I find. Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
