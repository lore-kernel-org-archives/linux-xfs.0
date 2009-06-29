Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5TEcrPs137076 for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 09:38:53 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E49061310A62
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 07:39:23 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id YCdkr5QFLyZeA3cL for
	<xfs@oss.sgi.com>; Mon, 29 Jun 2009 07:39:23 -0700 (PDT)
Message-ID: <4A48D218.5050208@sandeen.net>
Date: Mon, 29 Jun 2009 09:39:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] add more statics & drop some unused functions
References: <4A1C3D65.4020306@sandeen.net>
	<20090527102319.GA28274@infradead.org>
In-Reply-To: <20090527102319.GA28274@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, May 26, 2009 at 02:05:09PM -0500, Eric Sandeen wrote:
>> A lot more functions could be made static, but they need
>> forward declarations; this does some easy ones, and also 
>> found a few unused functions in the process.
> 
> Looks good to me.
> 

Felix, do you plan to merge this one?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
