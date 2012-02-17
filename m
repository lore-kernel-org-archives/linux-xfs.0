Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HE1c49087653 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 08:01:39 -0600
Message-ID: <4F3E5DC0.9020900@sgi.com>
Date: Fri, 17 Feb 2012 08:01:36 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH -v2 1/3] xfs: change available ranges of softlimit and
	hardlimit in quota check
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
	<20120206125007.12624.58454.stgit@ltc219.sdl.hitachi.co.jp>
	<4F357FEF.5080507@sgi.com>
In-Reply-To: <4F357FEF.5080507@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: xfs@oss.sgi.com


>
> Good catch on the off by one page comparisons. I like the patch.
>
> Question: I know this was like this before, but why is the 64 bit counts
> and limits being casted into integers for these tests inside the DEBUG?
>


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
