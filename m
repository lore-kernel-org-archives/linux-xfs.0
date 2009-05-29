Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TEguOA060576 for <xfs@oss.sgi.com>; Fri, 29 May 2009 09:42:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F161F13022F1
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 07:49:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mWYNe028H6zhXXy7 for
	<xfs@oss.sgi.com>; Fri, 29 May 2009 07:49:17 -0700 (PDT)
Date: Fri, 29 May 2009 10:43:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsdump on mounted filesystem
Message-ID: <20090529144305.GA4882@infradead.org>
References: <8097683.3361243601669032.JavaMail.root@zcs-bi.informatik.uni-tuebingen.de>
	<8418003.3381243601790069.JavaMail.root@zcs-bi.informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8418003.3381243601790069.JavaMail.root@zcs-bi.informatik.uni-tuebingen.de>
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
To: Jan Schulze <schulze@informatik.uni-tuebingen.de>
Cc: xfs@oss.sgi.com

On Fri, May 29, 2009 at 02:56:30PM +0200, Jan Schulze wrote:
> Hi all,
> 
> is it advisable to use xfsdump on a mounted file system, or am I likely to be running into problems when doing so? 

In fact xfsdump requires a mounted filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
