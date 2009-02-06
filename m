Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n16KRjxm049577 for <xfs@oss.sgi.com>; Fri, 6 Feb 2009 14:27:47 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21C62F6266
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2009 12:27:06 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id lPRzDyUhGx0KoNaY for
	<xfs@oss.sgi.com>; Fri, 06 Feb 2009 12:27:06 -0800 (PST)
Subject: Re: Inode Core Information
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <21872592.post@talk.nabble.com>
References: <21872592.post@talk.nabble.com>
Date: Sat, 07 Feb 2009 06:12:26 +1100
Message-Id: <1233947546.4556.13.camel@verge.scott.net.au>
Mime-Version: 1.0
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
To: cyjoyp <cyjoyp@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, 2009-02-06 at 05:41 -0800, cyjoyp wrote:
> Hello Everyone,
>       Could any one help in extracting the modified time information from
> xfs_dinode_core_t   structure (Inode Core)?
>      Please help me.

$ man 2 stat

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
