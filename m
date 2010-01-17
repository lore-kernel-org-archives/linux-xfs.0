Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HFmrZO026142 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 09:48:53 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E03321C57AFA
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 07:49:51 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id X2G3njDyFkKtTjiw for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 07:49:51 -0800 (PST)
References: <4B50F2F0.4050909@sandeen.net>
	<20100117114036.GA7813@infradead.org>
Message-Id: <DEEAE699-2670-43C0-9185-7D070EEFD6C8@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20100117114036.GA7813@infradead.org>
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH] mkfs: get size of device properly
Date: Sun, 17 Jan 2010 09:49:50 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Jan 17, 2010, at 5:40 AM, Christoph Hellwig <hch@infradead.org>  
wrote:

>
> Reviewed-by: Christoph Hellwig <hch
> Any chance you could create a xfstests regression test for this?
>
Sure - it sorta catches itby failing elsewhere, but not obviously....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
