Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 15E3A7F3F
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 22:37:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 961A8AC008
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 20:37:57 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wQC2HUu7LK5z2Bq9 for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 20:37:51 -0800 (PST)
Date: Fri, 7 Nov 2014 15:37:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141107043718.GJ23575@dastard>
References: <CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
	<20141030230457.GK13323@dastard> <20141031000954.GL13323@dastard>
	<CAGdb-8dP7nah4QuXYk_S8KbEu4Y6ZiT7tXz7dMLkwZ=VTkKQXA@mail.gmail.com>
	<20141031034925.GM13323@dastard> <20141031042511.GN13323@dastard>
	<CAGdb-8d7fb302zwaVwA0qVcCGEgRuzJStmF6sKdSak7uQpywrw@mail.gmail.com>
	<CAGdb-8cynz7bhHLrBe+3J03yYbo_oAmDorwZ0E2=s4huuW8tfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdb-8cynz7bhHLrBe+3J03yYbo_oAmDorwZ0E2=s4huuW8tfQ@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On Fri, Nov 07, 2014 at 09:05:55AM +0800, Tommy Wu wrote:
> just update to xfs-fixes-for-3.18-rc3.
> it work fine now.

Thanks for reporting the problem, providing all the information
necessary to fix it and for testing the fixes!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
