Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66E757F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 16:55:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 613D88F8033
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 14:55:39 -0800 (PST)
Date: Sat, 16 Jan 2016 09:55:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs deadlocks since upgrading to 4.1.15
Message-ID: <20160115225508.GQ6033@dastard>
References: <5698B6EE.4000502@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5698B6EE.4000502@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jan 15, 2016 at 10:07:58AM +0100, Stefan Priebe wrote:
> Hello,
> 
> since we upgraded from 3.18 to 4.1.15 i've seen many deadlocks. Alle
> call traces show xfs.
> 
> Attention all those are down top instead of top down (sorry for the
> wrong order).

Can you repost them with line wrapping turned off, so they are
readable without causing beeding eye syndrome?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
