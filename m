Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4282X8W016430 for <xfs@oss.sgi.com>; Wed, 2 May 2012 03:02:34 -0500
Received: from beaver.old-horrors.ru (mail.renton.name [90.155.165.44]) by
	cuda.sgi.com with ESMTP id TGdr1bgOOW2cCMYy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 May 2012 01:02:28 -0700 (PDT)
Date: Wed, 2 May 2012 12:02:20 +0400
From: Alexey Vlasov <renton@renton.name>
Subject: Re: Cleancache support in XFS
Message-ID: <20120502080220.GA20504@beaver>
References: <20120430173112.GA16257@beaver>
	<20120430191218.GA23530@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430191218.GA23530@infradead.org>
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
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 03:12:18PM -0400, Christoph Hellwig wrote:
> > 
> > Could you please tell me if you are planning to support cleancache in
> > XFS?
> 
> As soon as someone submits a patch.  In theory it should just work, but
> the cleancache maintainer require a completely idiotic one liner to
> actually enable it.  Feel free to submit it once you actually tested it.

Cleancache_init_fs () I can actually put where it it should be  but I
think it won't be enough. I think there some hooks needed (as for brtfs)
but I can't fix it as I'm far from programming.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
