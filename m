Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C0BB07F53
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 17:05:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F5718F8040
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 15:05:44 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FlKaB3563MjG8AFp for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 15:05:43 -0800 (PST)
Date: Thu, 28 Feb 2013 10:05:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 273: fix a typo
Message-ID: <20130227230541.GC5551@dastard>
References: <512DAC1A.2040601@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512DAC1A.2040601@gmail.com>
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
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 27, 2013 at 02:47:54PM +0800, Wang Sheng-Hui wrote:
> Make the porter log cp failure into $seq.full by appending, not overwriting,
> which can help debug.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Oops.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
