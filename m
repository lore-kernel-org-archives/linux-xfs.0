Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5TGbE4V146949 for <xfs@oss.sgi.com>; Fri, 29 Jun 2012 11:37:14 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id OUQA5ZfXbtFbY2XJ for
	<xfs@oss.sgi.com>; Fri, 29 Jun 2012 09:37:12 -0700 (PDT)
Message-ID: <4FEDD9B4.7040904@cn.fujitsu.com>
Date: Sat, 30 Jun 2012 00:37:08 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: cleanup the mount options
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120627174448.GA3278@infradead.org>
	<4FEBAB3B.6020707@cn.fujitsu.com>
	<20120628160156.GC29979@sgi.com> <4FEC8768.8000109@zabbo.net>
	<4FECFE26.2040506@cn.fujitsu.com> <4FEDD7E8.901@zabbo.net>
In-Reply-To: <4FEDD7E8.901@zabbo.net>
Reply-To: gaowanlong@cn.fujitsu.com
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
To: Zach Brown <zab@zabbo.net>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 06/30/2012 12:29 AM, Zach Brown wrote:
> 
>> If you know XFS code, you really needn't cscope lookups on these
>> easy enough mount options. Don't stick to cscope lookups all the time.
> 
> That's nonsense.  It has nothing to do with "knowing" the identifiers,
> it's about giving tools the ability to move to them quickly.
> 
> Ben stated his preference, I seconded it.  You have the data and can
> chose to ignore it.  Let's move on.
> 

OK, I can drop the xfs_*_opt macros in V2, and any comments about the
parse options? I'd like to see the comments about the rest parts.

Thanks,
Wanlong Gao

> - z
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
