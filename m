Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p23FtTkn101468 for <xfs@oss.sgi.com>; Thu, 3 Mar 2011 09:55:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF7681AECA0D
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 07:58:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uIvgyLBwPFjVgIQa for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2011 07:58:20 -0800 (PST)
Date: Thu, 3 Mar 2011 10:58:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: help: xfstests building error.
Message-ID: <20110303155820.GA16797@infradead.org>
References: <AANLkTi=22hZYrWGq_iTt_CesPuJmpn03SEt-QDj=ufAL@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=22hZYrWGq_iTt_CesPuJmpn03SEt-QDj=ufAL@mail.gmail.com>
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
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 25, 2011 at 11:25:47AM +0800, Yongqiang Yang wrote:
> Hi everyone,
> 
> Is this the right mailing list???
> 
> When I build xfstests, I get errors as follows.
> autoheader
> autoconf

You shouldn't need to run these manually.  A simple make on a pristine
source tree calls the right auto tools.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
