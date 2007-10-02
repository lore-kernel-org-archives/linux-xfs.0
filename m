Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 00:17:40 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l927HYgi007751
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 00:17:36 -0700
Subject: Re: REVIEW: xfs_reno
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 17:20:01 +1000
Message-Id: <1191309601.15908.217.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, 2007-10-02 at 17:08 +1000, Barry Naujok wrote:
> The attached tool allows an inode64 filesystem to be converted to inode32.
> For this to work, the filesystem has to be mounted inode32 before it's run.
> 
> I'm not sure if there is any packaging changes required.

I expect not, the Makefile handles that.  Is there a man page?

cheers.

--
Nathan
