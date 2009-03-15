Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBUX7T006780 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:30:53 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3348A1C43838
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:30:10 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	meeS39OwI40SGZQ7 for <xfs@oss.sgi.com>;
	Sun, 15 Mar 2009 04:30:10 -0700 (PDT)
Date: Sun, 15 Mar 2009 22:11:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] [XFS] Spurious ENOSPC fixes
Message-ID: <20090315111149.GX26138@disturbed>
References: <1237114679-18808-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237114679-18808-1-git-send-email-david@fromorbit.com>
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
Cc: mpatocka@redhat.com

On Sun, Mar 15, 2009 at 09:57:54PM +1100, Dave Chinner wrote:
> This series fix the spurious ENOSPC problems reported by and
> partially solved by Mikulas Patocka. This series makes the recently
> posted QA tests 203 and 204 pass.
> 
> Mikulas, if I've got any of the attributions wrong for the
> bits of your code I used, let me know and I'll fix them.

I'm about to resend these with the correct sign-off
(i.e. david@fromorbit.com). Please ignore all the patches
with a different signed-off by.

[ I screwed up the .gitconfig earlier today when setting up a
new build/test box and didn't notice that the local commits
in the kernel tree had the wrong address... ]

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
