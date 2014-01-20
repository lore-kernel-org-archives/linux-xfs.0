Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1364A7F51
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 23:46:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE7C5304039
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 21:46:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xZNxDXgpinwybSU8 for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 21:46:27 -0800 (PST)
Date: Mon, 20 Jan 2014 16:46:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfstests: A few updates to non-test code
Message-ID: <20140120054624.GI18112@dastard>
References: <cover.1389891730.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Jan 16, 2014 at 06:07:10PM +0100, David Sterba wrote:
> Minor bugfixes or enhancements.
> 
> David Sterba (5):
>   xfstests: fix minor build warning
>   xfstests: use value of FSTYP if defined externally
>   xfstests: don't suggest to run full diff when DIFF_LENGTH is 0
>   xfstests: accept tests/ prefix for test name on commandline
>   xfstests: update lsqa.pl for new tests layout

Hi David, I committed the three patches that were OK, so if you can
fix up the other two and resubmit them, that'd be great.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
