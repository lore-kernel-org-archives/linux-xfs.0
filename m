Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DMPtEe103090 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 17:25:56 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AC0615F3CEB
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 15:25:54 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id YuYrURECjpkHXZkp for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2011 15:25:54 -0700 (PDT)
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6DM3gbm023145
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 18:03:42 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6DMPoY4189884 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 18:25:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6DMPnPT013827 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 19:25:49 -0300
Message-ID: <4E1E1B6A.3000808@linux.vnet.ibm.com>
Date: Wed, 13 Jul 2011 15:25:46 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4 v3] XFS TESTS: Fix 252 failure
References: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
	<20110713123824.GA15139@infradead.org>
In-Reply-To: <20110713123824.GA15139@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 07/13/2011 05:38 AM, Christoph Hellwig wrote:
> I have applied the series.  I had to merge patches 1 to 3 into a single
> commit to keep thing bisectable, though.
>
Thx Christoph, I will be sure to keep patches bisectable from now on.  :)

Allison

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
