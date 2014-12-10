Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A951C7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 14:37:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97B4F30404E
	for <xfs@oss.sgi.com>; Wed, 10 Dec 2014 12:37:29 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	REeLiGmqmpDJDQzY for <xfs@oss.sgi.com>;
	Wed, 10 Dec 2014 12:37:27 -0800 (PST)
Date: Thu, 11 Dec 2014 07:37:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: max_dir_size_kb mount option test
Message-ID: <20141210203724.GA24183@dastard>
References: <54883E33.5050004@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54883E33.5050004@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 10, 2014 at 03:36:03PM +0300, Alexander Tsvetkov wrote:
> Hello Dave,
> 
> I've prepared test that runs some checks for ext4 mount option
> max_dir_size_kb introduced in Linux Kernel 3.7, could you please
> look on it?

Hi Alex, can you please resend this patch to fstests@vger.kernel.org
(which is now the fstests mailing list) and cc the ext4 list so the
ext4 developers can review it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
