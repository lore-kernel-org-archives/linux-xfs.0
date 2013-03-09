Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 89DAB7F87
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 03:01:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 172A7AC001
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 01:01:06 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XKygqm80xA1Bt8le for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 01:01:02 -0800 (PST)
Date: Sat, 9 Mar 2013 20:00:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs_repair: skip freelist scan of corrupt agf in
	no-modify mode
Message-ID: <20130309090041.GG23616@dastard>
References: <51313DE8.5080104@sandeen.net> <51326DC0.8030403@sandeen.net>
	<513A4A9B.3050802@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513A4A9B.3050802@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Ole Tange <tange@binf.ku.dk>

On Fri, Mar 08, 2013 at 02:31:23PM -0600, Rich Johnston wrote:
> This version looks good. ;)
> 
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> 
> This has been committed.

Except that all review comments have not been addressed. i.e there
are two places that have the same bug and they haven't been fixed.

It's great that you want to commit quickly, but commits should not
happen while there are unaddressed issues still outstanding....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
